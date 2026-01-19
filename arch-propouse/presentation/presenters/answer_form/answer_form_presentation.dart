import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../domain/entities/answer_form/status_answer_params_entity.dart';
import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/entities/share/generic_error_entity.dart';
import '../../../domain/usecases/answer_form/load_answer_form.dart';
import '../../../domain/usecases/form_fill/add_form_fill.dart';
import '../../../domain/usecases/form_fill/delete_current_form_fill.dart';
import '../../../domain/usecases/form_fill/load_current_form_fill.dart';
import '../../../domain/usecases/form_fill/save_current_answer_form.dart';
import '../../../domain/usecases/form_fill/save_current_form_fill.dart';
import '../../../domain/usecases/form_verify/form_verify.dart';
import '../../../domain/usecases/forms_details/delete_current_form_details_fill.dart';
import '../../../domain/usecases/forms_details/load_current_form_details_fill.dart';
import '../../../domain/usecases/forms_details/save_current_form_details_fill.dart';
import '../../../main/routes/routes_app.dart';
import '../../../share/connection/internet_connection.dart';
import '../../../ui/helpers/extensions/array_extension.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import '../forms_details/forms_details_view_model.dart';
import '../status/status_view_model.dart';
import 'answer_form_state.dart';
import 'answer_form_view_model.dart';

class AnswerFormPresentation
    with NavigationManager, UIErrorManager
    implements AnswerFormPresenter {
  final LoadAnswerForm loadAnswerForm;
  final SaveCurrentAnswerForm saveCurrentAnswerForm;
  final LoadCurrentFormFill localLoad;
  final AddFormFill addFormFill;
  final LoadCurrentFormDetailsFill loadCurrentFormDetailsFill;
  final SaveCurrentFormDetailsFill localSaveCurrentFormFill;
  final DeleteCurrentFormDetailsFill deleteCurrentFormDetailsFill;
  final DeleteCurrentFormFill deleteCurrentFormFill;
  final SaveCurrentFormFill localSave;
  final FormVerify formVerify;
  FormsDetailsViewModel currentFormsDetailsViewModel;

  AnswerFormPresentation({
    required this.loadAnswerForm,
    required this.saveCurrentAnswerForm,
    required this.localLoad,
    required this.addFormFill,
    required this.loadCurrentFormDetailsFill,
    required this.localSaveCurrentFormFill,
    required this.deleteCurrentFormDetailsFill,
    required this.deleteCurrentFormFill,
    required this.localSave,
    required this.formVerify,
    required this.currentFormsDetailsViewModel,
  }) {
    convinienceInit();
  }

  final StreamController<AnswerFormViewModel> _answerViewModel =
      StreamController<AnswerFormViewModel>.broadcast();

  final StreamController<AnswerFormState> _stateController =
      StreamController<AnswerFormState>.broadcast();

  @override
  Stream<AnswerFormViewModel?> get answerViewModel => _answerViewModel.stream;

  @override
  Stream<AnswerFormState> get state => _stateController.stream;

  final ValueNotifier<FormVerifyEntity?> _existingRegister =
      ValueNotifier<FormVerifyEntity?>(null);

  @override
  ValueNotifier<FormVerifyEntity?> get existingRegister => _existingRegister;

  AnswerFlow _answerFlow = AnswerFlow.main;

  @override
  AnswerFlow get answerFlow => _answerFlow;

  @override
  FormsDetailsViewModel? get formsDetailsViewModel {
    return currentFormsDetailsViewModel;
  }

  bool _isEdidMode = false;
  @override
  bool get isEdidMode => _isEdidMode;

  String? _currentSubFormUUID;
  @override
  String? get currentSubFormUUID => _currentSubFormUUID;

  String currentUUID = '';
  convinienceInit() {
    if (formsDetailsViewModel?.currentUUID == null) {
      const uuid = Uuid();
      currentUUID = uuid.v4();
      currentFormsDetailsViewModel =
          currentFormsDetailsViewModel.copyWith(currentUUID: currentUUID);
    } else {
      currentUUID = formsDetailsViewModel?.currentUUID ?? '';
    }
  }

  StatusPageParams statusPageParams = StatusPageParams(
    errorEntity: null,
    status: StatusCardState.pending,
    viewModel: null,
  );

  @override
  Future<void> loadAnswer() async {
    try {
      _stateController.add(const AnswerFormLoading());

      final localAnswer = await localLoad.load(key: currentUUID);
      _isEdidMode = formsDetailsViewModel?.sessionToEdit != null;
      final answer = await loadAnswerForm
          .load(formsDetailsViewModel?.data?.identifierForm);
      final viewModel = AnswerFormViewModelFactory.make(
          answer, localAnswer, null, _currentSubFormUUID);
      _answerViewModel.add(viewModel);
      _stateController.add(AnswerFormData(viewModel: viewModel));
    } catch (e) {
      _answerViewModel.addError(e);
      _stateController.add(AnswerFormError(e));
    }
  }

  void dispose() {
    _stateController.close();
    _answerViewModel.close();
  }

  @override
  Future<void> saveAnswer({
    required QuestionViewModel? question,
    required String answer,
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required AnswerFlow answerFlow,
    required QuestionType? questionType,
    required AnswerFormViewModel? answerFormViewModel,
    FormVerifyEntity? data,
    bool shouldReload = true,
  }) async {
    if (answerFlow == AnswerFlow.main) {
      final localForm = LatestFormSendedViewModel(
        id: currentUUID,
        identificator: (question?.identificador == true &&
                question?.isFamilyGroupQuantity == false)
            ? answer
            : null,
        registeredDate: DateTime.now().toIso8601String(),
        questionId: question?.isFamilyGroupQuantity == false
            ? question?.id ?? ''
            : null,
        localFormStatus: LocalFormStatus.draft,
      );
      currentFormsDetailsViewModel.data
          ?.setLocalForms(localForm, question?.identificador ?? false);
      final stringData = jsonEncode(currentFormsDetailsViewModel.toJson());
      await localSaveCurrentFormFill.save(
        stringData,
        formsDetailsViewModel?.data?.identifierForm ?? '',
      );
    }
    await saveCurrentAnswerForm.save(
      question: question,
      answer: answer,
      answerFormDataViewModel: answerFormDataViewModel,
      sessionId: sessionId,
      answerFlow: answerFlow,
      questionType: questionType,
      currentUUID: currentUUID,
      isEditMode: _isEdidMode,
      currentSubFormUUID: _currentSubFormUUID,
      sections: answerFormViewModel?.data?.sessions ?? [],
    );
    final localAnswer = await localLoad.load(key: currentUUID);
    final viewModel = AnswerFormViewModelFactory.make(
      answerFormViewModel?.entity,
      localAnswer,
      data,
      _currentSubFormUUID,
    );
    if (shouldReload) {
      _answerViewModel.add(viewModel);

      _stateController.add(AnswerFormData(viewModel: viewModel));
    }
  }

  @override
  Future<bool> save() async {
    try {
      final localAnswer = await localLoad.load(key: currentUUID);
      await Future.delayed(const Duration(seconds: 4));
      FormsDetailsEntity? localFormAnswer = await loadCurrentFormDetailsFill
          .load(localAnswer?.identifierForm ?? '');
      final hasInternet =
          await ConnectivityService.instance.hasInternetAccess();
      if (!hasInternet) {
        LatestFormSendedEntity? errorItem = localFormAnswer?.data?.localForms
            ?.firstWhereOrNull((element) => element.id == currentUUID);
        final index = localFormAnswer?.data?.localForms
            ?.indexWhere((element) => element.id == currentUUID);
        errorItem = errorItem?.copyWith(localFormStatus: LocalFormStatus.wait);
        if (index != null && errorItem != null) {
          localFormAnswer?.data?.localForms?.removeAt(index);
          localFormAnswer?.data?.localForms?.add(errorItem);
        }
        final stringData = jsonEncode(localFormAnswer?.toViewModel().toJson());
        await localSaveCurrentFormFill.save(
          stringData,
          localAnswer?.identifierForm ?? '',
        );
        statusPageParams = StatusPageParams(
          errorEntity: null,
          status: StatusCardState.pending,
          viewModel: formsDetailsViewModel,
        );
        return false;
      } else {
        if (localAnswer != null) {
          final errorEntity = await addFormFill.add(localAnswer);
          if (errorEntity?.errors?.isEmpty == true) {
            final identifierForm =
                formsDetailsViewModel?.data?.identifierForm ?? '';
            final localFormAnswer =
                await loadCurrentFormDetailsFill.load(identifierForm);
            localFormAnswer?.data?.localForms
                ?.removeWhere((element) => element.id == currentUUID);
            final stringData =
                jsonEncode(localFormAnswer?.toViewModel().toJson());
            await localSaveCurrentFormFill.save(
              stringData,
              identifierForm,
            );
            deleteCurrentFormFill.delete(key: currentUUID);
            statusPageParams = StatusPageParams(
              errorEntity: errorEntity,
              status: StatusCardState.success,
              viewModel: formsDetailsViewModel,
            );
            return true;
          } else {
            LatestFormSendedEntity? errorItem = localFormAnswer
                ?.data?.localForms
                ?.firstWhereOrNull((element) => element.id == currentUUID);

            final index = localFormAnswer?.data?.localForms
                ?.indexWhere((element) => element.id == currentUUID);
            localFormAnswer?.data?.localForms
                ?.removeWhere((element) => element.id == currentUUID);
            errorItem = errorItem?.copyWith(
              genericErrorEntity: errorEntity,
              localFormStatus: LocalFormStatus.error,
            );
            if (index != null && errorItem != null) {
              localFormAnswer?.data?.localForms?.insert(index, errorItem);
            }
            final stringData =
                jsonEncode(localFormAnswer?.toViewModel().toJson());
            await localSaveCurrentFormFill.save(
              stringData,
              localAnswer.identifierForm,
            );
            statusPageParams = StatusPageParams(
              errorEntity: errorEntity,
              status: StatusCardState.error,
              viewModel: formsDetailsViewModel,
            );
            return false;
          }
        }
        statusPageParams = StatusPageParams(
          errorEntity: null,
          status: StatusCardState.error,
          viewModel: formsDetailsViewModel,
        );
        return false;
      }
    } catch (_) {
      statusPageParams = StatusPageParams(
        errorEntity: GenericErrorEntity(data: null, success: false, errors: [
          GenericErrorsEntity(sessions: [
            GenericSessionsEntity(
                error: 'Tente novamente mais tarde',
                index: 0,
                title: 'Ocorreu um erro')
          ])
        ]),
        status: StatusCardState.error,
        viewModel: formsDetailsViewModel,
      );
      return false;
    } finally {}
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
  void setFlow({
    required AnswerFlow flow,
    required AnswerFormViewModel? answerFormViewModel,
    required bool isEditMode,
    required String? currentSubFormUUID,
    String? localUUID,
  }) {
    _answerFlow = flow;
    _isEdidMode = isEditMode;
    _currentSubFormUUID = currentSubFormUUID;
  }

  @override
  Future<void> delete({
    required AnswerFormViewModel? viewModel,
    required RemoteFormsFill subForm,
  }) async {
    try {
      RemoteAddFormFillParams? result = await localLoad.load(key: currentUUID);
      result?.subForms
          ?.removeWhere((element) => element.localUUID == subForm.localUUID);
      final stringData = jsonEncode(result?.toJson());
      await localSave.save(form: stringData, key: currentUUID);
      loadAnswer();
    } catch (_) {}
  }

  @override
  Future<bool> validateSection(
      {required int index, required AnswerFormViewModel? viewModel}) async {
    try {
      mainError = null;
      final localAnswer = await localLoad.load(key: currentUUID);
      final visibleSections =
          viewModel?.data?.sessionsByFlow(answerFlow: answerFlow);
      SessionViewModel? section = visibleSections?.safeAt(index);
      final subForm = localAnswer?.subForms?.firstWhereOrNull(
        (element) => element.localUUID == currentSubFormUUID,
      );
      RemoteSessionFill? answer = (answerFlow == AnswerFlow.main
              ? localAnswer?.mainForm?.sessions
              : subForm?.sessions)
          ?.firstWhereOrNull((element) => element?.sessionId == section?.id);
      final requiredIds = section?.questions
          ?.where((element) => element.required == true)
          .toList()
          .map((e) => e.id)
          .where((id) => id != null)
          .toSet();

      final answerIds = answer?.questions
          ?.map((e) => e?.questionId)
          .where((id) => id != null)
          .toSet();

      bool isValid = true;
      if (requiredIds != null && requiredIds.isNotEmpty) {
        isValid = answerIds != null && requiredIds.every(answerIds.contains);
      }
      if (!isValid) {
        mainError = 'Preencha os dados obrigatórios';
      }
      return isValid;
    } catch (e) {
      return false;
    }
  }

  int currentSessionIndex = 0;

  @override
  void updateCurrentSessionIndex(int index) {
    currentSessionIndex = index;
  }

  @override
  Future<void> verifyAnswers({
    required QuestionViewModel? questionViewModel,
    required String answer,
    required AnswerFormViewModel? viewModel,
  }) async {
    try {
      final data = await formVerify.verify(
        QuestionsVerifyParms(
          questionId: questionViewModel?.id,
          questions: viewModel?.allQuestionIds,
          answer: answer,
        ),
      );
      _existingRegister.value = data;
    } catch (_) {
    } finally {}
  }

  @override
  Future<void> didTapOnReuse({
    required FormVerifyEntity? data,
    required AnswerFormViewModel? viewModel,
  }) async {
    try {
      final localAnswer = await localLoad.load(key: currentUUID);
      final newViewModel = AnswerFormViewModelFactory.make(
        viewModel?.entity,
        localAnswer,
        data,
      );
      _answerViewModel.add(newViewModel);

      _stateController.add(AnswerFormData(viewModel: newViewModel));
    } catch (e) {
      _answerViewModel.addError(e);
      _stateController.add(AnswerFormError(e));
    }
  }

  @override
  RemoteQuestionFill? getSubQuestion(
    AnswerFormViewModel? viewModel,
    QuestionViewModel? question,
    String sessionId,
  ) {
    final subForm = viewModel?.localAnswer?.subForms?.firstWhereOrNull(
      (element) => element.localUUID == currentSubFormUUID,
    );
    final subFormSection = subForm?.sessions?.firstWhereOrNull(
      (element) => element?.sessionId == sessionId,
    );
    return subFormSection?.questions?.firstWhereOrNull(
      (element) => element?.questionId == question?.id,
    );
  }

  @override
  Future<void> saveAnswerOnReuse({
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required QuestionType? questionType,
    required AnswerFormViewModel? answerFormViewModel,
    FormVerifyEntity? data,
  }) async {
    await saveCurrentAnswerForm.saveAnswerOnReuse(
      sessionId: sessionId,
      answerFlow: answerFlow,
      currentUUID: currentUUID,
      currentSubFormUUID: currentSubFormUUID,
      data: data,
    );

    final localAnswer = await localLoad.load(key: currentUUID);
    final viewModel = AnswerFormViewModelFactory.make(
        answerFormViewModel?.entity, localAnswer, data);

    _answerViewModel.add(viewModel);
    _stateController.add(AnswerFormData(viewModel: viewModel));
  }
}
