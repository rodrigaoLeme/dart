import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../mixins/mixins.dart';

abstract class TermsUsePresenter {
  Stream<bool> get isFormValidStream;
  ValueNotifier<NavigationData?> get navigateToListener;
}
