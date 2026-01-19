import '../../../../presentation/presenters/splash/splash_presentation.dart';
import '../../../../ui/modules/splash/splash_presenter.dart';
import '../../usecases/account/load_current_account_factory.dart';
import '../../usecases/terms/load_current_account_terms_factory.dart';

SplashPresenter makeSplashPresenter() => SplashPresentation(
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
      loadCurrentAccountTerms: makeLocalLoadCurrentAccountTerms(),
    );
