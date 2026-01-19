import '../../../domain/entities/answer_form/answer_form_entity.dart';

abstract class LoadAnswerForm {
  Future<AnswerFormEntity> load(String? key);
}
