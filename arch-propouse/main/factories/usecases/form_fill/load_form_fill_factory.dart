import '../../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../http/api_url_factory.dart';
import '../../http/http_client_factory.dart';

RemoteAddFormFill makeRemoteAddFormFill() => RemoteAddFormFill(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl(
        'v1/form/fill/app',
      ),
    );
