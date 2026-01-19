import '../../../../data/usecases/terms/local_save_current_account_terms.dart';
import '../../../../domain/usecases/terms/save_current_account_terms.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentAccountTerms makeLocalSaveCurrentAccountTerms() =>
    LocalSaveCurrentAccountTerms(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
