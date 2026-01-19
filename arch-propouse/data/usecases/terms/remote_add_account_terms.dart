import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/add_account_terms.dart';
import '../../http/http.dart';

class RemoteAddAccountTerms implements AddAccountTerms {
  final String url;
  final AdraHttpClient httpClient;

  RemoteAddAccountTerms({required this.url, required this.httpClient});

  @override
  Future<void> add(AddAccountTermsParams params) async {
    try {
      return await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: RemoteAddAccountTermsParams.fromDomain(params).toJson(),
      );
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

class RemoteAddAccountTermsParams {
  final int version;

  RemoteAddAccountTermsParams({
    required this.version,
  });

  factory RemoteAddAccountTermsParams.fromDomain(
          AddAccountTermsParams params) =>
      RemoteAddAccountTermsParams(
        version: params.version,
      );

  Map toJson() => {
        'termsVersion': version,
      };
}
