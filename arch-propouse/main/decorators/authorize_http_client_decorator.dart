import 'dart:io';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';
import '../../domain/usecases/account/load_current_account.dart';
import '../../domain/usecases/refresh_token/refresh_token.dart';
import '../../share/connection/internet_connection.dart';

class AuthorizeHttpClientDecorator implements AdraHttpClient {
  final LoadCurrentAccount loadCurrentAccount;
  final AddRefreshToken addRefreshToken;
  final SharedPreferencesStorage sharedPreferencesStorage;
  final AdraHttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.loadCurrentAccount,
    required this.sharedPreferencesStorage,
    required this.decoratee,
    required this.addRefreshToken,
  });

  @override
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
    File? file,
  }) async {
    try {
      final hasInternet =
          await ConnectivityService.instance.hasInternetAccess();
      if (!hasInternet) {
        throw HttpError.serverError;
      }

      final account = await loadCurrentAccount.load();
      String token = account?.accessToken ?? '';
      final authorizedHeaders = headers ?? {}
        ..addAll({'authorization': 'Bearer $token'});
      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: queryParameters);
      return await decoratee.request(
        url: finalUri.toString(),
        method: method,
        body: body,
        headers: authorizedHeaders,
        file: file,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        if (error == HttpError.unauthorized) {
          final account = await addRefreshToken.refresh();
          String token = account.accessToken;
          final authorizedHeaders = headers ?? {}
            ..addAll({'authorization': 'Bearer $token'});
          return await decoratee.request(
              url: url, method: method, body: body, headers: authorizedHeaders);
        } else {
          rethrow;
        }
      } else {
        await sharedPreferencesStorage.clean();
        throw HttpError.forbidden;
      }
    }
  }
}
