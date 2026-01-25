import '../../../domain/usecases/auth/auth.dart';
import './auth_usecases_factory.dart';

class AuthFactory {
  static SignInGoogle makeSignInGoogle() {
    return AuthUseCasesFactory.makeSignInGoogle();
  }

  static SignInApple makeSignInApple() {
    return AuthUseCasesFactory.makeSignInApple();
  }

  static SignInAnonymous makeSignInAnonymous() {
    return AuthUseCasesFactory.makeSignInAnonymous();
  }

  static SignOut makeSignOut() {
    return AuthUseCasesFactory.makeSignOut();
  }

  static LinkAccount makeLinkAccount() {
    return AuthUseCasesFactory.makeLinkAccout();
  }

  static GetCurrentUser makeGetCurrentUser() {
    return AuthUseCasesFactory.makeGetCurrentUser();
  }

  static ObserveAuthState makeObserveAuthState() {
    return AuthUseCasesFactory.makeObserveAuthState();
  }
}
