import 'package:collection/collection.dart';

import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../http/http.dart';
import '../answer_form/answer_form_model.dart';
import '../share/generic_error_model.dart';

class FormsDetailsModel {
  final FormsDetailsDataModel? data;
  final List<String>? error;
  final bool? success;

  FormsDetailsModel({
    required this.data,
    required this.error,
    required this.success,
  });

  factory FormsDetailsModel.fromJson(Map json) {
    if (!json.containsKey('data')) throw HttpError.invalidData;

    return FormsDetailsModel(
      data: json['data'] != null
          ? FormsDetailsDataModel.fromJson(json['data'])
          : null,
      success: json['success'],
      error: (json['error'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  factory FormsDetailsModel.fromEntity(FormsDetailsEntity entity) =>
      FormsDetailsModel(
        success: entity.success,
        error: entity.error,
        data: entity.data != null
            ? FormsDetailsDataModel.fromEntity(entity.data!)
            : null,
      );

  FormsDetailsEntity toEntity() => FormsDetailsEntity(
        success: success,
        error: error,
        data: data?.toEntity(),
      );

  Map toJson() => {
        'success': success,
        'error': error,
        'data': data?.toJson(),
      };
}

class FormsDetailsDataModel {
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
  final List<SessionModel>? sessions;
  final List<LatestFormSendedModel>? latestFormSended;
  final List<LatestFormSendedModel>? localForms;

  FormsDetailsDataModel({
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

  factory FormsDetailsDataModel.fromJson(Map json) {
    return FormsDetailsDataModel(
      id: json['id'],
      formId: json['formId'],
      groupId: json['groupId'],
      activityId: json['activityId'],
      formName: json['formName'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      group: json['group'],
      type: json['type'],
      send: json['send'],
      finalDate: json['finalDate'],
      sessions: (json['sessions'] as List?)
          ?.map((e) => SessionModel.fromJson(e))
          .toList(),
      latestFormSended: (json['latestFormSended'] as List?)
              ?.map((e) => LatestFormSendedModel.fromJson(e))
              .toList() ??
          [],
      localForms: (json['localForms'] as List?)
              ?.map((e) => LatestFormSendedModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory FormsDetailsDataModel.fromEntity(FormsDetailsDataEntity entity) =>
      FormsDetailsDataModel(
        id: entity.id,
        formId: entity.formId,
        groupId: entity.groupId,
        activityId: entity.activityId,
        formName: entity.formName,
        projectId: entity.projectId,
        projectName: entity.projectName,
        group: entity.group,
        type: entity.type,
        send: entity.send,
        finalDate: entity.finalDate,
        sessions:
            entity.sessions?.map((e) => SessionModel.fromEntity(e)).toList(),
        latestFormSended: entity.latestFormSended
                ?.map((e) => LatestFormSendedModel.fromEntity(e))
                .toList() ??
            [],
      );

  FormsDetailsDataEntity toEntity() => FormsDetailsDataEntity(
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
        sessions: sessions?.map((e) => e.toEntity()).toList(),
        latestFormSended:
            latestFormSended?.map((e) => e.toEntity()).toList() ?? [],
        localForms: localForms?.map((e) => e.toEntity()).toList() ?? [],
      );

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
}

class LatestFormSendedModel {
  final String? id;
  final String? identificator;
  final String? registeredDate;
  final RemoteGenericErrorModel? genericErrorModel;
  final LocalFormStatus? localFormStatus;

  LatestFormSendedModel({
    required this.id,
    required this.identificator,
    required this.registeredDate,
    this.genericErrorModel,
    this.localFormStatus,
  });

  factory LatestFormSendedModel.fromJson(Map json) => LatestFormSendedModel(
        id: json['id'],
        identificator: json['identificator'],
        registeredDate: json['registeredDate'],
        genericErrorModel: json['error'] != null
            ? RemoteGenericErrorModel.fromJson(json['error'])
            : null,
        localFormStatus: LocalFormStatus.values.firstWhereOrNull(
          (element) => element.type == json['localFormStatus'],
        ),
      );

  factory LatestFormSendedModel.fromEntity(LatestFormSendedEntity entity) =>
      LatestFormSendedModel(
        id: entity.id,
        identificator: entity.identificator,
        registeredDate: entity.registeredDate,
      );

  LatestFormSendedEntity toEntity() => LatestFormSendedEntity(
        id: id,
        identificator: identificator,
        registeredDate: registeredDate,
        genericErrorEntity: genericErrorModel?.toEntity(),
        localFormStatus: localFormStatus,
      );

  Map toJson() => {
        'id': id,
        'identificator': identificator,
        'registeredDate': registeredDate,
        'error': genericErrorModel?.toJson(),
        'localFormStatus': localFormStatus?.type,
      };
}
