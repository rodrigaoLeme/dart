import '../../../data/usecases/answer_form/local_load_answer_form.dart';
import '../../../data/usecases/answer_form/remote_load_answer_form.dart';
import '../../../domain/entities/answer_form/answer_form_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/answer_form/load_answer_form.dart';

class RemoteLoadAnswerFormWithLocalFallback implements LoadAnswerForm {
  final RemoteLoadAnswerForm remote;
  final LocalLoadAnswerForm local;

  RemoteLoadAnswerFormWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<AnswerFormEntity> load(String? key) async {
    try {
      final result = await remote.load(key);
      await local.save(result, key);

      return result;
    } catch (error) {
      if (error == DomainError.accessDenied ||
          error == DomainError.expiredSession) {
        rethrow;
      }
      await local.validate(key);
      return await local.load(key);
    }
  }
}
