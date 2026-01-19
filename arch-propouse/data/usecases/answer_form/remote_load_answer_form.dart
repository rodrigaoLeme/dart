import '../../../domain/entities/answer_form/answer_form_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/answer_form/load_answer_form.dart';
import '../../http/http.dart';
import '../../models/answer_form/answer_form_model.dart';

class RemoteLoadAnswerForm implements LoadAnswerForm {
  final String url;
  final AdraHttpClient httpClient;

  RemoteLoadAnswerForm({required this.url, required this.httpClient});

  @override
  Future<AnswerFormEntity> load(String? key) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.get,
      );
      return AnswerFormModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
