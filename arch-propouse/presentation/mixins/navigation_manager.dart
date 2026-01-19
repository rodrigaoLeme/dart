import 'package:flutter/foundation.dart';

import '../../ui/mixins/navigation_data.dart';

mixin NavigationManager {
  final ValueNotifier<NavigationData?> _navigateToController =
      ValueNotifier<NavigationData?>(null);

  set navigateTo(NavigationData value) => _navigateToController.value = value;
  ValueNotifier<NavigationData?> get navigateToListener =>
      _navigateToController;
}
