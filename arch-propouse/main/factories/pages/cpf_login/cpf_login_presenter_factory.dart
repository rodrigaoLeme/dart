import '../../../../presentation/presenters/cpf_login/cpf_login_presentation.dart';
import '../../../../ui/modules/cpf_login/cpf_login_presenter.dart';
import '../../usecases/account/authentication_factory.dart';
import '../../usecases/account/save_current_account_factory.dart';
import '../../usecases/cpf_login/cpf_login_authentication_factory.dart';
import '../../usecases/terms/load_current_account_terms_factory.dart';

CpfLoginPresenter makeCpfLoginPresenter() => CpfLoginPresentation(
      cpfAuthentication: makeRemoteCpfAuthentication(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
      loadCurrentAccountTerms: makeLocalLoadCurrentAccountTerms(),
      authentication: makeRemoteAuthentication(),
    );
