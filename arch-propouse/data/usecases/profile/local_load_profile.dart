import '../../../domain/entities/profile/profile_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/profile/load_profile.dart';
import '../../cache/cache.dart';
import '../../models/profile/profile_model.dart';

class LocalLoadProfile implements LoadProfile {
  final CacheStorage cacheStorage;

  LocalLoadProfile({required this.cacheStorage});

  @override
  Future<ProfileEntity> load() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.profile);
      if (data?.isEmpty != false) {
        throw DomainError.unexpected;
      }
      return ProfileModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch(SecureStorageKey.profile);
      ProfileModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete(SecureStorageKey.profile);
    }
  }

  Future<void> save(ProfileEntity data) async {
    try {
      final json = ProfileModel.fromEntity(data).toJson();
      await cacheStorage.save(
        key: SecureStorageKey.profile,
        value: json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
