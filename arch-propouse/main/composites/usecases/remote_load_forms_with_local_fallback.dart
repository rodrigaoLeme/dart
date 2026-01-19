import '../../../data/usecases/forms/local_load_forms.dart';
import '../../../data/usecases/forms/remote_load_forms.dart';
import '../../../domain/entities/forms/forms_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms/load_forms.dart';

class RemoteLoadFormsWithLocalFallback implements LoadForms {
  final RemoteLoadForms remote;
  final LocalLoadForms local;

  RemoteLoadFormsWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<FormEntity> load() async {
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
