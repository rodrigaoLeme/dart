import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/save_current_form_details_fill.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentFormDetailsFill implements SaveCurrentFormDetailsFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentFormDetailsFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String form, String key) async {
    try {
      await sharedPreferencesStorage.save(
        key: '${SecureStorageKey.formDetailsFill}/$key',
        value: form,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
