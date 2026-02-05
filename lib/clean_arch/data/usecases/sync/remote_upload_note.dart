import '../../../domain/entities/sync/sync.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../models/sync/sync.dart';
import '../../repositories/sync_repository.dart';

class RemoteUploadNote implements UploadNote {
  final SyncRepository repository;

  RemoteUploadNote({required this.repository});

  @override
  Future<void> call(NoteEntity note) async {
    try {
      final model = NoteModel.fromEntity(note);
      await repository.uploadNote(model);
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('network')) {
      return DomainError.networkError;
    } else if (errorMessage.contains('permission')) {
      return DomainError.unauthorized;
    } else {
      return DomainError.unexpected;
    }
  }
}
