import '../../../domain/entities/sync/sync.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../repositories/sync_repository.dart';

class RemoteDownloadNotes implements DownloadNotes {
  final SyncRepository repository;

  RemoteDownloadNotes({required this.repository});

  @override
  Future<List<NoteEntity>> call() async {
    try {
      final models = await repository.downloadNotes();
      return models.map((model) => model.toEntity()).toList();
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
