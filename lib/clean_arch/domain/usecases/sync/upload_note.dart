import '../../entities/sync/sync.dart';

/// Enviar as notas para o Firestore
abstract class UploadNote {
  Future<void> call(NoteEntity note);
}
