import 'dart:convert';

import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../../domain/usecases/refresh_token/refresh_token.dart';
import '../../http/http.dart';
import '../../models/account/remote_account_token_model.dart';

class RemoteAddRefreshToken implements AddRefreshToken {
  final AdraHttpClient httpClient;
  final String url;
  final LoadCurrentAccount loadCurrentAccount;
  final SaveCurrentAccount saveCurrentAccount;

  RemoteAddRefreshToken({
    required this.httpClient,
    required this.url,
    required this.loadCurrentAccount,
    required this.saveCurrentAccount,
  });

  @override
  Future<AccountTokenEntity> refresh() async {
    try {
      final account = await loadCurrentAccount.load();
      if (account == null) {
        throw DomainError.expiredSession;
      }
      final body = RemoteAddRefreshTokenParams(
        refreshToken: account.refreshToken,
        token: account.accessToken,
      ).toJson();
      final refreshToken = await httpClient.request(
          url: url, method: HttpMethod.post, body: body);
      refreshToken['photoUrl'] = account.photoUrl;
      final json = jsonEncode(refreshToken);
      await saveCurrentAccount.save(json);
      return RemoteAccountTokenModel.fromJson(refreshToken).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.expiredSession;
    }
  }
}

class RemoteAddRefreshTokenParams {
  final String token;
  final String refreshToken;

  RemoteAddRefreshTokenParams({
    required this.token,
    required this.refreshToken,
  });

  Map toJson() => {
        'token': token,
        'refreshToken': refreshToken,
      };
}
