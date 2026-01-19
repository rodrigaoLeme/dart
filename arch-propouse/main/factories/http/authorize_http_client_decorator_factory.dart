import '../../../data/http/http.dart';
import '../../decorators/authorize_http_client_decorator.dart';
import '../cache/shared_preferences_storage_adapter_factory.dart';
import '../usecases/account/load_current_account_factory.dart';
import '../usecases/refresh_token/add_refresh_token_factory.dart';
import 'http_client_factory.dart';

AdraHttpClient makeAuthorizeHttpClientDecorator() =>
    AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
      addRefreshToken: makeRemoteAddRefreshToken(),
    );
