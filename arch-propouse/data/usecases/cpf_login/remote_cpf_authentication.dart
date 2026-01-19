import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/cpf_login/cpf_authentication.dart';
import '../../http/http.dart';

class RemoteCpfAuthentication implements CpfAuthentication {
  final AdraHttpClient httpClient;
  final String url;

  RemoteCpfAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<void> auth(CpfAuthenticationParams params) async {
    try {
      final body = params.toJson();
      return await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );
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
