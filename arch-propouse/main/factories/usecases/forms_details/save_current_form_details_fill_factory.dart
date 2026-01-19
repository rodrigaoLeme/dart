import '../../../../data/usecases/forms_details/local_save_current_form_details_fill.dart';
import '../../../../domain/usecases/forms_details/save_current_form_details_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentFormDetailsFill makeSaveCurrentFormDetailsFill() =>
    LocalSaveCurrentFormDetailsFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
