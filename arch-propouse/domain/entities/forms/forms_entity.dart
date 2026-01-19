class FormEntity {
  final List<FormsEntity>? data;
  final bool? error;
  final bool? success;

  FormEntity({
    required this.data,
    required this.error,
    required this.success,
  });
}

class FormsEntity {
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

  FormsEntity({
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
}
