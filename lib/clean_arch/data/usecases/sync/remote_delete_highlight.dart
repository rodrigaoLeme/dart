import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sync/sync.dart';
import '../../repositories/sync_repository.dart';

class RemoteDeleteHighlight implements DeleteHighlight {
  final SyncRepository repository;

  RemoteDeleteHighlight({required this.repository});

  @override
  Future<void> call(String highlightId) async {
    try {
      await repository.deleteHighlight(highlightId);
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
