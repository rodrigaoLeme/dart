import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/account/account_token_entity.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/profile/profile_view_model.dart';
import '../../mixins/mixins.dart';

abstract class ProfilePresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;
  Stream<ProfileViewModel?> get profileViewModel;

  Future<void> loadProfile();
  Future<String> getVersion();
  Future<AccountTokenEntity?> getLoggedUser();
  Future<void> logoff();
}
