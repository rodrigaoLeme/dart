import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../flavors.dart';

/// Configuração do Firebase integrado com o sistema de Flavors
class FirebaseConfig {
  static Future<void> initialize() async {
    if (kDebugMode) {
      print('🔥 Inicializando Firebase: ${Flavor.flavorMessage}');
    }

    await Firebase.initializeApp();

    await GoogleSignIn.instance.initialize();

    if (kDebugMode) {
      print('✅ Firebase inicializado: ${_getProjectName()}');
    }
  }

  /// Função para retornar o nome do projeto atual
  static String _getProjectName() {
    switch (Flavor.flavorType) {
      case FlavorTypes.dev:
        return 'Bible Plan Dev';
      case FlavorTypes.prod:
        return 'Bible Plan Prod';
    }
  }

  static bool get isDev => Flavor.flavorType == FlavorTypes.dev;

  static bool get isProd => Flavor.flavorType == FlavorTypes.prod;

  /// Retorna uma descrição amigável do ambiente
  static String get enviromentDescription {
    switch (Flavor.flavorType) {
      case FlavorTypes.dev:
        return '🔧 Desenvolvimento';
      case FlavorTypes.prod:
        return '🚀 Produção';
    }
  }
}
