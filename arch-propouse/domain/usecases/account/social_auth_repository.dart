import '../../entities/account/logged_user.dart';

abstract class SocialAuthRepository {
  Future<LoggedUser?> googleLogin();
  Future<LoggedUser?> microsoftLogin();
  Future<LoggedUser?> appleLogin();
  Future<String?> obterImagemPerfilMicrosoft(String accessToken);
}
