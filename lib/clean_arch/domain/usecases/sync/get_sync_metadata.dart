import '../../entities/sync/sync.dart';

/// Obter metadados de sincronização
abstract class GetSyncMetadata {
  Future<SyncMetadataEntity?> call();
}
