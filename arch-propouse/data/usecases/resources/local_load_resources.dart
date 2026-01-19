import '../../../domain/entities/resources/resources_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/resources/load_resources.dart';
import '../../cache/cache.dart';
import '../../models/resources/resources_model.dart';

class LocalLoadResources implements LoadResources {
  final CacheStorage cacheStorage;

  LocalLoadResources({required this.cacheStorage});

  @override
  Future<ResourcesEntity> load() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.resources);
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return ResourcesModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.resources);
      ResourcesModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete(SecureStorageKey.resources);
    }
  }

  Future<void> save(ResourcesEntity data) async {
    try {
      final json = ResourcesModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: SecureStorageKey.resources,
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
