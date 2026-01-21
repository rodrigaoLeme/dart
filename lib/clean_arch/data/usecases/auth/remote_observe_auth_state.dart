import '../../../domain/entities/auth/auth.dart';
import '../../../domain/usecases/auth/auth.dart';
import '../../models/auth/auth.dart';
import '../../repositories/auth_repository.dart';

/// Implementação do caso de uso ObserveAuthState
class RemoteObserveAuthState implements ObserveAuthState {
  final AuthRepository repository;

  RemoteObserveAuthState({required this.repository});

  @override
  Stream<AuthStateEntity> call() {
    return repository.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) {
        return const AuthStateEntity.unauthenticated();
      }

      final userModel = _mapFirebaseUserToModel(firebaseUser);
      final userEntity = userModel.toEntity();

      // Retorna estado autenticado com o usuário
      return AuthStateEntity.authenticated(userEntity);
    }).handleError((error) {
      return AuthStateEntity.error(error.toString());
    });
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
}
