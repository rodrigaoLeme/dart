import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/authentication.dart';
import '../../http/http.dart';
import '../../models/account/remote_account_token_model.dart';

class RemoteAuthentication implements Authentication {
  final AdraHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountTokenEntity> auth(AuthenticationParams params) async {
    try {
      final body = params.toJson();
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );

      return RemoteAccountTokenModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
        case HttpError.notFound:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}
