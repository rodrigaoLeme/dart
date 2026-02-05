import '../../entities/sync/sync.dart';

/// Envia o progresso completo (365 ou 366 dias) para a nuvem
abstract class UploadProgress {
  Future<void> call(ReadingProgressEntity progress);
}
