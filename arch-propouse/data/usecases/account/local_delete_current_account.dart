import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/delete_current_account.dart';
import '../../cache/cache.dart';

class LocalDeleteCurrentAccount implements DeleteCurrentAccount {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalDeleteCurrentAccount({required this.sharedPreferencesStorage});

  @override
  Future<void> delete() async {
    try {
      await sharedPreferencesStorage.clean();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
