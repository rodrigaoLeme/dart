import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/terms/terms_view_model.dart';
import '../../mixins/mixins.dart';

abstract class TermsAcceptedPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;
  Stream<String?> get mainErrorStream;
  Stream<TermsViewModel?> get termsViewModel;

  Future<void> fetchTerms();
  Future<void> acceptTerms();
}
