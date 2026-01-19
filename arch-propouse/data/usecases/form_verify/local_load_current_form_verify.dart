import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_verify/load_current_form_verify.dart';
import '../../cache/cache.dart';
import '../../models/form_verify/remote_form_verify_model.dart';

class LocalLoadCurrentFormVerify implements LoadCurrentFormVerify {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentFormVerify({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<FormVerifyEntity?> load() async {
    try {
      final data =
          await sharedPreferencesStorage.fetch(SecureStorageKey.formVerify);
      if (data == null) throw Error();
      final model = RemoteFormVerifyModel.fromStringfy(data).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
