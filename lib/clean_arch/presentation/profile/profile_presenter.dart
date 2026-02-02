import 'dart:async';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/auth/auth.dart';
import '../../main/factories/auth/auth.dart';
import './profile_ui_state.dart';

class ProfilePresenter {
  final StreamController<ProfileUIState> _stateController =
      StreamController<ProfileUIState>.broadcast();

  late final GetCurrentUser _getCurrentUser;
  late final LinkAccount _linkAccount;
  late final DeleteAccount _deleteAccount;
  late final SignOut _signOut;

  Stream<ProfileUIState> get state => _stateController.stream;

  ProfileUIState _currentState = const ProfileUIState.initial();
  ProfileUIState get currentState => _currentState;

  ProfilePresenter() {
    _initializeUseCases();
    loadUser();
  }

  void _initializeUseCases() {
    _getCurrentUser = AuthFactory.makeGetCurrentUser();
    _linkAccount = AuthFactory.makeLinkAccount();
    _deleteAccount = AuthFactory.makeDeleteAccount();
    _signOut = AuthFactory.makeSignOut();
  }

  void _emitState(ProfileUIState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  Future<void> loadUser() async {
    try {
      _emitState(const ProfileUIState.loading());

      final user = await _getCurrentUser();

      if (user != null) {
        _emitState(ProfileUIState.loaded(user));
      } else {
        _emitState(const ProfileUIState.error('Usuário não encontrado'));
      }
    } on DomainError catch (error) {
      _emitState(ProfileUIState.error(error.description));
    } catch (error) {
      _emitState(const ProfileUIState.error('Erro ao carregar perfil'));
    }
  }

  Future<void> linkWithGoogle() async {
    if (!_currentState.isAnonymous) {
      _emitState(ProfileUIState.error(
          'Apenas usuários anônimos podem vincular contas',
          user: _currentState.user));
      return;
    }

    try {
      _emitState(ProfileUIState.linking('google', _currentState.user));

      final linkedUser = await _linkAccount(LinkProvider.google);

      _emitState(ProfileUIState.loaded(linkedUser));
    } on DomainError catch (error) {
      _emitState(
          ProfileUIState.error(error.description, user: _currentState.user));
    } catch (error) {
      _emitState(ProfileUIState.error('Erro ao vincular com Google',
          user: _currentState.user));
    }
  }

  Future<void> linkWithApple() async {
    if (!_currentState.isAnonymous) {
      _emitState(ProfileUIState.error(
        'Apenas usuários anônimos podem vicular contas',
        user: _currentState.user,
      ));
      return;
    }

    try {
      _emitState(ProfileUIState.linking('apple', _currentState.user));

      final linkedUser = await _linkAccount(LinkProvider.apple);

      _emitState(ProfileUIState.loaded(linkedUser));
    } on DomainError catch (error) {
      _emitState(
          ProfileUIState.error(error.description, user: _currentState.user));
    } catch (error) {
      _emitState(ProfileUIState.error(
        'Erro ao vincular com Apple',
        user: _currentState.user,
      ));
    }
  }

  Future<void> deleteAccount() async {
    try {
      _emitState(ProfileUIState.deleting(_currentState.user));

      await _deleteAccount();
      // Como o estado vai para unauthenticated
      // o AuthStateWrapper vai redirecionar para o login sozinho
    } on DomainError catch (error) {
      _emitState(ProfileUIState.error(
        error.description,
        user: _currentState.user,
      ));
    } catch (error) {
      _emitState(ProfileUIState.error(
        'Erro ao excluri conta',
        user: _currentState.user,
      ));
    }
  }

  Future<void> signOut() async {
    try {
      await _signOut();
      // AuthStateWrapper redireciona automaticamente
    } on DomainError catch (error) {
      _emitState(ProfileUIState.error(
        error.description,
        user: _currentState.user,
      ));
    } catch (error) {
      _emitState(ProfileUIState.error(
        'Erro ao fazer logout',
        user: _currentState.user,
      ));
    }
  }

  void clearError() {
    if (_currentState.hasError) {
      _emitState(ProfileUIState.loaded(_currentState.user!));
    }
  }

  void dispose() {
    _stateController.close();
  }
}
