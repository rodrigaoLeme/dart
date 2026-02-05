import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/sync/sync.dart';
import '../../domain/usecases/sync/sync.dart';
import '../../main/factories/sync/sync.dart';

/// Responsável pela migração dos dados locais para o Firestore
///
/// Gerencia:
/// = Detecção dedados locais existentes
/// - Detecção de ados na nuvem
/// - Resolução de conflitos
/// - Upload inicial de dados
/// - Download inicial de dados
class SyncMigrationService {
  final FirebaseAuth _firebaseAuth;

  late final UploadProgress _uploadProgress;
  late final DownloadProgress _downloadProgress;
  late final UploadHighlight _uploadHighlight;
  late final DownloadHighlights _downloadHighlights;
  late final UploadNote _uploadNote;
  late final DownloadNotes _downloadNotes;

  SyncMigrationService({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth {
    _initializeUseCases();
  }

  void _initializeUseCases() {
    _uploadProgress = SyncFactory.makeUploadProgress();
    _downloadProgress = SyncFactory.makeDownloadProgress();
    _uploadHighlight = SyncFactory.makeUploadHighlight();
    _downloadHighlights = SyncFactory.makeDownloadHighlights();
    _uploadNote = SyncFactory.makeUploadNote();
    _downloadNotes = SyncFactory.makekDownloadNotes();
  }

  // ========== DETECÇÃO ==========

  /// Verifica se existe dados locais (plan.pgs)
  Future<bool> hasLocalProgress() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plan.pgs');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Verifica se existe Marcações locais
  Future<bool> hasLocalHighlights() async {
    try {
      final box = await Hive.openBox('BooksHighlights');
      final hasData = box.isNotEmpty;
      await box.close();
      return hasData;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se existem notas locais
  Future<bool> hasLocalNotes() async {
    try {
      final box = await Hive.openBox('Notes');
      final hasData = box.isNotEmpty;
      await box.close();
      return hasData;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se existem dados no Firestore
  Future<bool> hasCloudData() async {
    try {
      final progress = await _downloadProgress();
      return progress != null;
    } catch (e) {
      return false;
    }
  }

  // FLUXO DE MIGRAÇÃO

  /// Migra dados do usuário
  ///
  /// Fluxo:
  /// 1. Verifica se tem dados locais
  /// 2. Verifica se tem dados na nuvem
  /// 3. Decide o que fazer baseado no cenário
  Future<MigrationResult> migrateUserData() async {
    final user = _firebaseAuth.currentUser;

    if (user == null || user.isAnonymous) {
      return MigrationResult.skipped('User is anonymous');
    }

    final hasLocal = await hasLocalProgress();
    final hasCloud = await hasCloudData();

    // Sem dados (nem local, nem nuvel)
    if (!hasLocal && !hasCloud) {
      return MigrationResult.success(
        scenario: MigrationScenario.noData,
        message: 'No data to migrate',
      );
    }

    // Tem dados locais, mas não tem na nuvem
    if (hasLocal && !hasCloud) {
      return await _uploadAllLocalData();
    }

    // Tem dados na nuvem, mas não tem local
    if (!hasLocal && hasCloud) {
      return await _downloadAllCloudData();
    }

    // Tem dados nos dois (Conflito)
    // Retorna resultado pedindo escolha do usuário
    return MigrationResult.conflict(
      localLastUpdated: await _getLocalLastUpdated(),
      cloudLastUpdated: await _getCloudLastUpdated(),
    );
  }

  /// Força upload de todos os dados locais (sobrescreve nuvem)
  Future<MigrationResult> forceUploadLocalData() async {
    try {
      return await _uploadAllLocalData();
    } catch (e) {
      return MigrationResult.error('Failed to upload: $e');
    }
  }

  /// Força download de todos os dados da nuvem (sobrescreve local)
  Future<MigrationResult> forceDownloadCloudData() async {
    try {
      return await _downloadAllCloudData();
    } catch (e) {
      return MigrationResult.error('Failed to download: $e');
    }
  }

  // ========== UPLOAD ==========

  Future<MigrationResult> _uploadAllLocalData() async {
    try {
      int itemsUploaded = 0;

      // 1. Upload progress
      final progress = await _loadLocalProgress();
      if (progress != null) {
        await _uploadProgress(progress);
        itemsUploaded++;
      }

      // 2. Upload marcações
      final highlights = await _loadLocalHighlights();
      for (final highlight in highlights) {
        await _uploadHighlight(highlight);
        itemsUploaded++;
      }

      // 3. Upload notas
      final notes = await _loadLocalNotes();
      for (final note in notes) {
        await _uploadNote(note);
        itemsUploaded++;
      }

      return MigrationResult.success(
        scenario: MigrationScenario.uploadedLocal,
        message: 'Uploaded $itemsUploaded items',
        itemsProcessed: itemsUploaded,
      );
    } catch (e) {
      return MigrationResult.error('Upload failed: $e');
    }
  }

  // ========== DOWNLOAD ==========

  Future<MigrationResult> _downloadAllCloudData() async {
    try {
      int itemsDownloaded = 0;

      // 1. Download od progresso
      final progress = await _downloadProgress();
      if (progress != null) {
        await _saveLocalProgress(progress);
        itemsDownloaded++;
      }

      // 2. Download das marcaçÕes
      final highlights = await _downloadHighlights();
      await _saveLocalHighLights(highlights);
      itemsDownloaded += highlights.length;

      // 3. Download das notas
      final notes = await _downloadNotes();
      await _saveLocalNotes(notes);
      itemsDownloaded += notes.length;

      return MigrationResult.success(
        scenario: MigrationScenario.downloadedCloud,
        message: 'Downloaded $itemsDownloaded items',
        itemsProcessed: itemsDownloaded,
      );
    } catch (e) {
      return MigrationResult.error('Download failed: $e');
    }
  }

  // ========== LOADING DOS DADOS LOCAIS ==========

  Future<ReadingProgressEntity?> _loadLocalProgress() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plan.pgs');

      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final jsonList = json.decode(jsonString) as List<dynamic>;

      return ReadingProgressEntity(
        days: jsonList.map((day) {
          final dayMap = day as Map<String, dynamic>;
          return DayProgressEntity(
            complete: dayMap['complete'] as bool?,
            books: (dayMap['books'] as List<dynamic>?)?.cast<int>(),
            egwReadingCompleted: dayMap['egwReadingCompleted'] as bool?,
            bibleReading: (dayMap['bibleReadin'] as List<dynamic>?)
                ?.map((group) => (group as List<dynamic>).cast<bool>())
                .toList(),
          );
        }).toList(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error loading local progress: $e');
      return null;
    }
  }

  Future<List<HighlightEntity>> _loadLocalHighlights() async {
    try {
      final box = await Hive.openBox('BooksHighlights');
      final highlights = <HighlightEntity>[];

      for (final key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          highlights.add(
            HighlightEntity(
              id: key.toString(),
              book: data['book'] ?? 0,
              chapter: data['chapter'] ?? 0,
              verse: data['verse'] ?? 0,
              color: data['color'] ?? 'yellow',
              text: data['text'],
              createdAt: data['createdAt'] ?? DateTime.now(),
            ),
          );
        }
      }

      await box.close();
      return highlights;
    } catch (e) {
      print('Error loading local highlights: $e');
      return [];
    }
  }

  Future<List<NoteEntity>> _loadLocalNotes() async {
    try {
      final box = await Hive.openBox('Notes');
      final notes = <NoteEntity>[];

      for (final key in box.keys) {
        final data = box.get(key);

        if (data != null) {
          notes.add(
            NoteEntity(
              id: key.toString(),
              book: data['book'] ?? 0,
              chapter: data['chapter'] ?? 0,
              verse: data['verse'] ?? 0,
              content: data['content'] ?? '',
              createdAt: data['createdAt'] ?? DateTime.now(),
              updatedAt: data['updatedAt'] ?? DateTime.now(),
            ),
          );
        }
      }

      await box.close();
      return notes;
    } catch (e) {
      print('Error loading local notes: $e');
      return [];
    }
  }

  // ========== SALVANDO DADOS LOCAIS ==========

  Future<void> _saveLocalProgress(ReadingProgressEntity progress) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plan.pgs');

      final jsonList = progress.days.map((day) {
        final map = <String, dynamic>{};
        if (day.complete != null) map['complete'] = day.complete;
        if (day.books != null) map['books'] = day.books;
        if (day.egwReadingCompleted != null) {
          map['egwReadingCompleted'] = day.egwReadingCompleted;
        }
        if (day.bibleReading != null) map['bibleReading'] = day.bibleReading;
        return map;
      }).toList();

      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving local progress: $e');
    }
  }

  Future<void> _saveLocalHighLights(List<HighlightEntity> highlights) async {
    try {
      final box = await Hive.openBox('BooksHighlights');
      await box.clear();

      for (final highlight in highlights) {
        await box.put(highlight.id, {
          'book': highlight.book,
          'chapter': highlight.chapter,
          'verse': highlight.verse,
          'color': highlight.color,
          'text': highlight.text,
          'createdAt': highlight.createdAt,
        });
      }

      await box.close();
    } catch (e) {
      print('Error saving local highlights: $e');
    }
  }

  Future<void> _saveLocalNotes(List<NoteEntity> notes) async {
    try {
      final box = await Hive.openBox('Notes');
      await box.clear();

      for (final note in notes) {
        await box.put(note.id, {
          'book': note.book,
          'chapter': note.chapter,
          'verse': note.verse,
          'content': note.content,
          'createdAt': note.createdAt,
          'updatedAt': note.updatedAt,
        });
      }

      await box.close();
    } catch (e) {
      print('Error savind local notes: $e');
    }
  }

  // ========== HELPERS ==========

  Future<DateTime?> _getLocalLastUpdated() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plan.pgs');
      if (await file.exists()) {
        final stat = await file.stat();
        return stat.modified;
      }
    } catch (e) {
      // lorem ipsum
    }
    return null;
  }

  Future<DateTime?> _getCloudLastUpdated() async {
    try {
      final progress = await _downloadProgress();
      return progress?.lastUpdated;
    } catch (e) {
      return null;
    }
  }
}

// ========== CLASSES DE RESULTADOS ==========

enum MigrationScenario {
  noData,
  uploadedLocal,
  downloadedCloud,
  conflict,
}

class MigrationResult {
  final bool success;
  final MigrationScenario? scenario;
  final String message;
  final int itemsProcessed;
  final DateTime? localLastUpdated;
  final DateTime? cloudLastUpdated;

  const MigrationResult({
    required this.success,
    this.scenario,
    required this.message,
    this.itemsProcessed = 0,
    this.localLastUpdated,
    this.cloudLastUpdated,
  });

  factory MigrationResult.success({
    required MigrationScenario scenario,
    required String message,
    int itemsProcessed = 0,
  }) {
    return MigrationResult(
      success: true,
      scenario: scenario,
      message: message,
      itemsProcessed: itemsProcessed,
    );
  }

  factory MigrationResult.conflict({
    DateTime? localLastUpdated,
    DateTime? cloudLastUpdated,
  }) {
    return MigrationResult(
      success: false,
      scenario: MigrationScenario.conflict,
      message: 'Conflict detected',
      localLastUpdated: localLastUpdated,
      cloudLastUpdated: cloudLastUpdated,
    );
  }

  factory MigrationResult.error(String message) {
    return MigrationResult(
      success: false,
      message: message,
    );
  }

  factory MigrationResult.skipped(String message) {
    return MigrationResult(
      success: true,
      message: message,
    );
  }

  bool get isConflict => scenario == MigrationScenario.conflict;
}
