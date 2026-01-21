import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/auth/auth.dart';
import '../../repositories/auth_repository.dart';

/// Implementação do caso de uso SignOut
class RemoteSignOut implements SignOut {
  final AuthRepository repository;

  RemoteSignOut({required this.repository});

  @override
  Future<void> call() async {
    try {
      await repository.signOut();
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('networt')) {
      return DomainError.networkError;
    } else {
      return DomainError.unexpected;
    }
  }
}
