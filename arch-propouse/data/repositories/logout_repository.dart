import '../../domain/usecases/account/social_logout_repository.dart';
import '../datasources/auth_datasource.dart';

class LogoutRepositoryImpl implements SocialLogoutRepository {
  final AuthDatasource datasource;

  const LogoutRepositoryImpl({required this.datasource});

  @override
  Future<int> logout() async {
    try {
      return await datasource.logout();
    } catch (exception) {
      rethrow;
    }
  }
}
