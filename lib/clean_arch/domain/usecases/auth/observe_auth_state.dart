import '../../entities/auth/auth.dart';

/// Observar estado de autenticação
abstract class ObserveAuthState {
  Stream<AuthStateEntity> call();
}
