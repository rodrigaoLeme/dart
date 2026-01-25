import 'dart:async';

import '../../domain/entities/auth/auth.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/auth/auth.dart';
import '../../main/factories/auth/auth.dart';
import './auth_ui_state.dart';

class AuthPresenter {
  late final SignInGoogle _signInGoogle;
  late final SignInApple _signInApple;
  late final SignInAnonymous _signInAnonymous;
  late final SignOut _signOut;
  late final ObserveAuthState _observeAuthState;

  final _stateController = StreamController<AuthUIState>.broadcast();
  StreamSubscription<AuthStateEntity>? _authStateSubscription;

  Stream<AuthUIState> get state => _stateController.stream;

  AuthUIState _currentState = const AuthUIState.initial();
  AuthUIState get currentState => _currentState;

  AuthPresenter() {
    _initializeUseCases();
    _observeAuthentication();
  }

  void _initializeUseCases() {
    _signInGoogle = AuthFactory.makeSignInGoogle();
    _signInApple = AuthFactory.makeSignInApple();
    _signInAnonymous = AuthFactory.makeSignInAnonymous();
    _signOut = AuthFactory.makeSignOut();
    _observeAuthState = AuthFactory.makeObserveAuthState();
  }

  void _observeAuthentication() {
    _authStateSubscription = _observeAuthState().listen((authState) {
      if (authState.isAuthenticated) {
        _emitState(AuthUIState.authenticated(authState.user));
      } else {
        _emitState(const AuthUIState.unauthenticated());
      }
    }, onError: (error) {
      _emitState(AuthUIState.error(error.toString()));
    });
  }

  void _emitState(AuthUIState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _emitState(const AuthUIState.authenticating('google'));
      await _signInGoogle();
    } on DomainError catch (error) {
      _emitState(AuthUIState.error(error.description));
    } catch (error) {
      _emitState(const AuthUIState.error('Erro ao fazer login com Google'));
    }
  }

  Future<void> signInWithApple() async {
    try {
      _emitState(const AuthUIState.authenticating('apple'));
      await _signInApple();
    } on DomainError catch (error) {
      _emitState(AuthUIState.error(error.description));
    } catch (error) {
      _emitState(const AuthUIState.error('Erro ao fazer login com Apple'));
    }
  }

  Future<void> signInAnonymously() async {
    try {
      _emitState(const AuthUIState.authenticating('anonymous'));
      await _signInAnonymous();
    } on DomainError catch (error) {
      _emitState(AuthUIState.error(error.description));
    } catch (error) {
      _emitState(const AuthUIState.error('Erro ao fazer login anônimo'));
    }
  }

  Future<void> signOut() async {
    try {
      await _signOut();
    } on DomainError catch (error) {
      _emitState(AuthUIState.error(error.description));
    } catch (error) {
      _emitState(const AuthUIState.error('Erro ao fazer logout'));
    }
  }

  void clearError() {
    if (_currentState.hasError) {
      _emitState(const AuthUIState.unauthenticated());
    }
  }

  void dispose() {
    _authStateSubscription?.cancel();
    _stateController.close();
  }
}
