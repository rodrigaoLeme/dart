import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/forms_details/local_load_forms_details.dart';
import '../../../../data/usecases/forms_details/remote_load_forms_details.dart';
import '../../../../domain/usecases/forms_details/load_forms_details.dart';
import '../../../../presentation/presenters/forms/forms_view_model.dart';
import '../../../composites/usecases/remote_load_forms_details_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadFormsDetails makeRemoteLoadFormsDetails() {
  final viewModel = Modular.args.data as FormsViewModel;
  return RemoteLoadFormsDetails(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl('v1/form/details/app/${viewModel.groupId}'),
  );
}

LocalLoadFormsDetails makeLocalLoadFormsDetails() =>
    LocalLoadFormsDetails(cacheStorage: makeLocalStorageAdapter());

LoadFormsDetails makeRemoteLoadFormsDetailsWithLocalFallback() =>
    RemoteLoadFormsDetailsWithLocalFallback(
      local: makeLocalLoadFormsDetails(),
      remote: makeRemoteLoadFormsDetails(),
    );
