import '../../../../data/usecases/cpf_login/remote_cpf_authentication.dart';
import '../../../../domain/usecases/cpf_login/cpf_authentication.dart';
import '../../http/api_url_factory.dart';
import '../../http/http_client_factory.dart';

CpfAuthentication makeRemoteCpfAuthentication() => RemoteCpfAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl(
        'v1/usuario/bind',
      ),
    );
