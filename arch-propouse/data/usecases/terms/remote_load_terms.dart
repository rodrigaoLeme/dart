import '../../../domain/entities/terms/terms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/load_terms.dart';
import '../../http/http.dart';
import '../../models/terms/terms_model.dart';

class RemoteLoadTerms implements LoadTerms {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadTerms({required this.url, required this.httpClient});

  @override
  Future<TermsEntity> load() async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return TermsModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
