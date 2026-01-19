import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http.dart';
import '../../../../data/usecases/resources/local_load_resources.dart';
import '../../../../data/usecases/resources/remote_load_resources.dart';
import '../../../../domain/usecases/resources/load_resources.dart';
import '../../../composites/usecases/remote_load_resources_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadResources makeRemoteLoadResources() => RemoteLoadResources(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl('v1/usuario/profile/resources?scope=Project'));

LocalLoadResources makeLocalLoadResources() =>
    LocalLoadResources(cacheStorage: makeLocalStorageAdapter());

LoadResources makeRemoteLoadAttendeestWithLocalFallback() =>
    RemoteLoadResourcesWithLocalFallback(
      remote: makeRemoteLoadResources(),
      local: makeLocalLoadResources(),
    );
