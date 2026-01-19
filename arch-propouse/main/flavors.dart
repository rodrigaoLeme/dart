enum FlavorTypes { dev, prod, sandbox, staging }

class Flavor {
  Flavor._instance();

  static late FlavorTypes flavorType;

  static String get flavorMessage {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'Dev';
      case FlavorTypes.prod:
        return 'Production';
      case FlavorTypes.staging:
        return 'Staging';
      case FlavorTypes.sandbox:
        return 'Sandbox';
    }
  }

  static String get apiBaseUrl {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'https://xxx-dev.sdasystems.org/api/';
      case FlavorTypes.prod:
        return 'https://api-xxx.sdasystems.org/api/';
      case FlavorTypes.staging:
        return 'https://api-xxx-staging.sdasystems.org/api/';
      case FlavorTypes.sandbox:
        return 'https://api-xxx-sandbox.sdasystems.org/api/';
    }
  }
}
