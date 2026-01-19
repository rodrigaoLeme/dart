import 'package:flutter/foundation.dart';

import '../../mixins/navigation_data.dart';

abstract class SplashPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;

  Future<void> checkAccount({int durationInSeconds});
}
