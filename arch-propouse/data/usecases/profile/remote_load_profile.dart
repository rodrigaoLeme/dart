import '../../../domain/entities/profile/profile_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/profile/load_profile.dart';
import '../../http/http.dart';
import '../../models/profile/profile_model.dart';

class RemoteLoadProfile implements LoadProfile {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadProfile({required this.url, required this.httpClient});

  @override
  Future<ProfileEntity> load() async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return ProfileModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
