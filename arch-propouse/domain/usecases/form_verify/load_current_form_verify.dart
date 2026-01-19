import '../../entities/form_verify/form_verify_entity.dart';

abstract class LoadCurrentFormVerify {
  Future<FormVerifyEntity?> load();
}
