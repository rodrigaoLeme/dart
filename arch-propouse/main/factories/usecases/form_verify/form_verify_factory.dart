import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/form_verify/remote_form_verify.dart';
import '../../../../domain/usecases/form_verify/form_verify.dart';
import '../../http/api_url_factory.dart';

FormVerify makeRemoteFormVerify() => RemoteFormVerify(
      httpClient: Modular.get<AdraHttpClient>(),
      url: makeApiUrl(
        'v1/project/activity/form/verify',
      ),
    );
