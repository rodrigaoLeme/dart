import '../../../../data/usecases/account/local_delete_current_account.dart';
import '../../../../domain/usecases/account/delete_current_account.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

DeleteCurrentAccount makeLocalDeleteCurrentAccount() =>
    LocalDeleteCurrentAccount(
        sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
