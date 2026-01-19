import '../../entities/terms/account_terms_entity.dart';

abstract class LoadAccountTerms {
  Future<AccountTermsEntity> load();
}
