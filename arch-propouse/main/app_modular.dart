import 'package:flutter_modular/flutter_modular.dart';

import 'routes/auth_module.dart';
import 'routes/home_module.dart';
import 'routes/sign_up_module.dart';
import 'routes/splash_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/', module: SplashModule(), transition: TransitionType.fadeIn);
    r.module('/', module: AuthModule(), transition: TransitionType.fadeIn);
    r.module('/', module: SignUpModule(), transition: TransitionType.fadeIn);
    r.module('/', module: HomeModule(), transition: TransitionType.fadeIn);
  }
}
