import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/status/status_view_model.dart';
import '../../mixins/mixins.dart';

abstract class StatusPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;
  Stream<StatusCardViewModel?> get statusViewModel;

  goToForms();
  Future<void> loadStatus();
  goToFormsSesion();
}
