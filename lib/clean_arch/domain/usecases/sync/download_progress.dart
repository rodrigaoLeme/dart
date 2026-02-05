import '../../entities/sync/sync.dart';

/// Baixa o progresso completo (365 ou 366 dias) da nuvem
abstract class DownloadProgress {
  Future<ReadingProgressEntity?> call();
}
