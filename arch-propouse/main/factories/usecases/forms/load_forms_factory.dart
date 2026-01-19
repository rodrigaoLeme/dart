import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/forms/local_load_forms.dart';
import '../../../../data/usecases/forms/remote_load_forms.dart';
import '../../../../domain/usecases/forms/load_forms.dart';
import '../../../composites/usecases/remote_load_forms_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadForms makeRemoteLoadForms() => RemoteLoadForms(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl('v1/form/list/app'));

LocalLoadForms makeLocalLoadForms() =>
    LocalLoadForms(cacheStorage: makeLocalStorageAdapter());

LoadForms makeRemoteLoadFormsWithLocalFallback() =>
    RemoteLoadFormsWithLocalFallback(
      local: makeLocalLoadForms(),
      remote: makeRemoteLoadForms(),
    );
