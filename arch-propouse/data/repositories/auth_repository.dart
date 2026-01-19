import '../../domain/entities/account/logged_user.dart';
import '../../domain/usecases/account/social_auth_repository.dart';
import '../datasources/auth_datasource.dart';

class FirebaseAuthRepository implements SocialAuthRepository {
  final AuthDatasource datasource;

  const FirebaseAuthRepository({
    required this.datasource,
  });

  @override
  Future<LoggedUser?> microsoftLogin() {
    return datasource.loginWithMicrosoft();
  }

  @override
  Future<LoggedUser?> googleLogin() {
    return datasource.loginWithGoogle();
  }

  @override
  Future<LoggedUser?> appleLogin() {
    return datasource.loginWithApple();
  }

  @override
  Future<String?> obterImagemPerfilMicrosoft(String accessToken) async {
    try {
      final path = await datasource.obterImagemPerfilMicrosoft(accessToken);
      return path;
    } catch (ex) {
      rethrow;
    }
  }
}
