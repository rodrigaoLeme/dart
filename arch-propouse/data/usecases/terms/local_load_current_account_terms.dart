import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/terms/load_current_account_terms.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentAccountTerms implements LoadCurrentAccountTerms {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentAccountTerms({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<String?> load() async {
    try {
      return await sharedPreferencesStorage.fetch(SecureStorageKey.terms);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
