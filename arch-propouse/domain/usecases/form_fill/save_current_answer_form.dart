import '../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';
import '../../entities/form_verify/form_verify_entity.dart';

abstract class SaveCurrentAnswerForm {
  Future<void> save({
    required QuestionViewModel? question,
    required String answer,
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required AnswerFlow answerFlow,
    required QuestionType? questionType,
    required String currentUUID,
    required bool isEditMode,
    required String? currentSubFormUUID,
    required List<SessionViewModel> sections,
  });

  Future<void> saveAnswerOnReuse({
    required String sessionId,
    required AnswerFlow answerFlow,
    required String currentUUID,
    required String? currentSubFormUUID,
    FormVerifyEntity? data,
  });
}
