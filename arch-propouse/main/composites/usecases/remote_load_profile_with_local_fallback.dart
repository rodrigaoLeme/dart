import '../../../data/usecases/profile/local_load_profile.dart';
import '../../../data/usecases/profile/remote_load_profile.dart';
import '../../../domain/entities/profile/profile_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/profile/load_profile.dart';

class RemoteLoadProfileWithLocalFallback implements LoadProfile {
  final RemoteLoadProfile remote;
  final LocalLoadProfile local;

  RemoteLoadProfileWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<ProfileEntity> load() async {
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
