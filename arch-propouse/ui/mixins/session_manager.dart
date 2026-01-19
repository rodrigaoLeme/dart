import 'package:flutter_modular/flutter_modular.dart';

import '../../main/routes/routes_app.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool> stream) {
    stream.listen((isExpired) {
      if (isExpired == true) {
        Modular.to.navigate(Routes.onboarding);
      }
    });
  }
}
