import '../../../data/usecases/resources/local_load_resources.dart';
import '../../../data/usecases/resources/remote_load_resources.dart';
import '../../../domain/entities/resources/resources_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/resources/load_resources.dart';

class RemoteLoadResourcesWithLocalFallback implements LoadResources {
  final RemoteLoadResources remote;
  final LocalLoadResources local;

  RemoteLoadResourcesWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<ResourcesEntity> load() async {
    try {
      final result = await remote.load();
      await local.save(result);

      return result;
    } catch (error) {
      if (error == DomainError.accessDenied ||
          error == DomainError.expiredSession) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}
