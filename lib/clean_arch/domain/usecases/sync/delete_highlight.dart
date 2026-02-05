/// Deleter marcações do Firestore
abstract class DeleteHighlight {
  Future<void> call(String highlightId);
}
