import '../../../domain/entities/terms/terms_entity.dart';
import '../../http/http.dart';

class TermsModel {
  final UserTermsModel? data;
  final bool? success;

  TermsModel({
    required this.data,
    required this.success,
  });

  factory TermsModel.fromJson(Map json) {
    if (!json.containsKey('data')) {
      throw HttpError.invalidData;
    }

    return TermsModel(
      data: UserTermsModel.fromJson(json['data']),
      success: json['success'],
    );
  }

  factory TermsModel.fromEntity(TermsEntity entity) => TermsModel(
        success: entity.success,
        data: UserTermsModel.fromEntity(entity.data),
      );

  TermsEntity toEntity() => TermsEntity(
        data: data?.toEntity(),
        success: success,
      );

  Map toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

class UserTermsModel {
  final String? id;
  final String? policy;
  final String? term;
  final bool? current;
  final String? version;

  UserTermsModel({
    required this.id,
    required this.policy,
    required this.term,
    required this.current,
    required this.version,
  });

  factory UserTermsModel.fromJson(Map json) {
    if (!json.containsKey('id')) {
      throw HttpError.invalidData;
    }
    return UserTermsModel(
      id: json['id'],
      policy: json['policy'],
      term: json['term'],
      current: json['current'],
      version: json['version'],
    );
  }

  factory UserTermsModel.fromEntity(UserTermsEntity? entity) => UserTermsModel(
        id: entity?.id,
        policy: entity?.policy,
        term: entity?.term,
        current: entity?.current,
        version: entity?.version,
      );

  UserTermsEntity toEntity() => UserTermsEntity(
        id: id,
        policy: policy,
        term: term,
        current: current,
        version: version,
      );

  Map toJson() => {
        'id': id,
        'policy': policy,
        'term': term,
        'current': current,
        'version': version,
      };
}
