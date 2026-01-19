import '../../../domain/entities/forms/forms_entity.dart';
import '../../../ui/helpers/extensions/extensions.dart';

class FormViewModel {
  final List<FormsViewModel>? data;
  final bool? success;
  final bool? error;

  FormViewModel({
    required this.data,
    required this.success,
    required this.error,
  });
}

class FormsViewModel {
  final String? id;
  final String? activityId;
  final String? formName;
  final String? projectId;
  final String? projectName;
  final String? group;
  final String? type;
  final int? send;
  final String? finalDate;
  final String? groupId;
  final String? formId;

  FormsViewModel({
    required this.id,
    required this.activityId,
    required this.formName,
    required this.projectName,
    required this.projectId,
    required this.group,
    required this.type,
    required this.send,
    required this.finalDate,
    required this.groupId,
    required this.formId,
  });

  String get formatDate {
    final parsedDate = DateTime.tryParse(finalDate ?? '');
    if (parsedDate == null) return '';
    return parsedDate.dayMonthYear;
  }

  bool get isExpired => finalDate.isExpired;

  String get identifierForm {
    return '$formId-$groupId';
  }
}

extension FormViewModelExtensions on FormEntity {
  FormViewModel toViewModel() => FormViewModel(
        success: success,
        data: data
            ?.map(
              (element) => element.toViewModel(),
            )
            .toList(),
        error: error,
      );
}

extension FormsViewModelExtensions on FormsEntity {
  FormsViewModel toViewModel() => FormsViewModel(
        id: id,
        activityId: activityId,
        formName: formName,
        projectName: projectName,
        group: group,
        type: type,
        send: send,
        finalDate: finalDate,
        projectId: projectId,
        groupId: groupId,
        formId: formId,
      );
}
