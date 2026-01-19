import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_fill/save_current_form_fill.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentFormFill implements SaveCurrentFormFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentFormFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save({required String form, required String key}) async {
    try {
      await sharedPreferencesStorage.save(
        key: '${SecureStorageKey.formFill}$key',
        value: form,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
