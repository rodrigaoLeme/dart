import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/answer_form/status_answer_params_entity.dart';
import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/usecases/form_fill/add_form_fill.dart';
import '../../../domain/usecases/form_fill/delete_current_form_fill.dart';
import '../../../domain/usecases/form_fill/load_current_form_fill.dart';
import '../../../domain/usecases/forms_details/delete_current_form_details_fill.dart';
import '../../../domain/usecases/forms_details/load_current_form_details_fill.dart';
import '../../../domain/usecases/forms_details/load_forms_details.dart';
import '../../../domain/usecases/forms_details/save_current_form_details_fill.dart';
import '../../../main/routes/routes_app.dart';
import '../../../share/connection/internet_connection.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';
import '../../../ui/modules/forms_details/forms_details_presenter.dart';
import '../../mixins/navigation_manager.dart';
import '../answer_form/answer_form_view_model.dart';
import '../forms/forms_view_model.dart';
import '../status/status_view_model.dart';
import 'forms_details_state.dart';
import 'forms_details_view_model.dart';

class FormsDetailsPresentation
    with NavigationManager
    implements FormsDetailsPresenter {
  final LoadFormsDetails loadFormsDetails;
  final LoadCurrentFormDetailsFill loadCurrentFormDetailsFill;
  final LoadCurrentFormFill localLoad;
  final AddFormFill addFormFill;
  final DeleteCurrentFormDetailsFill deleteCurrentFormDetailsFill;
  final DeleteCurrentFormFill deleteCurrentFormFill;
  final SaveCurrentFormDetailsFill localSaveCurrentFormFill;

  FormsDetailsPresentation({
    required this.loadFormsDetails,
    required this.loadCurrentFormDetailsFill,
    required this.localLoad,
    required this.addFormFill,
    required this.deleteCurrentFormDetailsFill,
    required this.deleteCurrentFormFill,
    required this.localSaveCurrentFormFill,
  }) {
    convinienceInit();
  }

  FormsViewModel? formsViewModelParams;
  void convinienceInit() {
    formsViewModelParams = Modular.args.data as FormsViewModel;
  }

  final StreamController<FormsDetailsViewModel?> _formsDetailsViewModel =
      StreamController<FormsDetailsViewModel?>.broadcast();

  @override
  Stream<FormsDetailsViewModel?> get formsDetailsViewModel =>
      _formsDetailsViewModel.stream;

  final StreamController<FormsViewModel?> _formsViewModel =
      StreamController<FormsViewModel?>.broadcast();

  final StreamController<FormsDetailsState> _stateController =
      StreamController<FormsDetailsState>.broadcast();

  @override
  Stream<FormsViewModel?> get formsViewModel => _formsViewModel.stream;

  @override
  Stream<FormsDetailsState> get state => _stateController.stream;

  StatusPageParams statusPageParams = StatusPageParams(
    errorEntity: null,
    status: StatusCardState.pending,
    viewModel: null,
  );
  @override
  Future<void> loadData() async {
    try {
      _stateController.add(const FormsDetailsLoading());
      final formsDetails =
          await loadFormsDetails.load(formsViewModelParams?.identifierForm);
      final currentFormDetails = await loadCurrentFormDetailsFill
          .load(formsDetails.data?.identifier ?? '');
      final viewModel = formsDetails.toViewModel();
      viewModel.data?.localForms =
          currentFormDetails?.toViewModel().data?.localForms ?? [];
      _formsDetailsViewModel.add(viewModel);
      _formsViewModel.add(formsViewModelParams);
      _stateController.add(
          FormsDetailsData(details: viewModel, forms: formsViewModelParams));
    } catch (e) {
      _formsDetailsViewModel.addError(e);
      _stateController.add(FormsDetailsError(e));
    }
  }

  @override
  void dispose() {
    _formsDetailsViewModel.close();
    _formsViewModel.close();
    _stateController.close();
  }

  @override
  goToFormsSesion({
    required FormsDetailsViewModel? viewModel,
    SessionViewModel? sessionViewModel,
    LatestFormSendedViewModel? latestFormSendedViewModel,
  }) {
    final paramsViewModel = viewModel?.copyWith(
      sessionToEdit: sessionViewModel,
      answerFlow: AnswerFlow.main,
      currentUUID: latestFormSendedViewModel?.id,
    );
    navigateTo = NavigationData(
      route: Routes.answerForm,
      clear: false,
      arguments: paramsViewModel,
    );
  }

  @override
  Future<bool> save(
    LatestFormSendedViewModel? latestFormSendedViewModel,
    FormsDetailsViewModel? viewModel,
  ) async {
    try {
      _stateController.add(const FormsDetailsLoading());
      final hasInternet =
          await ConnectivityService.instance.hasInternetAccess();
      if (!hasInternet) {
        statusPageParams = StatusPageParams(
          errorEntity: null,
          status: StatusCardState.pending,
          viewModel: viewModel,
        );
        return false;
      }

      final currentUUID = latestFormSendedViewModel?.id;
      final identifierForm = viewModel?.data?.identifierForm ?? '';
      final localAnswer =
          await localLoad.load(key: latestFormSendedViewModel?.id ?? '');
      if (localAnswer != null) {
        FormsDetailsEntity? localFormAnswer =
            await loadCurrentFormDetailsFill.load(identifierForm);
        final errorEntity = await addFormFill.add(localAnswer);
        if (errorEntity?.errors?.isEmpty == true) {
          localFormAnswer?.data?.localForms
              ?.removeWhere((element) => element.id == currentUUID);
          final stringData =
              jsonEncode(localFormAnswer?.toViewModel().toJson());
          await localSaveCurrentFormFill.save(
            stringData,
            identifierForm,
          );
          deleteCurrentFormFill.delete(key: currentUUID ?? '');
          statusPageParams = StatusPageParams(
            errorEntity: errorEntity,
            status: StatusCardState.success,
            viewModel: viewModel,
          );
          return true;
        } else {
          LatestFormSendedEntity? errorItem = localFormAnswer?.data?.localForms
              ?.firstWhereOrNull((element) => element.id == currentUUID);

          final index = localFormAnswer?.data?.localForms
              ?.indexWhere((element) => element.id == currentUUID);
          localFormAnswer?.data?.localForms
              ?.removeWhere((element) => element.id == currentUUID);
          errorItem = errorItem?.copyWith(genericErrorEntity: errorEntity);
          if (index != null && errorItem != null) {
            localFormAnswer?.data?.localForms?.insert(index, errorItem);
          }
          final stringData =
              jsonEncode(localFormAnswer?.toViewModel().toJson());
          await localSaveCurrentFormFill.save(
            stringData,
            identifierForm,
          );
          statusPageParams = StatusPageParams(
            errorEntity: errorEntity,
            status: StatusCardState.error,
            viewModel: viewModel,
          );
          return false;
        }
      }
      statusPageParams = StatusPageParams(
        errorEntity: null,
        status: StatusCardState.error,
        viewModel: viewModel,
      );
      return false;
    } catch (error) {
      statusPageParams = StatusPageParams(
        errorEntity: null,
        status: StatusCardState.error,
        viewModel: viewModel,
      );
      return false;
    }
  }

  @override
  Future<void> delete({
    required FormsDetailsViewModel? viewModel,
    LatestFormSendedViewModel? latestFormSendedViewModel,
  }) async {
    try {
      final currentUUID = latestFormSendedViewModel?.id;
      final identifierForm = viewModel?.data?.identifierForm ?? '';
      final localFormAnswer =
          await loadCurrentFormDetailsFill.load(identifierForm);
      localFormAnswer?.data?.localForms
          ?.removeWhere((element) => element.id == currentUUID);
      final stringData = jsonEncode(localFormAnswer?.toViewModel().toJson());
      await localSaveCurrentFormFill.save(
        stringData,
        identifierForm,
      );
      deleteCurrentFormFill.delete(key: currentUUID ?? '');
      loadData();
    } catch (_) {}
  }

  @override
  goToStatusPage() {
    FormsDetailsViewModel? viewModel = statusPageParams.viewModel;
    viewModel = viewModel?.copyWith(
      statusCardViewModel: StatusCardViewModel(
        state: statusPageParams.status,
        error: statusPageParams.errorEntity,
      ),
    );
    navigateTo = NavigationData(
      route: Routes.status,
      clear: statusPageParams.status != StatusCardState.error,
      arguments: viewModel,
    );
  }

  @override
  Future<List<SessionViewModel>> getSessions(
      LatestFormSendedViewModel? viewModel,
      List<SessionViewModel> currentSessions) async {
    try {
      final localAnswer = await localLoad.load(key: viewModel?.id ?? '');
      return currentSessions.where((element) {
        final sessionFill = localAnswer?.mainForm?.sessions
            ?.firstWhereOrNull((s) => s?.sessionId == element.id);

        if (sessionFill == null) {
          return element.visible != false;
        }

        if (sessionFill.isVisibleByAnswer == false) return false;
        final hasHide = sessionFill.tapsInItemsToHideSession?.values
                .any((list) => (list as List).isNotEmpty) ??
            false;
        final hasShow = sessionFill.tapsInItemsToShowSession?.values
                .any((list) => (list as List).isNotEmpty) ??
            false;
        final defaultVisible = sessionFill.defaultVisible == true;

        final finalVisible =
            hasHide ? false : (hasShow ? true : defaultVisible);
        return finalVisible;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
