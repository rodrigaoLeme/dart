import '../../entities/auth/auth.dart';

/// Provedor para vinculação de conta no futuro
enum LinkProvider {
  google,
  apple,
}

abstract class LinkAccount {
  Future<UserEntity> call(LinkProvider provider);
}
