enum FlavorTypes { dev, prod }

class Flavor {
  Flavor._intance();

  static late FlavorTypes flavorType;

  static String get flavorMessage {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'Dev';
      case FlavorTypes.prod:
        return 'Production';
    }
  }

  /// Se algum dia tiver acesso a API externa
  // static get apiBaseUrl {
  //   switch (flavorType) {
  //     case FlavorTypes.dev:
  //       return 'apiUrlBaseDev';
  //     case FlavorTypes.prod:
  //       return 'apiUrlBaseProd';
  //   }
  // }

  // static bool isProduction() => flavorType == FlavorTypes.prod;
  // static bool isDevelopment() => flavorType == FlavorTypes.dev;
}
