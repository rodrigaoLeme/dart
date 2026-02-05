import '../../../domain/entities/sync/sync.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../models/sync/sync.dart';
import '../../repositories/sync_repository.dart';

/// Implementação do use case UploadProgress
class RemoteUploadProgress implements UploadProgress {
  final SyncRepository repository;

  RemoteUploadProgress({required this.repository});

  @override
  Future<void> call(ReadingProgressEntity progress) async {
    try {
      final model = ReadingProgressModel.fromEntity(progress);

      await repository.uploadProgress(model);
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
