import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bibleplan/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/sync/sync.dart';
import '../../domain/usecases/sync/sync.dart';
import '../../main/factories/sync/sync.dart';
import '../../../providers/Model/highlight.dart';

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
      if (!Hive.isBoxOpen('BooksHighlights')) {
        await Hive.openBox<BooksHighlights>('BooksHighlights');
      }
      final box = Hive.box<BooksHighlights>('BooksHighlights');
      final hasData = box.isNotEmpty;
      return hasData;
    } catch (e) {
      return false;
    }
  }

  /// Verifica se existem notas locais
  Future<bool> hasLocalNotes() async {
    try {
      if (!Hive.isBoxOpen('Notes')) {
        await Hive.openBox<BooksHighlights>('Notes');
      }
      final box = Hive.box<BooksHighlights>('Notes');
      final hasData = box.isNotEmpty;
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

      debugPrint('🟢 Iniciando upload de dados locais...');

      // 1. Upload progress
      final progress = await _loadLocalProgress();
      if (progress != null) {
        await _uploadProgress(progress);
        itemsUploaded++;
        debugPrint('✅ Progresso enviado');
      }

      // 2. Upload marcações
      final highlights = await _loadLocalHighlights();
      for (final highlight in highlights) {
        await _uploadHighlight(highlight);
        itemsUploaded++;
      }
      debugPrint('✅ ${highlights.length} highlights enviados');

      // 3. Upload notas
      final notes = await _loadLocalNotes();
      for (final note in notes) {
        await _uploadNote(note);
        itemsUploaded++;
      }
      debugPrint('✅ ${notes.length} notes enviadas');

      return MigrationResult.success(
        scenario: MigrationScenario.uploadedLocal,
        message: 'Uploaded $itemsUploaded items',
        itemsProcessed: itemsUploaded,
      );
    } catch (e, stack) {
      debugPrint('❌ Erro no upload: $e');
      debugPrint(stack as String?);
      return MigrationResult.error('Upload failed: $e');
    }
  }

  // ========== DOWNLOAD ==========

  Future<MigrationResult> _downloadAllCloudData() async {
    try {
      int itemsDownloaded = 0;

      debugPrint('🟢 Iniciando download de dados da nuvem...');

      // 1. Download od progresso
      final progress = await _downloadProgress();
      if (progress != null) {
        await _saveLocalProgress(progress);
        itemsDownloaded++;
        debugPrint('✅ Progresso baixado');
      }

      // 2. Download das marcaçÕes
      final highlights = await _downloadHighlights();
      await _saveLocalHighLights(highlights);
      itemsDownloaded += highlights.length;
      debugPrint('✅ ${highlights.length} highlights baixados');

      // 3. Download das notas
      final notes = await _downloadNotes();
      await _saveLocalNotes(notes);
      itemsDownloaded += notes.length;
      debugPrint('✅ ${notes.length} notes baixadas');

      return MigrationResult.success(
        scenario: MigrationScenario.downloadedCloud,
        message: 'Downloaded $itemsDownloaded items',
        itemsProcessed: itemsDownloaded,
      );
    } catch (e, stack) {
      debugPrint('❌ Erro no download: $e');
      debugPrint(stack as String?);
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
      final List<dynamic> progressList = json.decode(jsonString);

      final days = <DayProgressEntity>[];

      for (int dayIndex = 0; dayIndex < progressList.length; dayIndex++) {
        final dayData = progressList[dayIndex];

        final List<dynamic> bibleBooks = dayData['bible'] ?? [];
        final books = <int>[];
        final bibleReading = <List<bool>>[];

        for (int bookIndex = 0; bookIndex < bibleBooks.length; bookIndex++) {
          final bookData = bibleBooks[bookIndex];
          final List<dynamic> chaptersData = bookData['chapters'] ?? [];

          books.add(bookIndex);
          bibleReading.add(chaptersData.cast<bool>());
        }

        days.add(DayProgressEntity(
          complete: null,
          books: books,
          egwReadingCompleted: dayData['egwReadingCompleted'] as bool?,
          bibleReading: bibleReading,
        ));
      }

      return ReadingProgressEntity(
        days: days,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stack) {
      debugPrint('❌ Error loading local progress: $e');
      debugPrint(stack as String?);
      return null;
    }
  }

  Future<List<HighlightEntity>> _loadLocalHighlights() async {
    try {
      if (!Hive.isBoxOpen('BooksHighlights')) {
        await Hive.openBox<BooksHighlights>('BooksHighlights');
      }

      final box = Hive.box<BooksHighlights>('BooksHighlights');
      final highlights = <HighlightEntity>[];

      for (final key in box.keys) {
        final booksHighlights = box.get(key);
        if (booksHighlights == null) continue;

        // key format: "GEN-pt", "EXO-en"
        final parts = key.toString().split('-');
        final bookKey = parts[0];
        final language = parts.length > 1 ? parts[1] : 'pt';

        // Iterar por capítulos
        for (final chapterHighlights in booksHighlights.chapters) {
          final chapter = chapterHighlights.chapter;

          // Iterar por marcações
          for (final mark in chapterHighlights.marks) {
            // FILTRAR: apenas highlights (sem nota)
            if (mark.note != null && mark.note!.isNotEmpty) continue;

            highlights.add(HighlightEntity(
              id: '${bookKey}_${language}_${chapter}_${mark.start}_${mark.end}',
              book: bookKey,
              chapter: chapter,
              verse: mark.start,
              color: _colorIntToString(mark.color),
              text: mark.description,
              createdAt: mark.date,
              language: language,
              start: mark.start,
              end: mark.end,
              reference: mark.reference,
              page: mark.page,
              day: mark.day,
            ));
          }
        }
      }
      return highlights;
    } catch (e, stack) {
      debugPrint('❌ Error loading local highlights: $e');
      debugPrint(stack as String?);
      return [];
    }
  }

  Future<List<NoteEntity>> _loadLocalNotes() async {
    try {
      if (!Hive.isBoxOpen('Notes')) {
        await Hive.openBox<BooksHighlights>('Notes');
      }

      final box = Hive.box<BooksHighlights>('Notes');
      final notes = <NoteEntity>[];

      for (final key in box.keys) {
        final booksHighlights = box.get(key);
        if (booksHighlights == null) continue;

        // key format: "GEN-pt", "PP-en"
        final parts = key.toString().split('-');
        final bookKey = parts[0];
        final language = parts.length > 1 ? parts[1] : 'pt';

        // Iterar por capítulos
        for (final chapterHighlights in booksHighlights.chapters) {
          final chapter = chapterHighlights.chapter;

          // Iterar por marcações
          for (final mark in chapterHighlights.marks) {
            // FILTRAR: apenas notes (com nota)
            if (mark.note == null || mark.note!.isEmpty) continue;

            notes.add(NoteEntity(
              id: '${bookKey}_${language}_${chapter}_${mark.start}_${mark.end}',
              book: bookKey,
              chapter: chapter,
              verse: mark.start,
              content: mark.note!,
              createdAt: mark.date,
              updatedAt: mark.date,
              language: language,
              start: mark.start,
              end: mark.end,
              textSnippet: mark.description,
              reference: mark.reference,
              page: mark.page,
              day: mark.day,
            ));
          }
        }
      }

      return notes;
    } catch (e, stack) {
      debugPrint('❌ Error loading local notes: $e');
      debugPrint(stack as String?);
      return [];
    }
  }

  // ========== SALVANDO DADOS LOCAIS ==========

  Future<void> _saveLocalProgress(ReadingProgressEntity progress) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/plan.pgs');

      final jsonList = progress.days.map((day) {
        final bibleBooks = <Map<String, dynamic>>[];

        if (day.bibleReading != null) {
          for (final chapters in day.bibleReading!) {
            bibleBooks.add({
              'chapters': chapters,
            });
          }
        }

        return {
          'bible': bibleBooks,
          if (day.egwReadingCompleted != null)
            'egwReadingCompleted': day.egwReadingCompleted,
        };
      }).toList();

      await file.writeAsString(json.encode(jsonList));
      debugPrint('✅ Progresso salvo localmente');
    } catch (e, stack) {
      debugPrint('❌ Error saving local progress: $e');
      debugPrint(stack as String?);
    }
  }

  Future<void> _saveLocalHighLights(List<HighlightEntity> highlights) async {
    try {
      if (!Hive.isBoxOpen('BooksHighlights')) {
        await Hive.openBox<BooksHighlights>('BooksHighlights');
      }

      final box = Hive.box<BooksHighlights>('BooksHighlights');

      // Agrupar por livro e idioma
      final Map<String, BooksHighlights> booksMap = {};

      for (final highlight in highlights) {
        final key = '${highlight.book}-${highlight.language}';

        if (!booksMap.containsKey(key)) {
          booksMap[key] = BooksHighlights(
            name: highlight.book,
            key: highlight.book,
            chapters: [],
          );
        }

        final book = booksMap[key]!;
        var chapter = book.getChapter(highlight.chapter);

        if (chapter == null) {
          chapter = ChapterHighlights(
            chapter: highlight.chapter,
            marks: [],
          );
          book.setChapter(chapter);
        }

        chapter.marks.add(TextMark(
          start: highlight.start,
          end: highlight.end,
          color: _colorStringToInt(highlight.color),
          description: highlight.text,
          reference: highlight.reference,
          date: highlight.createdAt,
          page: highlight.page,
          day: highlight.day,
          note: null,
        ));
      }

      // Salvar no Hive
      for (final entry in booksMap.entries) {
        await box.put(entry.key, entry.value);
      }

      debugPrint('✅ ${highlights.length} highlights salvos localmente');
    } catch (e, stack) {
      debugPrint('Error saving local highlights: $e');
      debugPrint(stack as String?);
    }
  }

  Future<void> _saveLocalNotes(List<NoteEntity> notes) async {
    try {
      if (!Hive.isBoxOpen('Notes')) {
        await Hive.openBox<BooksHighlights>('Notes');
      }

      final box = Hive.box<BooksHighlights>('Notes');

      // Agrupar por livro e idioma
      final Map<String, BooksHighlights> booksMap = {};

      for (final note in notes) {
        final key = '${note.book}-${note.language}';

        if (!booksMap.containsKey(key)) {
          booksMap[key] = BooksHighlights(
            name: note.book,
            key: note.book,
            chapters: [],
          );
        }

        final book = booksMap[key]!;
        var chapter = book.getChapter(note.chapter);

        if (chapter == null) {
          chapter = ChapterHighlights(
            chapter: note.chapter,
            marks: [],
          );
          book.setChapter(chapter);
        }

        chapter.marks.add(TextMark(
          start: note.start,
          end: note.end,
          color: 0, // Notas não têm cor
          description: note.textSnippet,
          reference: note.reference,
          date: note.createdAt,
          page: note.page,
          day: note.day,
          note: note.content,
        ));
      }

      // Salvar no Hive
      for (final entry in booksMap.entries) {
        await box.put(entry.key, entry.value);
      }

      debugPrint('✅ ${notes.length} notes salvas localmente');
    } catch (e, stack) {
      debugPrint('❌ Error savind local notes: $e');
      debugPrint(stack as String?);
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

/// Converte int ARGB para String de cor (ficou meio racista isso)
String _colorIntToString(int colorInt) {
  if (colorInt == 0) return 'none';

  // cores
  if (colorInt == 0xFFFFFF00) return 'yellow';
  if (colorInt == 0xFF00FF00) return 'green';
  if (colorInt == 0xFF0000FF) return 'blue';
  if (colorInt == 0xFFFF0000) return 'red';
  if (colorInt == 0xFFFF00FF) return 'pink';

  return '#${colorInt.toRadixString(16).padLeft(8, '0').substring(2)}';
}

/// Converte String de cor para int ARGB
int _colorStringToInt(String color) {
  switch (color.toLowerCase()) {
    case 'yellow':
      return 0xFFFFFF00;
    case 'green':
      return 0xFF00FF00;
    case 'blue':
      return 0xFF0000FF;
    case 'red':
      return 0xFFFF0000;
    case 'pink':
      return 0xFFFF00FF;
    case 'none':
      return 0;
    default:
      // Tentar converter de hex
      if (color.startsWith('#')) {
        return int.tryParse('0xFF${color.substring(1)}') ?? 0xFFFFFF00;
      }
      return 0xFFFFFF00; // Default amarelo
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
