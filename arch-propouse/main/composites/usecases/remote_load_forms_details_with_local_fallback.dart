import '../../../data/usecases/forms_details/local_load_forms_details.dart';
import '../../../data/usecases/forms_details/remote_load_forms_details.dart';
import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/load_forms_details.dart';

class RemoteLoadFormsDetailsWithLocalFallback implements LoadFormsDetails {
  final RemoteLoadFormsDetails remote;
  final LocalLoadFormsDetails local;

  RemoteLoadFormsDetailsWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<FormsDetailsEntity> load(String? key) async {
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
