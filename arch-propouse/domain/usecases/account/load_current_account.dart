import '../../entities/account/account_token_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountTokenEntity?> load();
}
