import '../../../../presentation/presenters/forms/forms_presentation.dart';
import '../../../../ui/modules/forms/forms_presenter.dart';
import '../../usecases/account/load_current_account_factory.dart';
import '../../usecases/forms/load_forms_factory.dart';
import '../../usecases/terms/terms.dart';

FormsPresenter makeFormsPresenter() => FormsPresentation(
      loadForm: makeRemoteLoadFormsWithLocalFallback(),
      saveCurrentAccountTerms: makeLocalSaveCurrentAccountTerms(),
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
    );
