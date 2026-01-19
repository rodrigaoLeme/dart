import 'dart:async';
import 'dart:convert';

import '../../../data/models/account/remote_account_token_model.dart';
import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/entities/account/logged_user.dart';
import '../../../domain/entities/terms/account_terms_status.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/account/authentication.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../../domain/usecases/account/social_authentication.dart';
import '../../../domain/usecases/terms/load_current_account_terms.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/login/login_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';

class LoginPresentation
    with NavigationManager, LoadingManager, UIErrorManager
    implements LoginPresenter {
  final SocialAuthentication socialAuthentication;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;
  final LoadCurrentAccountTerms loadCurrentAccountTerms;
  LoggedUser? loggedUser;

  LoginPresentation({
    required this.socialAuthentication,
    required this.authentication,
    required this.saveCurrentAccount,
    required this.loadCurrentAccountTerms,
  });
  @override
  Future<void> socialAuth(ProviderLogin providerLogin) async {
    try {
      isLoading = LoadingData(isLoading: true);

      loggedUser = await socialAuthentication.auth(provider: providerLogin);
      if (loggedUser == null) {
        return;
      }
      AccountTokenEntity auth = await authentication.auth(
        AuthenticationParams(
          email: loggedUser?.email ?? '',
        ),
      );
      auth = auth.copyWith(photoUrl: loggedUser?.urlPhoto);
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
          if (loggedUser != null) {
            navigateTo = NavigationData(
              route: Routes.cpfLogin,
              clear: false,
              arguments: loggedUser,
            );

            break;
          } else {
            mainError = UIError.unexpected.description;
          }
        default:
          mainError = UIError.unexpected.description;
      }
    } finally {
      isLoading = LoadingData(isLoading: false);
      mainError = null;
    }
  }
}
