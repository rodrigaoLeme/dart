import '../../entities/profile/profile_entity.dart';

abstract class LoadProfile {
  Future<ProfileEntity> load();
}
