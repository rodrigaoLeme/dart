import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../presentation/presenters/answer_form/answer_form_state.dart';
import '../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../mixins/mixins.dart';

abstract class AnswerFormPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<AnswerFormState> get state;
  Stream<AnswerFormViewModel?> get answerViewModel;
  AnswerFlow get answerFlow;
  FormsDetailsViewModel? get formsDetailsViewModel;
  Stream<String?> get mainErrorStream;
  ValueNotifier<FormVerifyEntity?> get existingRegister;
  bool get isEdidMode;
  String? get currentSubFormUUID;

  Future<void> loadAnswer();
  Future<bool> save();
  Future<void> saveAnswer({
    required QuestionViewModel? question,
    required String answer,
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required AnswerFlow answerFlow,
    required QuestionType? questionType,
    required AnswerFormViewModel? answerFormViewModel,
    FormVerifyEntity? data,
    bool shouldReload,
  });
  goToStatusPage();
  void setFlow({
    required AnswerFlow flow,
    required AnswerFormViewModel? answerFormViewModel,
    required bool isEditMode,
    String? localUUID,
    required String? currentSubFormUUID,
  });
  Future<void> delete({
    required AnswerFormViewModel? viewModel,
    required RemoteFormsFill subForm,
  });
  Future<bool> validateSection(
      {required int index, required AnswerFormViewModel? viewModel});

  void updateCurrentSessionIndex(int index);
  Future<void> verifyAnswers({
    required QuestionViewModel? questionViewModel,
    required String answer,
    required AnswerFormViewModel? viewModel,
  });
  Future<void> didTapOnReuse({
    required FormVerifyEntity? data,
    required AnswerFormViewModel? viewModel,
  });
  RemoteQuestionFill? getSubQuestion(
    AnswerFormViewModel? viewModel,
    QuestionViewModel? question,
    String sessionId,
  );
  Future<void> saveAnswerOnReuse({
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required QuestionType? questionType,
    required AnswerFormViewModel? answerFormViewModel,
    FormVerifyEntity? data,
  });
}

enum AnswerFlow {
  main,
  subForm;
}
