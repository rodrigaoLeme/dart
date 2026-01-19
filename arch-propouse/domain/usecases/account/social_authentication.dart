import '../../entities/account/logged_user.dart';

abstract class SocialAuthentication {
  Future<LoggedUser?> auth({
    required ProviderLogin provider,
  });
}
