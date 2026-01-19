import 'package:flutter/material.dart';

import '../../../domain/entities/account/logged_user.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/navigation_data.dart';

abstract class LoginPresenter {
  Stream<LoadingData?> get isLoadingStream;
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<String?> get mainErrorStream;

  Future<void> socialAuth(ProviderLogin providerLogin);
}
