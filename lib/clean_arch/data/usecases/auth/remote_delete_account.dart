import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/auth/auth.dart';
import '../../repositories/auth_repository.dart';

class RemoteDeleteAccount implements DeleteAccount {
  final AuthRepository repository;

  RemoteDeleteAccount({required this.repository});

  @override
  Future<void> call() async {
    try {
      await repository.deleteAccount();
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    // Se a conta for muito antiga, pode ter expirado
    // então a reautenticação é necessária
    if (errorMessage.contains('requires-recent-login') ||
        errorMessage.contains('requires recente authentication')) {
      return DomainError.accountRequiresRecentLogin;
    }

    if (errorMessage.contains('no user') ||
        errorMessage.contains('not signed in')) {
      return DomainError.invalidCredentials;
    }

    if (errorMessage.contains('network')) {
      return DomainError.networkError;
    }

    return DomainError.unexpected;
  }
}
