import '../../../../presentation/presenters/login/login_presentation.dart';
import '../../../../ui/modules/login/login_presenter.dart';
import '../../usecases/account/authentication_factory.dart';
import '../../usecases/account/save_current_account_factory.dart';
import '../../usecases/account/social_authentication_factory.dart';
import '../../usecases/terms/terms.dart';

LoginPresenter makeLoginPresenter() => LoginPresentation(
      socialAuthentication: makeSocialAuthentication(),
      authentication: makeRemoteAuthentication(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
      loadCurrentAccountTerms: makeLocalLoadCurrentAccountTerms(),
    );
