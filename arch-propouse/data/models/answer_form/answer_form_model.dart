import '../../../domain/entities/answer_form/answer_form_entity.dart';
import '../../http/http.dart';

class AnswerFormModel {
  final AnswerFormDataModel? data;
  final bool? success;
  final bool? error;

  AnswerFormModel({
    required this.data,
    required this.success,
    required this.error,
  });

  factory AnswerFormModel.fromJson(Map json) {
    if (!json.containsKey('data')) {
      throw HttpError.invalidData;
    }

    return AnswerFormModel(
      data: AnswerFormDataModel.fromJson(json['data']),
      success: json['success'],
      error: json['error'],
    );
  }

  factory AnswerFormModel.fromEntity(AnswerFormEntity entity) =>
      AnswerFormModel(
        data: AnswerFormDataModel.fromEntity(entity.data),
        success: entity.success,
        error: entity.error,
      );

  AnswerFormEntity toEntity() => AnswerFormEntity(
        data: data?.toEntity(),
        success: success,
        error: error,
      );

  Map toJson() => {
        'data': data?.toJson(),
        'success': success,
        'error': error,
      };
}

class AnswerFormDataModel {
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
  final List<SessionModel>? sessions;
  final String? linkedFormId;
  final AnswerFormDataModel? subForm;

  AnswerFormDataModel({
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

  factory AnswerFormDataModel.fromJson(Map json) => AnswerFormDataModel(
        id: json['id'],
        formId: json['formId'],
        groupId: json['groupId'],
        formType: json['formType'],
        formAplication: json['formAplication'],
        registrationFormType: json['registrationFormType'],
        formFillType: json['formFillType'],
        linkedFormId: json['linkedFormId'],
        sessions: (json['sessions'] as List?)
            ?.map((e) => SessionModel.fromJson(e))
            .toList(),
        projectId: json['projectId'],
        identifier: json['identifier'],
        institution: json['institution'],
        groupName: json['groupName'],
        formTitle: json['formTitle'],
        formDescription: json['formDescription'],
        subForm: json['subForm'] == null
            ? null
            : AnswerFormDataModel.fromJson(json['subForm']),
      );

  factory AnswerFormDataModel.fromEntity(AnswerFormDataEntity? entity) =>
      AnswerFormDataModel(
        id: entity?.id,
        formId: entity?.formId,
        groupId: entity?.groupId,
        formType: entity?.formType,
        formAplication: entity?.formAplication,
        registrationFormType: entity?.registrationFormType,
        formFillType: entity?.formFillType,
        linkedFormId: entity?.linkedFormId,
        sessions:
            entity?.sessions?.map((e) => SessionModel.fromEntity(e)).toList(),
        projectId: entity?.projectId,
        identifier: entity?.identifier,
        institution: entity?.institution,
        groupName: entity?.groupName,
        formTitle: entity?.formTitle,
        formDescription: entity?.formDescription,
        subForm: entity?.subForm == null
            ? null
            : AnswerFormDataModel.fromEntity(entity?.subForm),
      );

  AnswerFormDataEntity toEntity() => AnswerFormDataEntity(
      id: id,
      formId: formId,
      groupId: groupId,
      formType: formType,
      formAplication: formAplication,
      registrationFormType: registrationFormType,
      formFillType: formFillType,
      linkedFormId: linkedFormId,
      sessions: sessions?.map((e) => e.toEntity()).toList(),
      projectId: projectId,
      identifier: identifier,
      institution: institution,
      groupName: groupName,
      formTitle: formTitle,
      formDescription: formDescription,
      subForm: subForm?.toEntity());

  Map toJson() => {
        'id': id,
        'formId': formId,
        'groupId': groupId,
        'formType': formType,
        'formAplication': formAplication,
        'registrationFormType': registrationFormType,
        'formFillType': formFillType,
        'linkedFormId': linkedFormId,
        'sessions': sessions?.map((e) => e.toJson()).toList(),
        'projectId': projectId,
        'identifier': identifier,
        'institution': institution,
        'groupName': groupName,
        'formTitle': formTitle,
        'formDescription': formDescription,
        'subForm': subForm?.toJson(),
      };
}

class SessionModel {
  final String? id;
  final String? title;
  final String? description;
  final int? index;
  final bool? visible;
  final List<QuestionModel>? questions;

  SessionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.index,
    required this.visible,
    required this.questions,
  });

  factory SessionModel.fromJson(Map json) => SessionModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        index: json['index'],
        visible: json['visible'],
        questions: (json['questions'] as List?)
            ?.map((e) => QuestionModel.fromJson(e))
            .toList(),
      );

  factory SessionModel.fromEntity(SessionEntity entity) => SessionModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        index: entity.index,
        visible: entity.visible,
        questions: entity.questions?.map(QuestionModel.fromEntity).toList(),
      );

  SessionEntity toEntity() => SessionEntity(
        id: id,
        title: title,
        description: description,
        index: index,
        visible: visible,
        questions: questions?.map((e) => e.toEntity()).toList(),
      );

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'index': index,
        'visible': visible,
        'questions': questions?.map((e) => e.toJson()).toList(),
      };
}

class QuestionModel {
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
  final QuestionOptionsModel? opcoes;
  final List<QuestionOptionsConfigModel>? questionOptionsConfig;

  QuestionModel({
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

  factory QuestionModel.fromJson(Map json) => QuestionModel(
        id: json['id'],
        answer: json['answer'],
        identificador: json['identificador'],
        classificacao: json['classificacao'],
        pergunta: json['pergunta'],
        eTipoPergunta: json['eTipoPergunta'],
        tipoPergunta: json['tipoPergunta'],
        criadoPor: json['criadoPor'],
        opcoes: json['opcoes'] != null
            ? QuestionOptionsModel.fromJson(json['opcoes'])
            : null,
        required: json['required'],
        visible: json['visible'],
        isFamilyGroupQuantity: json['isFamilyGroupQuantity'],
        index: json['index'],
        questionOptionsConfig: (json['questionOptionsConfig'] as List?)
            ?.map((e) => QuestionOptionsConfigModel.fromJson(e))
            .toList(),
        classification: json['classification'],
      );

  factory QuestionModel.fromEntity(QuestionEntity entity) => QuestionModel(
        id: entity.id,
        answer: entity.answer,
        classification: entity.classification,
        identificador: entity.identificador,
        pergunta: entity.pergunta,
        classificacao: entity.classificacao,
        eTipoPergunta: entity.eTipoPergunta,
        opcoes: entity.opcoes != null
            ? QuestionOptionsModel.fromEntity(entity.opcoes!)
            : null,
        required: entity.required,
        visible: entity.visible,
        isFamilyGroupQuantity: entity.isFamilyGroupQuantity,
        index: entity.index,
        questionOptionsConfig: entity.questionOptionsConfig
            ?.map((e) => QuestionOptionsConfigModel.fromEntity(e))
            .toList(),
        tipoPergunta: entity.tipoPergunta,
        criadoPor: entity.criadoPor,
      );

  QuestionEntity toEntity() => QuestionEntity(
        id: id,
        answer: answer,
        classification: classification,
        identificador: identificador,
        classificacao: classificacao,
        pergunta: pergunta,
        eTipoPergunta: eTipoPergunta,
        opcoes: opcoes?.toEntity(),
        required: required,
        visible: visible,
        isFamilyGroupQuantity: isFamilyGroupQuantity,
        index: index,
        questionOptionsConfig:
            questionOptionsConfig?.map((e) => e.toEntity()).toList(),
        tipoPergunta: tipoPergunta,
        criadoPor: criadoPor,
      );

  Map toJson() => {
        'id': id,
        'answer': answer,
        'classification': classification,
        'identificador': identificador,
        'classificacao': classificacao,
        'eTipoPergunta': eTipoPergunta,
        'pergunta': pergunta,
        'opcoes': opcoes?.toJson(),
        'required': required,
        'visible': visible,
        'isFamilyGroupQuantity': isFamilyGroupQuantity,
        'index': index,
        'questionOptionsConfig':
            questionOptionsConfig?.map((e) => e.toJson()).toList(),
        'tipoPergunta': tipoPergunta,
        'criadoPor': criadoPor,
      };
}

class QuestionOptionsModel {
  final Map<String, dynamic>? options;
  final Map<String, dynamic>? validations;

  QuestionOptionsModel({
    required this.options,
    required this.validations,
  });

  factory QuestionOptionsModel.fromJson(Map json) => QuestionOptionsModel(
        options: Map<String, dynamic>.from(json['options'] ?? {}),
        validations: Map<String, dynamic>.from(json['validations'] ?? {}),
      );

  factory QuestionOptionsModel.fromEntity(QuestionOptionsEntity entity) =>
      QuestionOptionsModel(
        options: entity.options,
        validations: entity.validations,
      );

  QuestionOptionsEntity toEntity() => QuestionOptionsEntity(
        options: options,
        validations: validations,
      );

  Map toJson() => {
        'options': options,
        'validations': validations,
      };
}

class QuestionOptionsConfigModel {
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

  QuestionOptionsConfigModel({
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

  factory QuestionOptionsConfigModel.fromJson(Map json) =>
      QuestionOptionsConfigModel(
        options: Map<String, dynamic>.from(json['options'] ?? {}),
        index: json['index'],
        hide: json['hide'],
        rating: json['rating'],
        disqualify: json['disqualify'],
        shiftActionVisible: json['shiftActionVisible'],
        size: json['size'],
        baseDate: json['baseDate'],
        shiftAction: json['shiftAction'],
        shiftActionIndex: json['shiftActionIndex'],
        shiftSelectedAction: json['shiftSelectedAction'],
      );

  factory QuestionOptionsConfigModel.fromEntity(
          QuestionOptionsConfigEntity entity) =>
      QuestionOptionsConfigModel(
        options: entity.options,
        index: entity.index,
        hide: entity.hide,
        rating: entity.rating,
        disqualify: entity.disqualify,
        shiftActionVisible: entity.shiftActionVisible,
        size: entity.size,
        baseDate: entity.baseDate,
        shiftAction: entity.shiftAction,
        shiftActionIndex: entity.shiftActionIndex,
        shiftSelectedAction: entity.shiftSelectedAction,
      );

  QuestionOptionsConfigEntity toEntity() => QuestionOptionsConfigEntity(
        options: options,
        index: index,
        hide: hide,
        rating: rating,
        disqualify: disqualify,
        shiftActionVisible: shiftActionVisible,
        size: size,
        baseDate: baseDate,
        shiftAction: shiftAction,
        shiftActionIndex: shiftActionIndex,
        shiftSelectedAction: shiftSelectedAction,
      );

  Map toJson() => {
        'options': options,
        'index': index,
        'hide': hide,
        'rating': rating,
        'disqualify': disqualify,
        'shiftActionVisible': shiftActionVisible,
        'size': size,
        'baseDate': baseDate,
        'shiftAction': shiftAction,
        'shiftActionIndex': shiftActionIndex,
        'shiftSelectedAction': shiftSelectedAction,
      };
}
