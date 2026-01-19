import '../../../../data/usecases/form_fill/local_delete_current_form_fill.dart';
import '../../../../domain/usecases/form_fill/delete_current_form_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

DeleteCurrentFormFill makeLocalDeleteCurrentFormFill() =>
    LocalDeleteCurrentFormFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
