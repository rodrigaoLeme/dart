import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../main/routes/routes_app.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/status/status_presenter.dart';
import '../../mixins/mixins.dart';
import '../forms_details/forms_details_view_model.dart';
import 'status_view_model.dart';

class StatusPresentation
    with NavigationManager, LoadingManager
    implements StatusPresenter {
  final StreamController<StatusCardViewModel?> _statusViewModel =
      StreamController<StatusCardViewModel?>.broadcast();

  @override
  Stream<StatusCardViewModel?> get statusViewModel => _statusViewModel.stream;

  @override
  void goToForms() {
    navigateTo = NavigationData(route: Routes.forms, clear: true);
  }

  @override
  Future<void> loadStatus() async {
    try {
      final viewModel = Modular.args.data as FormsDetailsViewModel;
      await Future.delayed(const Duration(milliseconds: 200));
      _statusViewModel.add(viewModel.statusCardViewModel);
    } catch (_) {}
  }

  @override
  void goToFormsSesion() {
    FormsDetailsViewModel viewModel =
        Modular.args.data as FormsDetailsViewModel;
    viewModel = viewModel.copyWith(
      sessionToEdit: null,
      currentUUID: null,
    );
    viewModel.currentUUID = null;
    navigateTo = NavigationData(
      route: Routes.answerForm,
      clear: true,
      arguments: viewModel,
    );
  }
}
