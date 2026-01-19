import 'package:flutter_modular/flutter_modular.dart';

import '../../data/http/http_client.dart';
import '../factories/http/http.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AdraHttpClient>(makeAuthorizeHttpClientDecorator);
  }

  @override
  void routes(r) {}
}
