import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../cache/cache.dart';
import '../../models/account/remote_account_token_model.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentAccount({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<AccountTokenEntity?> load() async {
    try {
      final data =
          await sharedPreferencesStorage.fetch(SecureStorageKey.account);
      if (data == null) throw Error();
      final model = RemoteAccountTokenModel.fromStringfy(data).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
