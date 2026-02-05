/// Deletar uma nota do Firestore
abstract class DeleteNote {
  Future<void> call(String noteId);
}
