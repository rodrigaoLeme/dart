import 'dart:async';

import '../../../domain/entities/terms/account_terms_status.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../../domain/usecases/terms/load_current_account_terms.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/splash/splash_presenter.dart';
import '../../mixins/navigation_manager.dart';

class SplashPresentation with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final LoadCurrentAccountTerms loadCurrentAccountTerms;

  SplashPresentation({
    required this.loadCurrentAccount,
    required this.loadCurrentAccountTerms,
  });

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    try {
      final account = await loadCurrentAccount.load();
      if (account != null) {
        final accountTerms = await loadCurrentAccountTerms.load();
        if (accountTerms == AccountTermsStatus.done) {
          navigateTo = NavigationData(route: Routes.forms, clear: true);
        } else {
          navigateTo = NavigationData(route: Routes.accountTerms, clear: true);
        }
      } else {
        navigateTo = NavigationData(route: Routes.login, clear: true);
      }
    } catch (error) {
      navigateTo = NavigationData(route: Routes.login, clear: true);
    }
  }
}
