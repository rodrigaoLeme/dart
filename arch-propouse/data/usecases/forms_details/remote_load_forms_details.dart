import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/load_forms_details.dart';
import '../../http/http.dart';
import '../../models/forms_details/forms_details_model.dart';

class RemoteLoadFormsDetails implements LoadFormsDetails {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadFormsDetails({required this.url, required this.httpClient});

  @override
  Future<FormsDetailsEntity> load(String? key) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return FormsDetailsModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
