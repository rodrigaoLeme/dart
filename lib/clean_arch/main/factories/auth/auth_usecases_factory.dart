import '../../../data/usecases/auth/auth.dart';
import '../../../domain/usecases/auth/auth.dart';
import './firebase_auth_adapter_factory.dart';

class AuthUseCasesFactory {
  static final _repository = FirebaseAuthAdapterFactory.make();

  static SignInGoogle makeSignInGoogle() {
    return RemoteSignInGoogle(repository: _repository);
  }

  static SignInApple makeSignInApple() {
    return RemoteSignInApple(repository: _repository);
  }

  static SignInAnonymous makeSignInAnonymous() {
    return RemoteSignInAnonymous(repository: _repository);
  }

  static SignOut makeSignOut() {
    return RemoteSignOut(repository: _repository);
  }

  static LinkAccount makeLinkAccout() {
    return RemoteLinkAccount(repository: _repository);
  }

  static GetCurrentUser makeGetCurrentUser() {
    return RemoteGetCurrentUser(repository: _repository);
  }

  static ObserveAuthState makeObserveAuthState() {
    return RemoteObserveAuthState(repository: _repository);
  }
}
