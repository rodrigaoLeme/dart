import 'package:flutter_modular/flutter_modular.dart';

import '../../../../presentation/presenters/answer_form/answer_form_presentation.dart';
import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../../ui/modules/answer_form/answer_form_presenter.dart';
import '../../usecases/answer_form/load_answer_form_factory.dart';
import '../../usecases/form_fill/delete_current_form_fill_factory.dart';
import '../../usecases/form_fill/load_current_form_fill_factory.dart';
import '../../usecases/form_fill/load_form_fill_factory.dart';
import '../../usecases/form_fill/local_save_answer_form_with_local_fallback_factory.dart';
import '../../usecases/form_fill/save_current_form_fill_factory.dart';
import '../../usecases/form_verify/form_verify_factory.dart';
import '../../usecases/forms_details/delete_current_form_details_fill_factory.dart';
import '../../usecases/forms_details/load_current_form_details_fill_factory.dart';
import '../../usecases/forms_details/save_current_form_details_fill_factory.dart';

AnswerFormPresenter makeAnswerFormPresenter(
    FormsDetailsViewModel? formsDetailsViewModel) {
  final viewModel =
      formsDetailsViewModel ?? Modular.args.data as FormsDetailsViewModel;

  return AnswerFormPresentation(
    loadAnswerForm: makeRemoteLoadAnswerFormWithLocalFallback(),
    saveCurrentAnswerForm: makeSaveCurrentAnswerForm(),
    localLoad: makeLocalLoadCurrentFormFill(),
    addFormFill: makeRemoteAddFormFill(),
    loadCurrentFormDetailsFill: makeLoadCurrentFormDetailsFill(),
    localSaveCurrentFormFill: makeSaveCurrentFormDetailsFill(),
    deleteCurrentFormDetailsFill: makeDeleteCurrentFormDetailsFill(),
    deleteCurrentFormFill: makeDeleteCurrentFormFill(),
    localSave: makeLocalSaveCurrentFormFill(),
    formVerify: makeRemoteFormVerify(),
    currentFormsDetailsViewModel: viewModel,
  );
}
