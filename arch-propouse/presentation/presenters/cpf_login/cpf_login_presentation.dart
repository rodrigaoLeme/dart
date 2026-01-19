import 'dart:async';
import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/account/remote_account_token_model.dart';
import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/entities/account/logged_user.dart';
import '../../../domain/entities/terms/account_terms_status.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/account/authentication.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../../domain/usecases/cpf_login/cpf_authentication.dart';
import '../../../domain/usecases/terms/load_current_account_terms.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/cpf_login/cpf_login_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';

class CpfLoginPresentation
    with NavigationManager, LoadingManager, UIErrorManager
    implements CpfLoginPresenter {
  final CpfAuthentication cpfAuthentication;
  final SaveCurrentAccount saveCurrentAccount;
  final LoadCurrentAccountTerms loadCurrentAccountTerms;
  final Authentication authentication;

  CpfLoginPresentation({
    required this.cpfAuthentication,
    required this.saveCurrentAccount,
    required this.loadCurrentAccountTerms,
    required this.authentication,
  });

  @override
  Future<void> socialAuth({required document, required birthday}) async {
    try {
      if (Modular.args.data == null || Modular.args.data is! LoggedUser) {
        throw DomainError.unexpected;
      }
      isLoading = LoadingData(isLoading: true);
      final loggedUser = Modular.args.data as LoggedUser;
      await cpfAuthentication.auth(
        CpfAuthenticationParams(
          document: document ?? '',
          birthday: birthday ?? '',
          email: loggedUser.email,
        ),
      );
      AccountTokenEntity auth = await authentication.auth(
        AuthenticationParams(
          email: loggedUser.email,
        ),
      );
      final json =
          jsonEncode(RemoteAccountTokenModel.fromEntity(auth).toJson());
      await saveCurrentAccount.save(json);
      final accountTerms = await loadCurrentAccountTerms.load();
      if (accountTerms != AccountTermsStatus.done) {
        navigateTo = NavigationData(route: Routes.accountTerms, clear: true);
      } else {
        navigateTo = NavigationData(route: Routes.forms, clear: true);
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidEmail.description;
        default:
          mainError = UIError.unexpected.description;
      }
    } finally {
      isLoading = LoadingData(isLoading: false);
      mainError = null;
    }
  }

  @override
  goToTerms() {
    navigateTo = NavigationData(route: Routes.accountTerms, clear: true);
  }
}
