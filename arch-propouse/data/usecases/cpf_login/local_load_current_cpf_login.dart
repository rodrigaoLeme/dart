import '../../../domain/entities/cpf_login/cpf_login_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/cpf_login/load_current_cpf_login.dart';
import '../../cache/cache.dart';
import '../../models/cpf_login/remote_cpf_login_model.dart';

class LocalLoadCurrentCpfLogin implements LoadCurrentCpfLogin {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentCpfLogin({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<CpfLoginEntity?> load() async {
    try {
      final data =
          await sharedPreferencesStorage.fetch(SecureStorageKey.account);
      if (data == null) throw Error();
      final model = RemoteCpfLoginModel.fromStringfy(data).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
