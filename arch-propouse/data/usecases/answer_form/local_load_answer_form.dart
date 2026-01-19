import '../../../domain/entities/answer_form/answer_form_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/answer_form/load_answer_form.dart';
import '../../cache/cache.dart';
import '../../models/answer_form/answer_form_model.dart';

class LocalLoadAnswerForm implements LoadAnswerForm {
  final CacheStorage cacheStorage;

  LocalLoadAnswerForm({required this.cacheStorage});

  @override
  Future<AnswerFormEntity> load(String? key) async {
    try {
      final data = await cacheStorage.fetch(
        '${SecureStorageKey.answerForm}-$key',
      );
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return AnswerFormModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String? key) async {
    try {
      final data = await cacheStorage.fetch(
        '${SecureStorageKey.answerForm}-$key',
      );
      AnswerFormModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete(
        '${SecureStorageKey.answerForm}-$key',
      );
    }
  }

  Future<void> save(AnswerFormEntity data, String? key) async {
    try {
      final json = AnswerFormModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: '${SecureStorageKey.answerForm}-$key',
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
