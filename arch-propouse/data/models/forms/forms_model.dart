import '../../../domain/entities/forms/forms_entity.dart';
import '../../http/http.dart';

class FormModel {
  final List<FormsModel>? data;
  final bool? success;
  final bool? error;

  FormModel({
    required this.data,
    required this.success,
    required this.error,
  });

  factory FormModel.fromJson(Map json) {
    if (!json.containsKey('data')) {
      throw HttpError.invalidData;
    }

    return FormModel(
      data: json['data']
          .map<FormsModel>((dataJson) => FormsModel.fromJson(dataJson))
          .toList(),
      success: json['success'],
      error: json['error'],
    );
  }

  factory FormModel.fromEntity(FormEntity entity) => FormModel(
        success: entity.success,
        data: entity.data?.map((e) => FormsModel.fromEntity(e)).toList(),
        error: entity.error,
      );

  FormEntity toEntity() => FormEntity(
        data: data?.map<FormsEntity>((data) => data.toEntity()).toList(),
        success: success,
        error: error,
      );

  Map toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'error': error,
      };
}

class FormsModel {
  final String? id;
  final String? formId;
  final String? groupId;
  final String? activityId;
  final String? formName;
  final String? projectName;
  final String? projectId;
  final String? group;
  final String? type;
  final int? send;
  final String? finalDate;

  FormsModel({
    required this.id,
    required this.formId,
    required this.groupId,
    required this.activityId,
    required this.formName,
    required this.projectName,
    required this.projectId,
    required this.group,
    required this.type,
    required this.send,
    required this.finalDate,
  });

  factory FormsModel.fromJson(Map json) {
    if (!json.containsKey('id')) {
      throw HttpError.invalidData;
    }
    return FormsModel(
      id: json['id'],
      formId: json['formId'],
      groupId: json['groupId'],
      activityId: json['activityId'],
      formName: json['formName'],
      projectName: json['projectName'],
      projectId: json['projectId'],
      group: json['group'],
      type: json['type'],
      send: json['send'],
      finalDate: json['finalDate'],
    );
  }

  factory FormsModel.fromEntity(FormsEntity? entity) => FormsModel(
        id: entity?.id,
        formId: entity?.formId,
        groupId: entity?.groupId,
        activityId: entity?.activityId,
        formName: entity?.formName,
        projectName: entity?.projectName,
        projectId: entity?.projectId,
        group: entity?.group,
        type: entity?.type,
        send: entity?.send,
        finalDate: entity?.finalDate,
      );

  FormsEntity toEntity() => FormsEntity(
        id: id,
        formId: formId,
        groupId: groupId,
        activityId: activityId,
        formName: formName,
        projectName: projectName,
        projectId: projectId,
        group: group,
        type: type,
        send: send,
        finalDate: finalDate,
      );

  Map toJson() => {
        'id': id,
        'formId': formId,
        'groupId': groupId,
        'activityId': activityId,
        'formName': formName,
        'projectName': projectName,
        'projectId': projectId,
        'group': group,
        'type': type,
        'send': send,
        'finalDate': finalDate,
      };
}
