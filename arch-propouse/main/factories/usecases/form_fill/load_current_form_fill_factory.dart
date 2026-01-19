import '../../../../data/usecases/form_fill/local_load_current_form_fill.dart';
import '../../../../domain/usecases/form_fill/load_current_form_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentFormFill makeLocalLoadCurrentFormFill() => LocalLoadCurrentFormFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
