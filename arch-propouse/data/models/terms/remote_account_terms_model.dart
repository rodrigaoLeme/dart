import '../../../domain/entities/terms/account_terms_entity.dart';
import '../../http/http.dart';

class RemoteAccountTermsModel {
  final bool success;
  final String key;
  final String message;
  final RemoteTermsDataModel data;
  final int statusCode;

  RemoteAccountTermsModel({
    required this.success,
    required this.key,
    required this.message,
    required this.data,
    required this.statusCode,
  });

  factory RemoteAccountTermsModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['success'])) {
      throw HttpError.invalidData;
    }
    return RemoteAccountTermsModel(
      success: json['success'],
      key: json['key'],
      message: json['message'],
      data: RemoteTermsDataModel.fromJson(json['data']),
      statusCode: json['statusCode'],
    );
  }

  AccountTermsEntity toEntity() => AccountTermsEntity(
        success: success,
        key: key,
        message: message,
        data: data.toEntity(),
        statusCode: statusCode,
      );

  Map toJson() => {
        'success': success,
        'key': key,
        'message': message,
        'data': data.toJson(),
        'statusCode': statusCode,
      };
}

class RemoteTermsDataModel {
  final int id;
  final String htmlContent;
  final int version;

  RemoteTermsDataModel({
    required this.id,
    required this.htmlContent,
    required this.version,
  });

  factory RemoteTermsDataModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['id', 'htmlContent', 'version'])) {
      throw HttpError.invalidData;
    }
    return RemoteTermsDataModel(
      id: json['id'],
      htmlContent: json['htmlContent'],
      version: json['version'],
    );
  }
  TermsDataEntity toEntity() => TermsDataEntity(
        id: id,
        htmlContent: htmlContent,
        version: version,
      );

  Map toJson() => {
        'id': id,
        'htmlContent': htmlContent,
        'version': version,
      };
}
