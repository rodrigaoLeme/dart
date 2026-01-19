import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';

abstract class CpfLoginPresenter {
  Stream<LoadingData?> get isLoadingStream;
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<String?> get mainErrorStream;

  Future<void> socialAuth({required document, required birthday});

  goToTerms();
}
