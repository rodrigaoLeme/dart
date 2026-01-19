import '../../../domain/entities/forms/forms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms/load_forms.dart';
import '../../http/http.dart';
import '../../models/forms/forms_model.dart';

class RemoteLoadForms implements LoadForms {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadForms({required this.url, required this.httpClient});

  @override
  Future<FormEntity> load() async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return FormModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
