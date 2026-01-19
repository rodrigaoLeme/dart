import '../../../../domain/usecases/form_fill/save_current_answer_form.dart';
import '../../../composites/usecases/local_save_answer_form_with_local_fallback.dart';
import '../terms/delete_current_account_terms_factory.dart';
import 'load_current_form_fill_factory.dart';
import 'save_current_form_fill_factory.dart';

SaveCurrentAnswerForm makeSaveCurrentAnswerForm() =>
    LocalSaveAnswerFormWithLocalFallback(
      localSave: makeLocalSaveCurrentFormFill(),
      localLoad: makeLocalLoadCurrentFormFill(),
      deleteCurrentFormFill: makeLocalDeleteCurrentFormFill(),
    );
