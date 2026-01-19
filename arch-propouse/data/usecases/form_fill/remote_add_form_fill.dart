import '../../../domain/entities/share/generic_error_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_fill/add_form_fill.dart';
import '../../http/http.dart';
import '../../models/share/generic_error_model.dart';

class RemoteAddFormFill implements AddFormFill {
  final String url;
  final AdraHttpClient httpClient;

  RemoteAddFormFill({required this.url, required this.httpClient});

  @override
  Future<GenericErrorEntity?> add(RemoteAddFormFillParams params) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: params.toParams(),
      );
      return RemoteGenericErrorModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

class RemoteAddFormFillParams {
  final String? groupId;
  final String? formId;
  final RemoteFormsFill? mainForm;
  final List<RemoteFormsFill>? subForms;

  RemoteAddFormFillParams({
    this.groupId,
    this.formId,
    this.mainForm,
    this.subForms,
  });

  String get identifierForm {
    return '$formId-$groupId';
  }

  factory RemoteAddFormFillParams.fromJson(Map<String, dynamic> json) {
    return RemoteAddFormFillParams(
      groupId: json['groupId'] as String?,
      formId: json['formId'] as String?,
      mainForm: json['mainForm'] != null
          ? RemoteFormsFill.fromJson(json['mainForm'])
          : null,
      subForms: json['subForms']
          ?.map<RemoteFormsFill>(
              (dataJson) => RemoteFormsFill.fromJson(dataJson))
          .toList(),
    );
  }

  RemoteAddFormFillParams copyWith({
    String? groupId,
    String? formId,
    RemoteFormsFill? mainForm,
    List<RemoteFormsFill>? subForms,
  }) {
    return RemoteAddFormFillParams(
      groupId: groupId ?? this.groupId,
      formId: formId ?? this.formId,
      mainForm: mainForm ?? this.mainForm,
      subForms: subForms ?? this.subForms,
    );
  }

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'formId': formId,
        'mainForm': mainForm?.toJson(),
        'subForms': subForms?.map((e) => e.toJson()).toList(),
      };

  Map<String, dynamic> toParams() => {
        'groupId': groupId,
        'formId': formId,
        'mainForm': mainForm?.toParams(),
        'subForms': subForms?.map((e) => e.toParams()).toList(),
      };
}

class RemoteFormsFill {
  final List<RemoteSessionFill?>? sessions;
  final String? localUUID;

  RemoteFormsFill({
    this.sessions,
    this.localUUID,
  });

  factory RemoteFormsFill.fromJson(Map<String, dynamic> json) {
    return RemoteFormsFill(
        sessions: (json['sessions'] as List<dynamic>?)
            ?.map((e) => e == null
                ? null
                : RemoteSessionFill.fromJson(e as Map<String, dynamic>))
            .toList(),
        localUUID: json['localUUID']);
  }

  RemoteFormsFill copyWith({
    List<RemoteSessionFill?>? sessions,
    String? localUUID,
  }) {
    return RemoteFormsFill(
      sessions: sessions ?? this.sessions,
      localUUID: localUUID,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessions': sessions?.map((s) => s?.toJson()).toList(),
        'localUUID': localUUID,
      };

  Map<String, dynamic> toParams() => {
        'sessions': sessions
            ?.where((s) => s != null)
            .map((s) {
              final session = s!;
              final hasHide = session.tapsInItemsToHideSession?.values
                      .any((list) => (list as List).isNotEmpty) ??
                  false;
              final hasShow = session.tapsInItemsToShowSession?.values
                      .any((list) => (list as List).isNotEmpty) ??
                  false;
              final defaultVisible = session.defaultVisible != false;
              final isVisibleByAnswer = session.isVisibleByAnswer;
              final finalVisible = isVisibleByAnswer == false
                  ? false
                  : (hasHide ? false : (hasShow ? true : defaultVisible));

              if (!finalVisible) {
                return null;
              }

              final filteredQuestions = session.questions?.where((q) {
                if (q == null) return false;
                final hasHideQ = q.tapsInItemsToHideQuestion?.values
                        .any((list) => (list as List).isNotEmpty) ??
                    false;
                final hasAnswer = (q.answer != null && q.answer!.isNotEmpty) ||
                    (q.answerFile != null && q.answerFile!.isNotEmpty);
                return !hasHideQ && hasAnswer;
              }).toList();

              final sessionJson =
                  session.copyWith(questions: filteredQuestions).toParams();

              final hasQuestions = (filteredQuestions?.isNotEmpty ?? false);
              return hasQuestions ? sessionJson : null;
            })
            .where((e) => e != null)
            .toList(),
        'localUUID': localUUID,
      };
}

class RemoteSessionFill {
  final String? sessionId;
  final int? index;
  List<RemoteQuestionFill?>? questions;
  Map<String, dynamic>? tapsInItemsToShowSession;
  Map<String, dynamic>? tapsInItemsToHideSession;
  bool? isVisibleByAnswer;
  bool? defaultVisible;

  RemoteSessionFill({
    this.sessionId,
    this.index,
    this.questions,
    this.tapsInItemsToShowSession,
    this.tapsInItemsToHideSession,
    this.isVisibleByAnswer,
    this.defaultVisible,
  });

  RemoteSessionFill copyWith({
    String? sessionId,
    int? index,
    List<RemoteQuestionFill?>? questions,
    Map<String, dynamic>? tapsInItemsToShowSession,
    Map<String, dynamic>? tapsInItemsToHideSession,
    bool? isVisibleByAnswer,
    bool? defaultVisible,
  }) {
    return RemoteSessionFill(
      sessionId: sessionId ?? this.sessionId,
      index: index ?? this.index,
      questions: questions ?? this.questions,
      tapsInItemsToShowSession:
          tapsInItemsToShowSession ?? this.tapsInItemsToShowSession,
      tapsInItemsToHideSession:
          tapsInItemsToHideSession ?? this.tapsInItemsToHideSession,
      isVisibleByAnswer: isVisibleByAnswer ?? this.isVisibleByAnswer,
      defaultVisible: defaultVisible ?? this.defaultVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'index': index,
      'questions': questions?.map((q) => q?.toJson()).toList(),
      'tapsInItemsToShowSession': tapsInItemsToShowSession,
      'tapsInItemsToHideSession': tapsInItemsToHideSession,
      'isVisibleByAnswer': isVisibleByAnswer,
      'defaultVisible': defaultVisible,
    };
  }

  Map<String, dynamic> toParams() {
    return {
      'sessionId': sessionId,
      'questions': questions?.map((q) => q?.toParams()).toList(),
    };
  }

  factory RemoteSessionFill.fromJson(Map<String, dynamic> json) {
    return RemoteSessionFill(
      sessionId: json['session_id'],
      index: json['index'],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => q == null ? null : RemoteQuestionFill.fromJson(q))
          .toList(),
      tapsInItemsToShowSession: json['tapsInItemsToShowSession'],
      tapsInItemsToHideSession: json['tapsInItemsToHideSession'],
      isVisibleByAnswer: json['isVisibleByAnswer'],
      defaultVisible: json['defaultVisible'],
    );
  }
}

class RemoteQuestionFill {
  final String? questionId;
  final String? answer;
  final String? answerFile;
  final int? index;
  Map<String, dynamic>? tapsInItemsToShowQuestion;
  Map<String, dynamic>? tapsInItemsToHideQuestion;

  RemoteQuestionFill({
    this.questionId,
    this.answer,
    this.answerFile,
    this.index,
    this.tapsInItemsToShowQuestion,
    this.tapsInItemsToHideQuestion,
  });

  RemoteQuestionFill copyWith({
    String? questionId,
    String? answer,
    String? answerFile,
    int? index,
    Map<String, dynamic>? tapsInItemsToShowQuestion,
    Map<String, dynamic>? tapsInItemsToHideQuestion,
  }) {
    return RemoteQuestionFill(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      answerFile: answerFile ?? this.answerFile,
      index: index ?? this.index,
      tapsInItemsToShowQuestion:
          tapsInItemsToShowQuestion ?? this.tapsInItemsToShowQuestion,
      tapsInItemsToHideQuestion:
          tapsInItemsToHideQuestion ?? this.tapsInItemsToHideQuestion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
      'answer_file': answerFile,
      'index': index,
      'tapsInItemsToShowQuestion': tapsInItemsToShowQuestion,
      'tapsInItemsToHideQuestion': tapsInItemsToHideQuestion,
    };
  }

  Map<String, dynamic> toParams() {
    return {
      'questionId': questionId,
      'answer': answer,
    };
  }

  factory RemoteQuestionFill.fromJson(Map<String, dynamic> json) {
    return RemoteQuestionFill(
      questionId: json['question_id'],
      answer: json['answer'],
      answerFile: json['answer_file'],
      index: json['index'],
      tapsInItemsToShowQuestion: json['tapsInItemsToShowQuestion'],
      tapsInItemsToHideQuestion: json['tapsInItemsToHideQuestion'],
    );
  }
}
