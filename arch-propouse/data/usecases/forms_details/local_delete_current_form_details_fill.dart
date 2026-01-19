import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/delete_current_form_details_fill.dart';
import '../../cache/cache.dart';

class LocalDeleteCurrentFormDetailsFill
    implements DeleteCurrentFormDetailsFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalDeleteCurrentFormDetailsFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> delete(String key) async {
    try {
      await sharedPreferencesStorage
          .remove('${SecureStorageKey.formDetailsFill}/$key');
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
