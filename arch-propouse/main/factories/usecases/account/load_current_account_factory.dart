import '../../../../data/usecases/account/local_load_current_account.dart';
import '../../../../domain/usecases/account/load_current_account.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() => LocalLoadCurrentAccount(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
