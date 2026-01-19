import '../../../domain/entities/share/generic_error_entity.dart';
import '../../http/http.dart';

class RemoteGenericErrorModel {
  final String? data;
  final bool? success;
  final List<GenericErrorsModel>? errors;

  RemoteGenericErrorModel({
    required this.data,
    required this.success,
    required this.errors,
  });

  factory RemoteGenericErrorModel.fromJson(Map json) {
    if (!json.containsKey('errors')) {
      throw HttpError.invalidData;
    }

    return RemoteGenericErrorModel(
      data: json['data'],
      success: json['success'],
      errors: json['errors']
          .map<GenericErrorsModel>((e) => GenericErrorsModel.fromJson(e))
          .toList(),
    );
  }

  GenericErrorEntity toEntity() => GenericErrorEntity(
        data: data,
        success: success,
        errors: errors?.map((e) => e.toEntity()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'data': data,
        'success': success,
        'errors': errors?.map((e) => e.toJson()).toList(),
      };
}

class GenericErrorsModel {
  final List<GenericSessions>? sessions;

  GenericErrorsModel({required this.sessions});

  factory GenericErrorsModel.fromJson(Map json) {
    return GenericErrorsModel(
      sessions: json['sessions']
          .map<GenericSessions>((e) => GenericSessions.fromJson(e))
          .toList(),
    );
  }

  GenericErrorsEntity toEntity() => GenericErrorsEntity(
        sessions: sessions?.map((e) => e.toEntity()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'sessions': sessions?.map((e) => e.toJson()).toList(),
      };
}

class GenericSessions {
  final int? index;
  final String? title;
  final String? error;

  GenericSessions({
    required this.index,
    required this.title,
    required this.error,
  });

  factory GenericSessions.fromJson(Map json) {
    return GenericSessions(
      index: json['index'],
      title: json['title'],
      error: json['error'],
    );
  }

  GenericSessionsEntity toEntity() => GenericSessionsEntity(
        index: index,
        title: title,
        error: error,
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        'title': title,
        'error': error,
      };
}
