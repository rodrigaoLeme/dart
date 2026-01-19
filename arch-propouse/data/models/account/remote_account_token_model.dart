import 'dart:convert';

import '../../../domain/entities/account/account_token_entity.dart';
import '../../http/http.dart';

class RemoteAccountTokenModel {
  final String accessToken;
  final String refreshToken;
  final String? photoUrl;

  RemoteAccountTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.photoUrl,
  });

  factory RemoteAccountTokenModel.fromJson(Map json) {
    if (!json.containsKey('accessToken') && !json.containsKey('refreshToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountTokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      photoUrl: json['photoUrl'],
    );
  }

  factory RemoteAccountTokenModel.fromEntity(AccountTokenEntity entity) {
    return RemoteAccountTokenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      photoUrl: entity.photoUrl,
    );
  }

  factory RemoteAccountTokenModel.fromStringfy(String string) {
    return RemoteAccountTokenModel.fromJson(jsonDecode(string));
  }

  AccountTokenEntity toEntity() => AccountTokenEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        photoUrl: photoUrl,
      );

  Map toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'photoUrl': photoUrl,
      };
}
