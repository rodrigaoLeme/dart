import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/http/http_client.dart';
import '../../../../data/usecases/answer_form/local_load_answer_form.dart';
import '../../../../data/usecases/answer_form/remote_load_answer_form.dart';
import '../../../../domain/usecases/answer_form/load_answer_form.dart';
import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../composites/usecases/remote_load_answer_form_with_local_fallback.dart';
import '../../cache/local_storage_adapter_factory.dart';
import '../../http/api_url_factory.dart';

RemoteLoadAnswerForm makeRemoteLoadAnswerForm() {
  final viewModel = Modular.args.data as FormsDetailsViewModel;
  return RemoteLoadAnswerForm(
    httpClient: Modular.get<AdraHttpClient>(),
    url: makeApiUrl(
      'v1/project/execute/${viewModel.data?.groupId}/form/group',
    ),
  );
}

LocalLoadAnswerForm makeLocalLoadAnswerForm() =>
    LocalLoadAnswerForm(cacheStorage: makeLocalStorageAdapter());

LoadAnswerForm makeRemoteLoadAnswerFormWithLocalFallback() =>
    RemoteLoadAnswerFormWithLocalFallback(
      local: makeLocalLoadAnswerForm(),
      remote: makeRemoteLoadAnswerForm(),
    );
