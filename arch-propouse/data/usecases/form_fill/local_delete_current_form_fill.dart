import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_fill/delete_current_form_fill.dart';
import '../../cache/cache.dart';

class LocalDeleteCurrentFormFill implements DeleteCurrentFormFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalDeleteCurrentFormFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> delete({required String key}) async {
    try {
      await sharedPreferencesStorage.remove('${SecureStorageKey.formFill}$key');
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
