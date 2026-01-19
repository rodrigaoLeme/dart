import '../../../../data/usecases/terms/remote_add_account_terms.dart';
import '../../../../domain/usecases/terms/add_account_terms.dart';
import '../../http/api_url_factory.dart';
import '../../http/authorize_http_client_decorator_factory.dart';

AddAccountTerms makeRemoteAddAccountTerms() => RemoteAddAccountTerms(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('Terms/v1/accept'));
