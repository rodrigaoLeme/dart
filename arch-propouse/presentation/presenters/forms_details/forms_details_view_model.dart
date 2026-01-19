import 'package:collection/collection.dart';

import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/entities/share/generic_error_entity.dart';
import '../../../ui/helpers/extensions/extensions.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';
import '../answer_form/answer_form_view_model.dart';
import '../status/status_view_model.dart';

class FormsDetailsViewModel {
  final FormsDetailsDataViewModel? data;
  final List<String>? error;
  final bool? success;
  final SessionViewModel? sessionToEdit;
  final AnswerFlow? answerFlow;
  String? currentUUID;
  final StatusCardViewModel? statusCardViewModel;

  FormsDetailsViewModel({
    required this.data,
    required this.success,
    required this.error,
    this.sessionToEdit,
    this.answerFlow = AnswerFlow.main,
    this.currentUUID,
    this.statusCardViewModel,
  });

  FormsDetailsViewModel copyWith({
    FormsDetailsDataViewModel? data,
    List<String>? error,
    bool? success,
    SessionViewModel? sessionToEdit,
    AnswerFlow? answerFlow,
    String? currentUUID,
    StatusCardViewModel? statusCardViewModel,
  }) {
    return FormsDetailsViewModel(
      data: data ?? this.data,
      error: error ?? this.error,
      success: success ?? this.success,
      sessionToEdit: sessionToEdit ?? this.sessionToEdit,
      answerFlow: answerFlow ?? this.answerFlow,
      currentUUID: currentUUID ?? this.currentUUID,
      statusCardViewModel: statusCardViewModel ?? this.statusCardViewModel,
    );
  }

  Map toJson() => {
        'success': success,
        'error': error,
        'data': data?.toJson(),
        'sessionToEdit': sessionToEdit?.toJson(),
      };
}

class FormsDetailsDataViewModel {
  final String? id;
  final String? formId;
  final String? groupId;
  final String? activityId;
  final String? formName;
  final String? projectId;
  final String? projectName;
  final String? group;
  final String? type;
  final int? send;
  final String? finalDate;
  final List<SessionViewModel>? sessions;
  final List<LatestFormSendedViewModel>? latestFormSended;
  List<LatestFormSendedViewModel>? localForms = [];

  FormsDetailsDataViewModel({
    required this.id,
    required this.formId,
    required this.groupId,
    required this.activityId,
    required this.formName,
    required this.projectId,
    required this.projectName,
    required this.group,
    required this.type,
    required this.send,
    required this.finalDate,
    required this.sessions,
    required this.latestFormSended,
    required this.localForms,
  });
  String get formatDate {
    final parsedDate = DateTime.tryParse(finalDate ?? '');
    if (parsedDate == null) return '';
    return parsedDate.dayMonthYear;
  }

  void setLocalForms(LatestFormSendedViewModel forms, bool identificador) {
    if (localForms == null) {
      localForms = [forms];
    } else {
      final index = localForms!.indexWhere((f) => f.id == forms.id);

      if (index != -1) {
        final isSameQuestion =
            localForms?[index].questionId == forms.questionId ||
                localForms?[index].questionId == null;

        if (identificador &&
            (isSameQuestion || localForms?[index].identificator == null)) {
          localForms?[index] = localForms![index].copyWith(
            identificator: forms.identificator,
            questionId: forms.questionId,
          );
        }
      } else {
        localForms?.add(forms);
      }
    }
  }

  Map toJson() => {
        'id': id,
        'formId': formId,
        'groupId': groupId,
        'activityId': activityId,
        'formName': formName,
        'projectId': projectId,
        'projectName': projectName,
        'group': group,
        'type': type,
        'send': send,
        'finalDate': finalDate,
        'sessions': sessions?.map((e) => e.toJson()).toList(),
        'latestFormSended': latestFormSended?.map((e) => e.toJson()).toList(),
        'localForms': localForms?.map((e) => e.toJson()).toList(),
      };

  String get identifierForm {
    return '$formId-$groupId';
  }
}

class LatestFormSendedViewModel {
  final String? id;
  final String? identificator;
  final String? questionId;
  final String? registeredDate;
  final GenericErrorEntity? genericErrorEntity;
  final LocalFormStatus? localFormStatus;

  LatestFormSendedViewModel({
    required this.id,
    required this.identificator,
    required this.questionId,
    required this.registeredDate,
    this.genericErrorEntity,
    this.localFormStatus,
  });

  String get formatDateHour {
    final parsedDate = DateTime.tryParse(registeredDate ?? '');
    if (parsedDate == null) return '';
    return HumanDateTime.humanDate(dateTime: parsedDate);
  }

  LatestFormSendedViewModel copyWith({
    String? id,
    String? identificator,
    String? questionId,
    String? registeredDate,
    GenericErrorEntity? genericErrorEntity,
    LocalFormStatus? localFormStatus,
  }) {
    return LatestFormSendedViewModel(
      id: id ?? this.id,
      identificator: identificator ?? this.identificator,
      registeredDate: registeredDate ?? this.registeredDate,
      questionId: registeredDate ?? this.questionId,
      genericErrorEntity: genericErrorEntity ?? this.genericErrorEntity,
      localFormStatus: localFormStatus ?? this.localFormStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'identificator': identificator,
        'questionId': questionId,
        'registeredDate': registeredDate,
        'error': genericErrorEntity?.toJson(),
        'localFormStatus': localFormStatus?.type,
      };
}

extension FormsDetailsViewModelExtension on FormsDetailsEntity {
  FormsDetailsViewModel toViewModel([RemoteFormsFill? formFill]) =>
      FormsDetailsViewModel(
        success: success,
        error: error,
        data: data?.toViewModel(formFill),
      );
}

extension FormsDetailsDataViewModelExtension on FormsDetailsDataEntity {
  FormsDetailsDataViewModel toViewModel(RemoteFormsFill? formFill) =>
      FormsDetailsDataViewModel(
        id: id,
        formId: formId,
        groupId: groupId,
        activityId: activityId,
        formName: formName,
        projectId: projectId,
        projectName: projectName,
        group: group,
        type: type,
        send: send,
        finalDate: finalDate,
        sessions: sessions
                ?.map((e) => e.toViewModel(
                      formFill?.sessions?.firstWhereOrNull(
                        (element) => element?.sessionId == e.id,
                      ),
                      null,
                    ))
                .toList() ??
            [],
        latestFormSended:
            latestFormSended?.map((e) => e.toViewModel()).toList() ?? [],
        localForms: localForms?.map((e) => e.toViewModel()).toList() ?? [],
      );
}

extension LatestFormSendedViewModelExtension on LatestFormSendedEntity {
  LatestFormSendedViewModel toViewModel() => LatestFormSendedViewModel(
        id: id,
        identificator: identificator,
        registeredDate: registeredDate,
        genericErrorEntity: genericErrorEntity,
        questionId: null,
        localFormStatus: localFormStatus,
      );
}

enum LocalFormStatus {
  draft('draft'),
  error('error'),
  wait('wait');

  const LocalFormStatus(this.type);
  final String type;
  String get label {
    switch (this) {
      case LocalFormStatus.error:
        return 'Erro';
      case LocalFormStatus.draft:
        return 'Rascunho';
      case LocalFormStatus.wait:
        return 'Aguardando envio';
    }
  }

  bool get shouldShowRefreshIcon {
    switch (this) {
      case LocalFormStatus.wait:
        return true;
      case LocalFormStatus.draft:
      case LocalFormStatus.error:
        return false;
    }
  }
}
