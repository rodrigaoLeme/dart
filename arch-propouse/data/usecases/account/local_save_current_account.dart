import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentAccount({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save(String account) async {
    try {
      await sharedPreferencesStorage.save(
          key: SecureStorageKey.account, value: account);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
