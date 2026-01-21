import '../../entities/auth/auth.dart';

/// Login Anônimo
abstract class SignInAnonymous {
  Future<UserEntity> call();
}
