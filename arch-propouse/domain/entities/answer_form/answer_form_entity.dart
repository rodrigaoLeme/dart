class AnswerFormEntity {
  final AnswerFormDataEntity? data;
  final bool? success;
  final bool? error;

  AnswerFormEntity({
    required this.data,
    required this.success,
    required this.error,
  });
}

class AnswerFormDataEntity {
  final String? id;
  final String? formId;
  final String? groupId;
  final String? projectId;
  final String? identifier;
  final String? institution;
  final String? groupName;
  final String? formType;
  final String? formAplication;
  final String? registrationFormType;
  final String? formFillType;
  final String? formTitle;
  final String? formDescription;
  final List<SessionEntity>? sessions;
  final String? linkedFormId;
  final AnswerFormDataEntity? subForm;

  AnswerFormDataEntity({
    required this.id,
    required this.formId,
    required this.groupId,
    required this.projectId,
    required this.identifier,
    required this.institution,
    required this.groupName,
    required this.formType,
    required this.formAplication,
    required this.registrationFormType,
    required this.formFillType,
    required this.formTitle,
    required this.formDescription,
    required this.sessions,
    required this.linkedFormId,
    required this.subForm,
  });

  String get identifierForm {
    return '$formId-$groupId';
  }
}

class SessionEntity {
  final String? id;
  final String? title;
  final String? description;
  final int? index;
  final bool? visible;
  final List<QuestionEntity>? questions;

  SessionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.index,
    required this.visible,
    required this.questions,
  });
}

class QuestionEntity {
  final String? id;
  final String? answer;
  final int? index;
  final bool? required;
  final bool? visible;
  final bool? isFamilyGroupQuantity;
  final bool? identificador;
  final String? classificacao;
  final String? classification;
  final String? pergunta;
  final int? eTipoPergunta;
  final String? tipoPergunta;
  final String? criadoPor;
  final QuestionOptionsEntity? opcoes;
  final List<QuestionOptionsConfigEntity>? questionOptionsConfig;

  QuestionEntity({
    required this.id,
    required this.answer,
    required this.index,
    required this.required,
    required this.visible,
    required this.isFamilyGroupQuantity,
    required this.identificador,
    required this.classificacao,
    required this.classification,
    required this.pergunta,
    required this.eTipoPergunta,
    required this.tipoPergunta,
    required this.criadoPor,
    required this.opcoes,
    required this.questionOptionsConfig,
  });
}

class QuestionOptionsEntity {
  final Map<String, dynamic>? options;
  final Map<String, dynamic>? validations;

  QuestionOptionsEntity({
    required this.options,
    required this.validations,
  });
}

class QuestionOptionsConfigEntity {
  final Map<String, dynamic>? options;
  final int? index;
  final bool? hide;
  final int? rating;
  final bool? disqualify;
  final bool? shiftActionVisible;
  final double? size;
  final String? baseDate;
  final String? shiftAction;
  final int? shiftActionIndex;
  final String? shiftSelectedAction;

  QuestionOptionsConfigEntity({
    required this.options,
    required this.index,
    required this.hide,
    required this.rating,
    required this.disqualify,
    required this.shiftActionVisible,
    required this.size,
    required this.baseDate,
    required this.shiftAction,
    required this.shiftActionIndex,
    required this.shiftSelectedAction,
  });
}
