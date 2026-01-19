import '../../../domain/entities/resources/resources_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/resources/load_resources.dart';
import '../../http/http.dart';
import '../../models/resources/resources_model.dart';

class RemoteLoadResources implements LoadResources {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadResources({required this.url, required this.httpClient});

  @override
  Future<ResourcesEntity> load() async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return ResourcesModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
