import '../../../../data/usecases/forms_details/local_delete_current_form_details_fill.dart';
import '../../../../domain/usecases/forms_details/delete_current_form_details_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

DeleteCurrentFormDetailsFill makeDeleteCurrentFormDetailsFill() =>
    LocalDeleteCurrentFormDetailsFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
