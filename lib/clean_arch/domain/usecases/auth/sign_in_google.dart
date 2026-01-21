import '../../entities/auth/auth.dart';

/// Login com Google
abstract class SignInGoogle {
  Future<UserEntity> call();
}
