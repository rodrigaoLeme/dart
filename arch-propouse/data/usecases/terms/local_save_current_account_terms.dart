import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/save_current_account_terms.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccountTerms implements SaveCurrentAccountTerms {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentAccountTerms({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String status) async {
    try {
      await sharedPreferencesStorage.save(
          key: SecureStorageKey.terms, value: status);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
