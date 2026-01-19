import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/providers/provider_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/usecases/account/social_auth_repository.dart';
import '../factories/pages/login/splash.dart';
import 'core_module.dart';
import 'routes_app.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<ProviderService>(
      () => ProviderService(),
    );
    i.addSingleton<AuthDatasource>(
      () => FirebaseDatasource(
        provider: i(),
        firebaseAuth: i(),
        clientHttp: i(),
      ),
    );
    i.addSingleton<SocialAuthRepository>(
      () => FirebaseAuthRepository(
        datasource: i(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      Routes.login,
      child: (_) => makeLoginPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
