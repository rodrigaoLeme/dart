import '../../../../data/usecases/account/local_save_current_account.dart';
import '../../../../domain/usecases/account/save_current_account.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() => LocalSaveCurrentAccount(
    sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
