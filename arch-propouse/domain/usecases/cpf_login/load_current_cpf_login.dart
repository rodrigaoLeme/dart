import '../../entities/cpf_login/cpf_login_entity.dart';

abstract class LoadCurrentCpfLogin {
  Future<CpfLoginEntity?> load();
}
