import 'dart:async';

import 'package:flutter/material.dart';

import '../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../presentation/presenters/forms/forms_view_model.dart';
import '../../../presentation/presenters/forms_details/forms_details_state.dart';
import '../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../mixins/mixins.dart';

abstract class FormsDetailsPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<FormsDetailsViewModel?> get formsDetailsViewModel;
  Stream<FormsViewModel?> get formsViewModel;
  Stream<FormsDetailsState> get state;

  Future<void> loadData();
  goToFormsSesion({
    required FormsDetailsViewModel? viewModel,
    SessionViewModel? sessionViewModel,
    LatestFormSendedViewModel? latestFormSendedViewModel,
  });
  Future<bool> save(LatestFormSendedViewModel? latestFormSendedViewModel,
      FormsDetailsViewModel? viewModel);
  Future<void> delete({
    required FormsDetailsViewModel? viewModel,
    LatestFormSendedViewModel? latestFormSendedViewModel,
  });
  Future<List<SessionViewModel>> getSessions(
      LatestFormSendedViewModel? viewModel,
      List<SessionViewModel> currentSessions);
  goToStatusPage();
  void dispose();
}
