import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/profile/local_load_profile.dart';
import '../../../../data/usecases/profile/remote_load_profile.dart';
import '../../../../domain/usecases/profile/load_profile.dart';
import '../../../composites/usecases/remote_load_profile_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadProfile makeRemoteLoadProfile() => RemoteLoadProfile(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl('v1/usuario/access'));

LocalLoadProfile makeLocalLoadProfile() =>
    LocalLoadProfile(cacheStorage: makeLocalStorageAdapter());

LoadProfile makeRemoteLoadProfileWithLocalFallback() =>
    RemoteLoadProfileWithLocalFallback(
      local: makeLocalLoadProfile(),
      remote: makeRemoteLoadProfile(),
    );
