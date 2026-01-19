import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_verify/form_verify.dart';
import '../../http/http.dart';
import '../../models/form_verify/remote_form_verify_model.dart';

class RemoteFormVerify implements FormVerify {
  final AdraHttpClient httpClient;
  final String url;

  RemoteFormVerify({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<FormVerifyEntity> verify(QuestionsVerifyParms params) async {
    try {
      final body = params.toJson();
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );

      return RemoteFormVerifyModel.fromJson(httpResponse).toEntity();
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
