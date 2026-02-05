import '../../entities/sync/sync.dart';

/// Baixar todos as marcações do Firestore
abstract class DownloadHighlights {
  Future<List<HighlightEntity>> call();
}
