import '../../entities/sync/sync.dart';

/// Envia as marcações para o Firestore
abstract class UploadHighlight {
  Future<void> call(HighlightEntity highlight);
}
