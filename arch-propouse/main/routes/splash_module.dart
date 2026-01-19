import 'package:flutter_modular/flutter_modular.dart';

import '../factories/pages/splash/splash_page_factory.dart';
import 'routes_app.dart';

class SplashModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.splash,
      child: (_) => makeSplashPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
