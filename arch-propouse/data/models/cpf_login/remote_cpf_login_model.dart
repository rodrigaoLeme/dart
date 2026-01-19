import 'dart:convert';

import '../../../domain/entities/cpf_login/cpf_login_entity.dart';
import '../../http/http.dart';

class RemoteCpfLoginModel {
  final String email;
  final String document;
  final String birthday;

  RemoteCpfLoginModel({
    required this.email,
    required this.document,
    required this.birthday,
  });

  factory RemoteCpfLoginModel.fromJson(Map json) {
    if (!json.containsKey('email') && !json.containsKey('document')) {
      throw HttpError.invalidData;
    }
    return RemoteCpfLoginModel(
      email: json['email'],
      document: json['document'],
      birthday: json['birthday'],
    );
  }

  factory RemoteCpfLoginModel.fromEntity(CpfLoginEntity entity) {
    return RemoteCpfLoginModel(
      email: entity.email,
      document: entity.document,
      birthday: entity.birthday,
    );
  }

  factory RemoteCpfLoginModel.fromStringfy(String string) {
    return RemoteCpfLoginModel.fromJson(jsonDecode(string));
  }

  CpfLoginEntity toEntity() => CpfLoginEntity(
        email: email,
        document: document,
        birthday: birthday,
      );

  Map toJson() => {
        'email': email,
        'document': document,
        'birthday': birthday,
      };
}
