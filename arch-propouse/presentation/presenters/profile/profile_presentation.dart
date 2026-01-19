import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/cache/cache_storage.dart';
import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/usecases/account/delete_current_account.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../../domain/usecases/profile/load_profile.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/i18n/resources.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/profile/profile_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import 'profile_view_model.dart';

class ProfilePresentation
    with NavigationManager, LoadingManager
    implements ProfilePresenter {
  final LoadProfile loadUserProfile;
  final LoadCurrentAccount loadCurrentAccount;
  final DeleteCurrentAccount deleteCurrentAccount;
  final CacheStorage cacheStorage;

  ProfilePresentation({
    required this.loadUserProfile,
    required this.loadCurrentAccount,
    required this.deleteCurrentAccount,
    required this.cacheStorage,
  });

  final StreamController<ProfileViewModel?> _profileViewModel =
      StreamController<ProfileViewModel?>.broadcast();

  @override
  Stream<ProfileViewModel?> get profileViewModel => _profileViewModel.stream;

  @override
  Future<void> loadProfile() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final profile = await loadUserProfile.load();
      final version = await getVersion();
      _profileViewModel.add(profile.toViewModel(version));
    } catch (e) {
      _profileViewModel.addError(e);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version.replaceFirst(RegExp(r'[-+].*$'), '');
    final versionNumber = '${R.string.versionLabel} $version';
    return versionNumber;
  }

  @override
  Future<AccountTokenEntity?> getLoggedUser() async {
    try {
      return await loadCurrentAccount.load();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logoff() async {
    try {
      await deleteCurrentAccount.delete();
      await cacheStorage.clear();
      navigateTo = NavigationData(
        route: Routes.login,
        clear: true,
      );
    } catch (e) {
      return;
    }
  }
}
