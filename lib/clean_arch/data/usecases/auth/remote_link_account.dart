import '../../../domain/entities/auth/auth.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/auth/auth.dart';
import '../../models/auth/auth.dart';
import '../../repositories/auth_repository.dart';

/// Implementação do caso de uso LinkAccout
class RemoteLinkAccount implements LinkAccount {
  final AuthRepository repository;

  RemoteLinkAccount({required this.repository});

  @override
  Future<UserEntity> call(LinkProvider provider) async {
    try {
      // verifica se há usuário anônimo
      final currentUser = repository.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        throw DomainError.accountNotLinked;
      }

      final firebaseUser = await repository.linkWithProvider(provider);

      // converte firebase user -> UserModel -> UserEntity
      final userModel = _mapFirebaseUserToModel(firebaseUser);
      return userModel.toEntity();
    } on DomainError {
      rethrow;
    } on Exception catch (error) {
      throw _mapErrorToDomain(error);
    }
  }

  UserModel _mapFirebaseUserToModel(dynamic firebaseUser) {
    return UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        isAnonymous: firebaseUser.isAnonymous,
        isEmailVerified: firebaseUser.emailVerified,
        providerId: firebaseUser.providerData.isNotEmpty
            ? firebaseUser.providerData.first.providerId
            : null,
        createdAt: firebaseUser.metadata.creationTime,
        lastSignInAt: firebaseUser.metadata.lastSignInTime);
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('network')) {
      return DomainError.networkError;
    } else if (errorMessage.contains('cancelled') ||
        errorMessage.contains('canceled')) {
      return DomainError.cancelledByUser;
    } else if (errorMessage.contains('credential-already-in-use') ||
        errorMessage.contains('email-already-in-use')) {
      return DomainError.emailInUse;
    } else if (errorMessage.contains('requires-recent-login')) {
      return DomainError.expiredSession;
    } else if (errorMessage.contains('invalid-credential')) {
      return DomainError.invalidCredentials;
    } else {
      return DomainError.unexpected;
    }
  }
}
