import '../../entities/auth/auth.dart';

/// Login com Apple
abstract class SignInApple {
  Future<UserEntity> call();
}
