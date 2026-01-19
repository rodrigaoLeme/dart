import '../../../../data/usecases/terms/local_load_current_account_terms.dart';
import '../../../../domain/usecases/terms/load_current_account_terms.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentAccountTerms makeLocalLoadCurrentAccountTerms() =>
    LocalLoadCurrentAccountTerms(
        sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
