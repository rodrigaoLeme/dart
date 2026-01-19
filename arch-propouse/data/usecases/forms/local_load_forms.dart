import '../../../domain/entities/forms/forms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms/load_forms.dart';
import '../../cache/cache.dart';
import '../../models/forms/forms_model.dart';

class LocalLoadForms implements LoadForms {
  final CacheStorage cacheStorage;

  LocalLoadForms({required this.cacheStorage});

  @override
  Future<FormEntity> load() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.forms);
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return FormModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.forms);
      FormModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete(SecureStorageKey.forms);
    }
  }

  Future<void> save(FormEntity data) async {
    try {
      final json = FormModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: SecureStorageKey.forms,
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
