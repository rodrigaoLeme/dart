import '../../../../presentation/presenters/forms_details/forms_details_presentation.dart';
import '../../../../ui/modules/forms_details/forms_details_presenter.dart';
import '../../usecases/form_fill/delete_current_form_fill_factory.dart';
import '../../usecases/form_fill/load_current_form_fill_factory.dart';
import '../../usecases/form_fill/load_form_fill_factory.dart';
import '../../usecases/forms_details/delete_current_form_details_fill_factory.dart';
import '../../usecases/forms_details/load_current_form_details_fill_factory.dart';
import '../../usecases/forms_details/load_forms_details_factory.dart';
import '../../usecases/forms_details/save_current_form_details_fill_factory.dart';

FormsDetailsPresenter makeFormsDetailsPresenter() => FormsDetailsPresentation(
      loadFormsDetails: makeRemoteLoadFormsDetailsWithLocalFallback(),
      loadCurrentFormDetailsFill: makeLoadCurrentFormDetailsFill(),
      localLoad: makeLocalLoadCurrentFormFill(),
      addFormFill: makeRemoteAddFormFill(),
      deleteCurrentFormDetailsFill: makeDeleteCurrentFormDetailsFill(),
      deleteCurrentFormFill: makeDeleteCurrentFormFill(),
      localSaveCurrentFormFill: makeSaveCurrentFormDetailsFill(),
    );
