import 'package:collection/collection.dart';

import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../domain/entities/answer_form/answer_form_entity.dart';
import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';

class AnswerFormViewModel {
  final AnswerFormDataViewModel? data;
  final bool? success;
  final bool? error;
  final AnswerFormEntity? entity;
  final RemoteAddFormFillParams? localAnswer;

  AnswerFormViewModel({
    required this.data,
    required this.success,
    required this.error,
    required this.entity,
    required this.localAnswer,
  });

  AnswerFormViewModel copyWith({
    AnswerFormDataViewModel? data,
    bool? success,
    bool? error,
    AnswerFormEntity? entity,
    RemoteAddFormFillParams? localAnswer,
  }) {
    return AnswerFormViewModel(
      data: data ?? this.data,
      success: success ?? this.success,
      error: error ?? this.error,
      entity: entity ?? this.entity,
      localAnswer: localAnswer ?? this.localAnswer,
    );
  }

  List<String> get allQuestionIds {
    return data?.sessions
            ?.expand((s) => s.questions ?? [])
            .map((q) => q.id)
            .whereType<String>()
            .toList() ??
        [];
  }
}

class AnswerFormDataViewModel {
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
  final List<SessionViewModel>? sessions;
  final String? linkedFormId;
  final AnswerFormDataViewModel? subForm;

  AnswerFormDataViewModel({
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

  List<SessionViewModel>? sessionsByFlow(
      {required AnswerFlow answerFlow, bool? removeNoVisibleSections = true}) {
    final isMainFlow = answerFlow == AnswerFlow.main;
    final allSessions = isMainFlow ? sessions ?? [] : subForm?.sessions ?? [];
    return removeNoVisibleSections == true
        ? allSessions.where((s) => s.visible == true).toList()
        : allSessions.toList();
  }

  AnswerFormDataViewModel copyWith({
    String? id,
    String? formId,
    String? groupId,
    String? projectId,
    String? identifier,
    String? institution,
    String? groupName,
    String? formType,
    String? formAplication,
    String? registrationFormType,
    String? formFillType,
    String? formTitle,
    String? formDescription,
    List<SessionViewModel>? sessions,
    String? linkedFormId,
    AnswerFormDataViewModel? subForm,
  }) {
    return AnswerFormDataViewModel(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      groupId: groupId ?? this.groupId,
      projectId: projectId ?? this.projectId,
      identifier: identifier ?? this.identifier,
      institution: institution ?? this.institution,
      groupName: groupName ?? this.groupName,
      formType: formType ?? this.formType,
      formAplication: formAplication ?? this.formAplication,
      registrationFormType: registrationFormType ?? this.registrationFormType,
      formFillType: formFillType ?? this.formFillType,
      formTitle: formTitle ?? this.formTitle,
      formDescription: formDescription ?? this.formDescription,
      sessions: sessions ?? this.sessions,
      linkedFormId: linkedFormId ?? this.linkedFormId,
      subForm: subForm ?? this.subForm,
    );
  }
}

class AnswerFormViewModelFactory {
  static AnswerFormViewModel make(
    AnswerFormEntity? entity,
    RemoteAddFormFillParams? localAnswer,
    FormVerifyEntity? data, [
    String? localUUID,
  ]) {
    return AnswerFormViewModel(
        success: entity?.success,
        data: entity?.data?.toViewModel(
          localAnswer,
          localAnswer?.mainForm,
          data,
          localUUID,
        ),
        error: entity?.error,
        entity: entity,
        localAnswer: localAnswer);
  }
}

extension AnswerFormDataViewModelExtensions on AnswerFormDataEntity {
  AnswerFormDataViewModel toViewModel(
    RemoteAddFormFillParams? localAnswer,
    RemoteFormsFill? formFill,
    FormVerifyEntity? data, [
    String? localUUID,
  ]) =>
      AnswerFormDataViewModel(
        id: id,
        formId: formId,
        groupId: groupId,
        formType: formType,
        formAplication: formAplication,
        registrationFormType: registrationFormType,
        formFillType: formFillType,
        sessions: sessions
            ?.map(
              (s) => s.toViewModel(
                formFill?.sessions?.firstWhereOrNull(
                  (element) => element?.sessionId == s.id,
                ),
                data,
              ),
            )
            .toList(),
        linkedFormId: linkedFormId,
        projectId: projectId,
        identifier: identifier,
        institution: institution,
        groupName: groupName,
        formTitle: formTitle,
        formDescription: formDescription,
        subForm: subForm?.toViewModel(
          localAnswer,
          localAnswer?.subForms
              ?.firstWhereOrNull((element) => element.localUUID == localUUID),
          data,
        ),
      );
}

class SessionViewModel {
  final String? id;
  final String? title;
  final String? description;
  final int? index;
  final List<QuestionViewModel>? questions;
  final bool? visible;
  final SessionEntity? entity;

  SessionViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.index,
    required this.questions,
    required this.visible,
    required this.entity,
  });

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'index': index,
        'visible': visible,
      };

  SessionViewModel copyWith({
    String? id,
    String? title,
    String? description,
    int? index,
    List<QuestionViewModel>? questions,
    bool? visible,
    SessionEntity? entity,
  }) {
    return SessionViewModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      index: index ?? this.index,
      questions: questions ?? this.questions,
      visible: visible ?? this.visible,
      entity: entity ?? this.entity,
    );
  }

  int? get familyGroupQuantity {
    final QuestionViewModel? familyGroupQuestion = questions?.firstWhereOrNull(
        (question) => question.isFamilyGroupQuantity == true);
    return int.tryParse(familyGroupQuestion?.answer ?? '');
  }

  bool get shouldShowSubForm {
    return questions?.firstWhereOrNull(
            (question) => question.isFamilyGroupQuantity == true) !=
        null;
  }
}

extension SessionViewModelExtension on SessionEntity {
  SessionViewModel toViewModel(
      RemoteSessionFill? session, FormVerifyEntity? data) {
    return SessionViewModel(
      id: id,
      title: title,
      description: description,
      index: index,
      questions: questions
          ?.map(
            (q) => q.toViewModel(
              session?.questions
                  ?.firstWhereOrNull((element) => element?.questionId == q.id),
              data,
            ),
          )
          .toList(),
      visible: session?.isVisibleByAnswer == false
          ? false
          : ((session?.tapsInItemsToHideSession?.values
                      .any((list) => (list as List).isNotEmpty) ??
                  false)
              ? false
              : ((session?.tapsInItemsToShowSession?.values
                          .any((list) => (list as List).isNotEmpty) ??
                      false)
                  ? true
                  : visible)),
      entity: this,
    );
  }
}

class QuestionViewModel {
  final String? id;
  final String? answer;
  final String? answerFile;
  final int? index;
  final bool? required;
  final bool? identificador;
  final String? classificacao;
  final String? classification;
  final String? pergunta;
  final int? eTipoPergunta;
  final String? tipoPergunta;
  final String? criadoPor;
  final QuestionOptionsViewModel? opcoes;
  final List<QuestionOptionsConfigViewModel>? questionOptionsConfig;
  final QuestionType? questionType;
  final bool? visible;
  final bool? isFamilyGroupQuantity;

  QuestionViewModel({
    required this.id,
    required this.answer,
    required this.answerFile,
    required this.index,
    required this.required,
    required this.identificador,
    required this.classificacao,
    required this.classification,
    required this.pergunta,
    required this.eTipoPergunta,
    required this.tipoPergunta,
    required this.criadoPor,
    required this.opcoes,
    required this.questionOptionsConfig,
    required this.questionType,
    required this.visible,
    required this.isFamilyGroupQuantity,
  });

  QuestionViewModel copyWith({
    String? id,
    String? answer,
    String? answerFile,
    int? index,
    bool? required,
    bool? identificador,
    String? classificacao,
    String? classification,
    String? pergunta,
    int? eTipoPergunta,
    String? tipoPergunta,
    String? criadoPor,
    QuestionOptionsViewModel? opcoes,
    List<QuestionOptionsConfigViewModel>? questionOptionsConfig,
    QuestionType? questionType,
    bool? visible,
    bool? isFamilyGroupQuantity,
  }) {
    return QuestionViewModel(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      answerFile: answerFile ?? this.answerFile,
      index: index ?? this.index,
      required: required ?? this.required,
      identificador: identificador ?? this.identificador,
      classificacao: classificacao ?? this.classificacao,
      classification: classification ?? this.classification,
      pergunta: pergunta ?? this.pergunta,
      eTipoPergunta: eTipoPergunta ?? this.eTipoPergunta,
      tipoPergunta: tipoPergunta ?? this.tipoPergunta,
      criadoPor: criadoPor ?? this.criadoPor,
      opcoes: opcoes ?? this.opcoes,
      questionOptionsConfig:
          questionOptionsConfig ?? this.questionOptionsConfig,
      questionType: questionType ?? this.questionType,
      visible: visible ?? this.visible,
      isFamilyGroupQuantity:
          isFamilyGroupQuantity ?? this.isFamilyGroupQuantity,
    );
  }

  RemoteQuestionFill toParams() => RemoteQuestionFill(
        answer: answer,
        questionId: id,
      );

  QuestionOptionsConfigViewModel? getQuestionOptionsConfigViewModelByAnswer(
      String? answerQuestion) {
    if (answerQuestion == null) {
      return null;
    }

    for (QuestionOptionsConfigViewModel? config
        in questionOptionsConfig ?? []) {
      final item1Value = config?.options?['item1'];
      if (item1Value != null &&
          item1Value == int.tryParse(answerQuestion) &&
          config?.shiftActionEnum != ShiftAction.none) {
        return config;
      }
    }

    return null;
  }

  QuestionOptionsConfigViewModel? get optionsConfigViewModelByAnswer {
    if (answer == null) {
      return null;
    }

    for (QuestionOptionsConfigViewModel? config
        in questionOptionsConfig ?? []) {
      final item1Value = config?.options?['item1'];
      if (item1Value != null &&
          item1Value == int.tryParse(answer ?? '') &&
          config?.shiftActionEnum != ShiftAction.none) {
        return config;
      }
    }

    return null;
  }

  String diffList(String newListStr) {
    final oldListStr = answer ?? '';
    final oldList = oldListStr
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => int.parse(e.trim()))
        .toList();

    final newList = newListStr
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => int.parse(e.trim()))
        .toList();

    final oldSet = oldList.toSet();
    final newSet = newList.toSet();

    final added = newSet.difference(oldSet);
    final removed = oldSet.difference(newSet);

    final changed = [...added, ...removed];

    return changed.isEmpty ? '' : changed.join(',');
  }
}

extension QuestionViewModelExtension on QuestionEntity {
  QuestionViewModel toViewModel(
      RemoteQuestionFill? question, FormVerifyEntity? data) {
    return QuestionViewModel(
      index: index,
      questionOptionsConfig:
          questionOptionsConfig?.map((c) => c.toViewModel()).toList(),
      id: id,
      answer: data?.data
              ?.firstWhereOrNull((element) => element.questionId == id)
              ?.answer ??
          question?.answer,
      identificador: identificador,
      classificacao: classificacao,
      pergunta: pergunta,
      eTipoPergunta: eTipoPergunta,
      tipoPergunta: tipoPergunta,
      criadoPor: criadoPor,
      opcoes: opcoes?.toViewModel(),
      required: required,
      classification: classification,
      questionType: QuestionType.fromType(eTipoPergunta),
      answerFile: question?.answerFile,
      visible: ((question?.tapsInItemsToHideQuestion?.values
                  .any((list) => (list as List).isNotEmpty) ??
              false)
          ? false
          : ((question?.tapsInItemsToShowQuestion?.values
                      .any((list) => (list as List).isNotEmpty) ??
                  false)
              ? true
              : visible)),
      isFamilyGroupQuantity: isFamilyGroupQuantity,
    );
  }
}

class QuestionOptionsViewModel {
  final Map<String, dynamic>? options;
  final Map<String, dynamic>? validations;

  QuestionOptionsViewModel({
    required this.options,
    required this.validations,
  });

  QuestionOptionsViewModel copyWith({
    Map<String, dynamic>? options,
    Map<String, dynamic>? validations,
  }) {
    return QuestionOptionsViewModel(
      options: options ?? this.options,
      validations: validations ?? this.validations,
    );
  }
}

extension QuestionOptionsViewModelExtension on QuestionOptionsEntity {
  QuestionOptionsViewModel toViewModel() => QuestionOptionsViewModel(
        options: options,
        validations: validations,
      );
}

class QuestionOptionsConfigViewModel {
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

  QuestionOptionsConfigViewModel({
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

  QuestionOptionsConfigViewModel copyWith({
    Map<String, dynamic>? options,
    int? index,
    bool? hide,
    int? rating,
    bool? disqualify,
    bool? shiftActionVisible,
    double? size,
    String? baseDate,
    String? shiftAction,
    int? shiftActionIndex,
    String? shiftSelectedAction,
  }) {
    return QuestionOptionsConfigViewModel(
      options: options ?? this.options,
      index: index ?? this.index,
      hide: hide ?? this.hide,
      rating: rating ?? this.rating,
      disqualify: disqualify ?? this.disqualify,
      shiftActionVisible: shiftActionVisible ?? this.shiftActionVisible,
      size: size ?? this.size,
      baseDate: baseDate ?? this.baseDate,
      shiftAction: shiftAction ?? this.shiftAction,
      shiftActionIndex: shiftActionIndex ?? this.shiftActionIndex,
      shiftSelectedAction: shiftSelectedAction ?? this.shiftSelectedAction,
    );
  }

  ShiftAction get shiftActionEnum => ShiftAction.fromString(shiftAction);
}

extension QuestionOptionsConfigViewModelExtension
    on QuestionOptionsConfigEntity {
  QuestionOptionsConfigViewModel toViewModel() =>
      QuestionOptionsConfigViewModel(
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
}

enum QuestionType {
  unicaSelecao,
  textoCurto,
  textoLongo,
  desconhecido,
  anexo,
  linearScale,
  multiplaEscolha,
  hora,
  data;

  static QuestionType fromType(int? value) {
    switch (value) {
      case 0:
        return QuestionType.textoCurto;
      case 1:
        return QuestionType.textoLongo;
      case 2:
        return QuestionType.unicaSelecao;
      case 6:
        return QuestionType.anexo;
      case 7:
        return QuestionType.linearScale;
      case 3:
        return QuestionType.multiplaEscolha;
      case 4:
        return QuestionType.data;
      case 5:
        return QuestionType.hora;
      default:
        return QuestionType.desconhecido;
    }
  }
}

enum QuestionClassification {
  pessoais,
  grupoFamiliar,
  dadosVulnerabilidade,
  desconhecido;

  static QuestionClassification fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pessoais':
        return QuestionClassification.pessoais;
      case 'grupofamiliar':
        return QuestionClassification.grupoFamiliar;
      case 'dadosvunerabilidade':
        return QuestionClassification.dadosVulnerabilidade;
      default:
        return QuestionClassification.desconhecido;
    }
  }
}

enum ShiftAction {
  nextQuestion,
  lastQuestion,
  toQuestion,
  toSession,
  endForm,
  none;

  static ShiftAction fromString(String? value) {
    return ShiftAction.values.firstWhere(
        (e) => e.name.toLowerCase() == value?.toLowerCase(),
        orElse: () => ShiftAction.none);
  }
}
