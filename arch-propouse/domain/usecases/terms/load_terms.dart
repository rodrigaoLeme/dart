import '../../entities/terms/terms_entity.dart';

abstract class LoadTerms {
  Future<TermsEntity> load();
}
