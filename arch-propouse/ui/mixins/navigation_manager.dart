import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'navigation_data.dart';

ValueNotifier<NavigationData?>? currentNavigationStream;
mixin NavigationManager {
  void handleNavigation(ValueNotifier<NavigationData?> stream) {
    if (currentNavigationStream.hashCode != stream.hashCode) {
      currentNavigationStream?.removeListener(() {});
      currentNavigationStream = stream;
      stream.addListener(() {
        final data = stream.value;

        if (data != null && data.route.isNotEmpty) {
          if (data.clear == true) {
            Modular.to.navigate(data.route, arguments: data.arguments);
          } else {
            Modular.to.pushNamed(data.route, arguments: data.arguments);
          }
        }
      });
    }
  }

  void removeNavigationListener() {
    currentNavigationStream?.removeListener(() {});
  }
}
