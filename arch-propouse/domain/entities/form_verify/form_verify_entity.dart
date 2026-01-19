class FormVerifyEntity {
  final List<QuestionsEntity>? data;
  final List<String>? errors;
  final bool? success;

  FormVerifyEntity({
    required this.data,
    required this.errors,
    required this.success,
  });

  FormVerifyEntity copyWith({
    List<QuestionsEntity>? data,
    List<String>? errors,
    bool? success,
  }) {
    return FormVerifyEntity(
      data: data ?? this.data,
      errors: errors ?? this.errors,
      success: success ?? this.success,
    );
  }

  List<QuestionsEntity>? get dataFiltered {
    return data
        ?.where((element) => (element.answer?.length ?? 0) < 1000)
        .toList();
  }
}

class QuestionsEntity {
  final String? questionId;
  final String? questionText;
  final String? answer;
  final String? response;

  QuestionsEntity({
    required this.questionId,
    required this.questionText,
    required this.answer,
    required this.response,
  });

  QuestionsEntity copyWith({
    String? questionId,
    String? questionText,
    String? answer,
    String? response,
  }) {
    return QuestionsEntity(
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      answer: answer ?? this.answer,
      response: response ?? this.response,
    );
  }
}
