import '../../../domain/entities/account/logged_user.dart';
import '../../../domain/usecases/account/social_auth_repository.dart';
import '../../../domain/usecases/account/social_authentication.dart';

class RemoteSocialAuthentication implements SocialAuthentication {
  final SocialAuthRepository repository;

  RemoteSocialAuthentication({
    required this.repository,
  });

  @override
  Future<LoggedUser?> auth({
    required ProviderLogin provider,
  }) async {
    switch (provider) {
      case ProviderLogin.google:
        return await repository.googleLogin();
      case ProviderLogin.microsoft:
        return await repository.microsoftLogin();
      case ProviderLogin.apple:
        return await repository.appleLogin();
    }
  }
}
