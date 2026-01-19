import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/terms/local_load_terms.dart';
import '../../../../data/usecases/terms/remote_load_terms.dart';
import '../../../../domain/usecases/terms/load_terms.dart';
import '../../../composites/usecases/remote_load_terms_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadTerms makeRemoteLoadTerms() => RemoteLoadTerms(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl('v1/documents/policy-term'));

LocalLoadTerms makeLocalLoadTerms() =>
    LocalLoadTerms(cacheStorage: makeLocalStorageAdapter());

LoadTerms makeRemoteLoadTermsWithLocalFallback() =>
    RemoteLoadTermsWithLocalFallback(
      local: makeLocalLoadTerms(),
      remote: makeRemoteLoadTerms(),
    );
