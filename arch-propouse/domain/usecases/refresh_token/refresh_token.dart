import '../../entities/account/account_token_entity.dart';

abstract class AddRefreshToken {
  Future<AccountTokenEntity> refresh();
}
