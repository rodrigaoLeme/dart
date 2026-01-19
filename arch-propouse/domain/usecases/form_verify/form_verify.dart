import '../../entities/form_verify/form_verify_entity.dart';

abstract class FormVerify {
  Future<FormVerifyEntity> verify(QuestionsVerifyParms params);
}

class QuestionsVerifyParms {
  final String? questionId;
  final List<String>? questions;
  final String? answer;

  QuestionsVerifyParms({
    required this.questionId,
    required this.questions,
    required this.answer,
  });

  Map toJson() => {
        'questionId': questionId,
        'questions': questions,
        'answer': answer,
      };
}
