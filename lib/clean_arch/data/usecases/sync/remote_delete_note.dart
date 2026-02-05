import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../repositories/sync_repository.dart';

class RemoteDeleteNote implements DeleteNote {
  final SyncRepository repository;

  RemoteDeleteNote({required this.repository});

  @override
  Future<void> call(String noteId) async {
    try {
      await repository.deleteNote(noteId);
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
