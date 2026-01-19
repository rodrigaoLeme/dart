import '../../../../data/usecases/refresh_token/remote_add_refresh_token.dart';
import '../../../../domain/usecases/refresh_token/refresh_token.dart';
import '../../http/api_url_factory.dart';
import '../../http/http_client_factory.dart';
import '../account/load_current_account_factory.dart';
import '../account/save_current_account_factory.dart';

AddRefreshToken makeRemoteAddRefreshToken() {
  return RemoteAddRefreshToken(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('v1/usuario/refresh'),
    loadCurrentAccount: makeLocalLoadCurrentAccount(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
