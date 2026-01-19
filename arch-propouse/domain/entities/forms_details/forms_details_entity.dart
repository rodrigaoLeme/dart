import '../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../answer_form/answer_form_entity.dart';
import '../share/generic_error_entity.dart';

class FormsDetailsEntity {
  final FormsDetailsDataEntity? data;
  final List<String>? error;
  final bool? success;

  FormsDetailsEntity({
    required this.data,
    required this.error,
    required this.success,
  });
}

class FormsDetailsDataEntity {
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
  final List<SessionEntity>? sessions;
  final List<LatestFormSendedEntity>? latestFormSended;
  final List<LatestFormSendedEntity>? localForms;

  FormsDetailsDataEntity({
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
    this.localForms,
  });
  String get identifier {
    return '$formId-$groupId';
  }
}

class LatestFormSendedEntity {
  final String? id;
  final String? identificator;
  final String? registeredDate;
  final GenericErrorEntity? genericErrorEntity;
  final LocalFormStatus? localFormStatus;

  LatestFormSendedEntity({
    required this.id,
    required this.identificator,
    required this.registeredDate,
    this.genericErrorEntity,
    this.localFormStatus,
  });

  LatestFormSendedEntity copyWith({
    String? id,
    String? identificator,
    String? registeredDate,
    GenericErrorEntity? genericErrorEntity,
    LocalFormStatus? localFormStatus,
  }) {
    return LatestFormSendedEntity(
      id: id ?? this.id,
      identificator: identificator ?? this.identificator,
      registeredDate: registeredDate ?? this.registeredDate,
      genericErrorEntity: genericErrorEntity ?? this.genericErrorEntity,
      localFormStatus: localFormStatus ?? this.localFormStatus,
    );
  }
}
