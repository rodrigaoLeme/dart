import '../../../../data/usecases/account/remote_authentication.dart';
import '../../../../domain/usecases/account/authentication.dart';
import '../../http/api_url_factory.dart';
import '../../http/http_client_factory.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl(
        'v1/usuario/login',
      ),
    );
