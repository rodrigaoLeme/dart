import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/delete_current_account_terms.dart';
import '../../cache/cache.dart';

class LocalDeleteCurrentAccountTerms implements DeleteCurrentAccountTerms {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalDeleteCurrentAccountTerms({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> delete() async {
    try {
      await sharedPreferencesStorage.remove(SecureStorageKey.terms);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
