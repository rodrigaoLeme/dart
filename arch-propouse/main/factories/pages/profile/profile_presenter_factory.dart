import '../../../../presentation/presenters/profile/profile_presentation.dart';
import '../../../../ui/modules/profile/profile_presenter.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../usecases/account/delete_current_account_factory.dart';
import '../../usecases/account/load_current_account_factory.dart';
import '../../usecases/profile/load_profile_factory.dart';

ProfilePresenter makeProfilePresenter() => ProfilePresentation(
      loadUserProfile: makeRemoteLoadProfileWithLocalFallback(),
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
      deleteCurrentAccount: makeLocalDeleteCurrentAccount(),
      cacheStorage: makeLocalStorageAdapter(),
    );
