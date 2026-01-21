import '../../domain/entities/auth/auth.dart';

enum AuthUIStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error,
}

class AuthUIState {
  final AuthUIStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? currentProvider;

  const AuthUIState(
      {required this.status,
      this.user,
      this.errorMessage,
      this.currentProvider});

  const AuthUIState.initial()
      : status = AuthUIStatus.initial,
        user = null,
        errorMessage = null,
        currentProvider = null;

  const AuthUIState.authenticating(this.currentProvider)
      : status = AuthUIStatus.authenticating,
        user = null,
        errorMessage = null;

  const AuthUIState.authenticated(this.user)
      : status = AuthUIStatus.authenticated,
        errorMessage = null,
        currentProvider = null;

  const AuthUIState.unauthenticated()
      : status = AuthUIStatus.unauthenticated,
        user = null,
        errorMessage = null,
        currentProvider = null;

  const AuthUIState.error(this.errorMessage)
      : status = AuthUIStatus.error,
        user = null,
        currentProvider = null;

  bool get isAuthenticating => status == AuthUIStatus.authenticating;
  bool get isAuthenticated => status == AuthUIStatus.authenticated;
  bool get hasError => status == AuthUIStatus.error;

  bool isProviderLoading(String provider) =>
      isAuthenticating && currentProvider == provider;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthUIState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.currentProvider == currentProvider;
  }

  @override
  int get hashCode => Object.hash(status, user, errorMessage, currentProvider);

  @override
  String toString() {
    return 'AuthUIState(status: $status, user: $user, error: $errorMessage, provider: $currentProvider)';
  }
}
