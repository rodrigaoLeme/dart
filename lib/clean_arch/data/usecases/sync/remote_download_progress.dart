import '../../../domain/entities/sync/sync.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../repositories/sync_repository.dart';

/// Implementação do use case do DownloadProgress
class RemoteDownloadProgress implements DownloadProgress {
  final SyncRepository repository;

  RemoteDownloadProgress({required this.repository});

  @override
  Future<ReadingProgressEntity?> call() async {
    try {
      final model = await repository.downloadProgress();

      if (model == null) return null;

      return model.toEntity();
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('network')) {
      return DomainError.networkError;
    } else if (errorMessage.contains('permission') ||
        errorMessage.contains('unauthorized')) {
      return DomainError.unauthorized;
    } else {
      return DomainError.unexpected;
    }
  }
}
