import '../../../../data/usecases/form_fill/local_save_current_form_fill.dart';
import '../../../../domain/usecases/form_fill/save_current_form_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentFormFill makeLocalSaveCurrentFormFill() => LocalSaveCurrentFormFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
