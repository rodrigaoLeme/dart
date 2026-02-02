import '../../../domain/entities/auth/auth.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/auth/auth.dart';
import '../../models/auth/auth.dart';
import '../../repositories/auth_repository.dart';

/// Implementação do caso de uso SignInAnonymous
class RemoteSignInAnonymous implements SignInAnonymous {
  final AuthRepository repository;

  RemoteSignInAnonymous({required this.repository});

  @override
  Future<UserEntity> call() async {
    try {
      final firebaseUser = await repository.signInAnonymously();

      final userModel = _mapFirebaseUserToModel(firebaseUser);
      return userModel.toEntity();
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
      lastSignInAt: firebaseUser.metadata.lastSignInTime,
    );
  }

  DomainError _mapErrorToDomain(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('network')) {
      return DomainError.networkError;
    } else if (errorMessage.contains('disabled')) {
      return DomainError.accountDisabled;
    } else {
      return DomainError.unexpected;
    }
  }
}
