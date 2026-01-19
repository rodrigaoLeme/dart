import '../../../../data/usecases/forms_details/local_load_current_form_details_fill.dart';
import '../../../../domain/usecases/forms_details/load_current_form_details_fill.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentFormDetailsFill makeLoadCurrentFormDetailsFill() =>
    LocalLoadCurrentFormDetailsFill(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
