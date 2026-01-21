import './user_entity.dart';

enum AuthStatus {
  inital,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthStateEntity {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthStateEntity({required this.status, this.user, this.errorMessage});

  // Estado inicial - Verificando autenticação
  const AuthStateEntity.initial()
      : status = AuthStatus.inital,
        user = null,
        errorMessage = null;

  // Autenticado com usuário
  const AuthStateEntity.authenticated(this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  // Não autenticado
  const AuthStateEntity.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null;

  // Carregando
  const AuthStateEntity.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  // Erro
  const AuthStateEntity.error(this.errorMessage)
      : status = AuthStatus.error,
        user = null;

  /// Veririca se está autenticado
  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// Verifica se está carregando
  bool get isLoading => status == AuthStatus.loading;

  /// Verifica se tem erro
  bool get hasError => status == AuthStatus.error;

  /// Verifica se é usuário anônimo
  bool get isAnonymous => user?.isAnonymous ?? false;

  AuthStateEntity copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthStateEntity(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthStateEntity &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user, errorMessage);

  @override
  String toString() {
    return 'AuthStateEntity(status: $status, user: $user, errorMessage: $errorMessage)';
  }
}
