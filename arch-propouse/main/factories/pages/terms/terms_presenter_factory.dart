import '../../../../presentation/presenters/terms/terms_presentation.dart';
import '../../../../ui/modules/terms_accepted/terms_accepted_presenter.dart';
import '../../usecases/terms/terms.dart';

TermsAcceptedPresenter makeTermsPresenter() => TermsAcceptedPresentation(
      loadTerms: makeRemoteLoadTermsWithLocalFallback(),
      saveCurrentAccountTerms: makeLocalSaveCurrentAccountTerms(),
    );
