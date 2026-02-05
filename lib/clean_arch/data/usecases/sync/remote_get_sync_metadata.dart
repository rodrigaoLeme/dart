import '../../../domain/entities/sync/sync.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../repositories/sync_repository.dart';

class RemoteGetSyncMetadata implements GetSyncMetadata {
  final SyncRepository repository;

  RemoteGetSyncMetadata({required this.repository});

  @override
  Future<SyncMetadataEntity?> call() async {
    try {
      final model = await repository.getSyncMetadata();
      return model?.toEntity();
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('network')) return DomainError.networkError;
    if (errorMessage.contains('permission')) return DomainError.unauthorized;
    return DomainError.unexpected;
  }
}
