import '../../entities/auth/auth.dart';

/// Obter usuário atual
abstract class GetCurrentUser {
  Future<UserEntity?> call();
}
