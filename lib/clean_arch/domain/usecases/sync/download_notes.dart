import '../../entities/sync/sync.dart';

/// Baixar todas as notas do Firestore
abstract class DownloadNotes {
  Future<List<NoteEntity>> call();
}
