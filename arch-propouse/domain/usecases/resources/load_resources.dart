import '../../entities/resources/resources_entity.dart';

abstract class LoadResources {
  Future<ResourcesEntity> load();
}
