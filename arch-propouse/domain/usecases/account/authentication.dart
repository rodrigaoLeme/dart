import '../../entities/account/account_token_entity.dart';

abstract class Authentication {
  Future<AccountTokenEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;

  AuthenticationParams({
    required this.email,
  });

  Map toJson() => {
        'email': email,
      };
}
