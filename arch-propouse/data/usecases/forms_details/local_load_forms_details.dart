import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/load_forms_details.dart';
import '../../cache/cache.dart';
import '../../models/forms_details/forms_details_model.dart';

class LocalLoadFormsDetails implements LoadFormsDetails {
  final CacheStorage cacheStorage;

  LocalLoadFormsDetails({required this.cacheStorage});

  @override
  Future<FormsDetailsEntity> load(String? key) async {
    try {
      final data =
          await cacheStorage.fetch('${SecureStorageKey.formsDetails}-$key');
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return FormsDetailsModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String? key) async {
    try {
      final data =
          await cacheStorage.fetch('${SecureStorageKey.formsDetails}-$key');
      FormsDetailsModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('${SecureStorageKey.formsDetails}-$key');
    }
  }

  Future<void> save(FormsDetailsEntity data, String? key) async {
    try {
      final json = FormsDetailsModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: '${SecureStorageKey.formsDetails}-$key',
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
