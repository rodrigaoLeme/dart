import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../domain/usecases/form_fill/delete_current_form_fill.dart';
import '../../../domain/usecases/form_fill/load_current_form_fill.dart';
import '../../../domain/usecases/form_fill/save_current_answer_form.dart';
import '../../../domain/usecases/form_fill/save_current_form_fill.dart';
import '../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../ui/modules/answer_form/answer_form_presenter.dart';

class LocalSaveAnswerFormWithLocalFallback implements SaveCurrentAnswerForm {
  final SaveCurrentFormFill localSave;
  final LoadCurrentFormFill localLoad;
  final DeleteCurrentFormFill deleteCurrentFormFill;

  LocalSaveAnswerFormWithLocalFallback({
    required this.localSave,
    required this.localLoad,
    required this.deleteCurrentFormFill,
  });

  @override
  Future<void> save({
    required QuestionViewModel? question,
    required String answer,
    required AnswerFormDataViewModel? answerFormDataViewModel,
    required String sessionId,
    required AnswerFlow answerFlow,
    required QuestionType? questionType,
    required String currentUUID,
    required bool isEditMode,
    required String? currentSubFormUUID,
    required List<SessionViewModel> sections,
  }) async {
    try {
      final allSections = answerFormDataViewModel?.sessionsByFlow(
          answerFlow: answerFlow, removeNoVisibleSections: false);
      final indexSection =
          allSections?.indexWhere((element) => element.id == sessionId);
      // groupId/formId precisam estar definidos antes de inicializarmos um novo resultado
      final groupId = answerFormDataViewModel?.groupId;
      final formId = answerFormDataViewModel?.formId;
      RemoteAddFormFillParams? result = await localLoad.load(key: currentUUID);
      // Primeira vez no mainForm: semear visibilidade default das seções
      if (answerFlow == AnswerFlow.main && result == null) {
        final seededSessions = sections
            .map((s) => RemoteSessionFill(
                  sessionId: s.id,
                  index: s.index,
                  questions: [],
                  defaultVisible: s.visible,
                ))
            .toList();
        result = RemoteAddFormFillParams(
          groupId: groupId,
          formId: formId,
          mainForm: RemoteFormsFill(
            sessions: seededSessions,
            localUUID: currentUUID,
          ),
          subForms: null,
        );
      }
      String? answerFile;
      final isFileAnswer = questionType == QuestionType.anexo;
      if (isFileAnswer) {
        answerFile = await filePathToBase64(answer);
      }
      final form = RemoteFormsFill(
        sessions: [
          RemoteSessionFill(
            sessionId: sessionId,
            tapsInItemsToShowSession: null,
            index: indexSection,
            questions: [
              question
                  ?.copyWith(
                    answer: isFileAnswer ? answerFile : answer,
                    answerFile: answer,
                    index: question.index,
                    visible: question.visible,
                  )
                  .toParams(),
            ],
          )
        ],
        localUUID:
            answerFlow == AnswerFlow.main ? currentUUID : currentSubFormUUID,
      );
      result ??= RemoteAddFormFillParams(
          groupId: groupId,
          formId: formId,
          mainForm: answerFlow == AnswerFlow.main ? form : null,
          subForms: answerFlow == AnswerFlow.subForm ? [form] : null);

      RemoteSessionFill? session;

      if (answerFlow == AnswerFlow.main) {
        session = result.mainForm?.sessions
            ?.firstWhereOrNull((s) => s?.sessionId == sessionId);
      } else {
        if (result.subForms == null) {
          result = result.copyWith(subForms: []);
        }
        final subForm = result.subForms?.firstWhereOrNull(
          (element) => element.localUUID == currentSubFormUUID,
        );
        session = subForm?.sessions?.firstWhereOrNull(
            (sessionElement) => sessionElement?.sessionId == sessionId);

        if (subForm != null && session == null) {
          session = RemoteSessionFill(
            sessionId: sessionId,
            tapsInItemsToShowSession: null,
            index: indexSection,
            questions: [
              question
                  ?.copyWith(
                    answer: isFileAnswer ? answerFile : answer,
                    answerFile: answer,
                    index: question.index,
                    visible: question.visible,
                  )
                  .toParams(),
            ],
          );
          final index = result.subForms?.indexOf(subForm);
          if (index != null) {
            result.subForms?[index].sessions?.add(
              RemoteSessionFill(
                sessionId: sessionId,
                tapsInItemsToShowSession: null,
                index: indexSection,
                questions: [
                  question
                      ?.copyWith(
                        answer: isFileAnswer ? answerFile : answer,
                        answerFile: answer,
                        index: question.index,
                        visible: question.visible,
                      )
                      .toParams(),
                ],
              ),
            );
          }
        }
      }
      if (session != null) {
        final index =
            session.questions?.indexWhere((q) => q?.questionId == question?.id);

        if (index != null && index != -1) {
          final originalQuestion = session.questions![index];
          session.questions![index] = originalQuestion?.copyWith(
            answer: isFileAnswer ? answerFile : answer,
            answerFile: answer,
            index: question?.index,
          );
        } else {
          session.questions?.add(question
              ?.copyWith(
                answer: isFileAnswer ? answerFile : answer,
                answerFile: answer,
                index: question.index,
                visible: question.visible,
              )
              .toParams());
        }
      } else {
        if (answerFlow == AnswerFlow.main) {
          result.mainForm?.sessions?.add(
            RemoteSessionFill(
              sessionId: sessionId,
              index: indexSection,
              questions: [
                question
                    ?.copyWith(
                      answer: isFileAnswer ? answerFile : answer,
                      answerFile: answer,
                      index: question.index,
                      visible: question.visible,
                    )
                    .toParams(),
              ],
            ),
          );
        } else {
          session = RemoteSessionFill(
            sessionId: sessionId,
            index: indexSection,
            questions: [
              question
                  ?.copyWith(
                    answer: isFileAnswer ? answerFile : answer,
                    answerFile: answer,
                    index: question.index,
                    visible: question.visible,
                  )
                  .toParams(),
            ],
          );
          result.subForms?.add(
            RemoteFormsFill(
              localUUID: currentSubFormUUID,
              sessions: [session],
            ),
          );
        }
      }
      String? answerQuestion = answer;
      if (question?.questionType == QuestionType.multiplaEscolha) {
        answerQuestion = question?.diffList(answer);
      }
      bool isSingleChoiceWithNoConfig =
          question?.questionType == QuestionType.unicaSelecao &&
              question?.answer == null;

      final List<QuestionOptionsConfigViewModel?> questionOptionsConfigs = [];

      final questionOptionsConfigByAnswer =
          question?.getQuestionOptionsConfigViewModelByAnswer(answerQuestion);
      questionOptionsConfigs.add(questionOptionsConfigByAnswer);
      if (!isSingleChoiceWithNoConfig &&
          question?.questionType == QuestionType.unicaSelecao) {
        questionOptionsConfigs.insert(
            0,
            question
                ?.getQuestionOptionsConfigViewModelByAnswer(question.answer));
      }

      final subForm = result.subForms?.firstWhereOrNull(
        (element) => element.localUUID == currentSubFormUUID,
      );
      int? indexSubForm = 0;
      if (subForm != null) {
        indexSubForm = result.subForms?.indexOf(subForm);
      }
      final currentSessionViewModel = allSections?[indexSection ?? 0];
      int enumeratedItem = 0;
      List<RemoteSessionFill?>? answerSessions;
      if (answerFlow == AnswerFlow.main) {
        answerSessions = result.mainForm?.sessions;
      } else {
        answerSessions = result.subForms?[indexSubForm ?? 0].sessions;
      }

      for (var questionOptionsConfigViewModelByAnswer
          in questionOptionsConfigs) {
        if (question?.questionType == QuestionType.multiplaEscolha) {
        } else if (!isSingleChoiceWithNoConfig &&
            enumeratedItem == 0 &&
            question?.questionType == QuestionType.unicaSelecao) {
          answerQuestion = question?.answer;
        } else {
          if (answer != '') {
            answerQuestion = answer;
          }
        }
        question = question?.copyWith(answer: answer);

        enumeratedItem += 1;
        final configByAnswer = questionOptionsConfigViewModelByAnswer;
        switch (questionOptionsConfigViewModelByAnswer?.shiftActionEnum) {
          case ShiftAction.endForm:
            if (indexSection == null) break;

            final subsequentSections = allSections
                ?.asMap()
                .entries
                .where((entry) => entry.key > indexSection)
                .map((entry) => entry.value)
                .toList();

            if (subsequentSections != null) {
              for (final targetSessionViewModel in subsequentSections) {
                _updateSessionVisibility(
                  answerSessions: answerSessions,
                  targetSessionViewModel: targetSessionViewModel,
                  answerQuestion: answerQuestion,
                  shiftAction: ShiftAction.endForm,
                  questionId: question?.id,
                );
              }
            }

          case ShiftAction.nextQuestion:
            final currentQuestionIndex = question?.index ?? -1;
            if (currentQuestionIndex == -1) break;
            final nextQuestionIndex = currentQuestionIndex + 1;

            final targetQuestionViewModel = currentSessionViewModel?.questions
                ?.firstWhereOrNull((q) => q.index == nextQuestionIndex);

            _updateQuestionVisibility(
              session: session,
              targetQuestionViewModel: targetQuestionViewModel,
              question: question,
              answerQuestion: answerQuestion,
            );

          case ShiftAction.lastQuestion:
            final targetQuestionViewModel =
                currentSessionViewModel?.questions?.lastOrNull;

            _updateQuestionVisibility(
              session: session,
              targetQuestionViewModel: targetQuestionViewModel,
              question: question,
              answerQuestion: answerQuestion,
            );

          case ShiftAction.toQuestion:
            if (configByAnswer?.shiftActionIndex == null) break;
            final targetQuestionViewModel = currentSessionViewModel?.questions
                ?.firstWhereOrNull(
                    (q) => q.index == configByAnswer?.shiftActionIndex);

            _updateQuestionVisibility(
              session: session,
              targetQuestionViewModel: targetQuestionViewModel,
              question: question,
              answerQuestion: answerQuestion,
            );

          case ShiftAction.toSession:
            if (configByAnswer?.shiftActionIndex == null) break;
            final targetSessionViewModel = allSections?.firstWhereOrNull(
                (s) => s.index == configByAnswer?.shiftActionIndex);

            _updateSessionVisibility(
              answerSessions: answerSessions,
              targetSessionViewModel: targetSessionViewModel,
              answerQuestion: answerQuestion,
              shiftAction: ShiftAction.toSession,
              questionId: question?.id,
            );

          case ShiftAction.none:
          default:
        }
      }

      final stringData = jsonEncode(result.toJson());
      await localSave.save(form: stringData, key: currentUUID);
    } catch (error) {
      deleteCurrentFormFill.delete(key: currentUUID);
    }
  }

  @override
  Future<void> saveAnswerOnReuse({
    required String sessionId,
    required AnswerFlow answerFlow,
    required String currentUUID,
    required String? currentSubFormUUID,
    FormVerifyEntity? data,
  }) async {
    try {
      RemoteAddFormFillParams? result = await localLoad.load(key: currentUUID);
      RemoteSessionFill? session;

      if (answerFlow == AnswerFlow.main) {
        session = result?.mainForm?.sessions
            ?.firstWhereOrNull((s) => s?.sessionId == sessionId);
      } else {
        final subForm = result?.subForms?.firstWhereOrNull(
          (element) => element.localUUID == currentSubFormUUID,
        );
        session = subForm?.sessions?.firstWhereOrNull(
            (sessionElement) => sessionElement?.sessionId == sessionId);
      }
      if (session != null) {
        for (QuestionsEntity? item in data?.data ?? []) {
          final question = session.questions?.firstWhereOrNull(
              (element) => element?.questionId == item?.questionId);
          if (question != null) {
            final answer = item?.answer;
            final index = session.questions
                ?.indexWhere((q) => q?.questionId == item?.questionId);
            if (answer == '') {
              if (index != null) {
                session.questions?.removeAt(index);
              }
            } else {
              if (index != null && index != -1) {
                final originalQuestion = session.questions![index];
                session.questions![index] = originalQuestion?.copyWith(
                  answer: answer,
                  answerFile: answer,
                );
              } else {
                session.questions?.add(question.copyWith(
                  answer: answer,
                  answerFile: answer,
                ));
              }
            }
          } else {
            session.questions?.add(
              RemoteQuestionFill(
                questionId: item?.questionId,
                answer: item?.answer,
                answerFile: item?.answer,
              ),
            );
          }
        }
      }

      final stringData = jsonEncode(result?.toJson());
      await localSave.save(form: stringData, key: currentUUID);
    } catch (error) {
      deleteCurrentFormFill.delete(key: currentUUID);
    }
  }

  Future<String> filePathToBase64(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  void _updateSessionVisibility({
    required List<RemoteSessionFill?>? answerSessions,
    required SessionViewModel? targetSessionViewModel,
    required String? answerQuestion,
    required ShiftAction shiftAction,
    required String? questionId,
  }) {
    if (answerSessions == null ||
        targetSessionViewModel?.id == null ||
        questionId == null) {
      return;
    }

    final sessionIndexInAnswer = answerSessions
        .indexWhere((s) => s?.sessionId == targetSessionViewModel!.id);
    RemoteSessionFill? sessionToUpdate;

    if (sessionIndexInAnswer != -1) {
      sessionToUpdate = answerSessions[sessionIndexInAnswer];
    } else {
      sessionToUpdate = RemoteSessionFill(
        sessionId: targetSessionViewModel!.id,
        questions: [],
        index: targetSessionViewModel.index,
      );
      answerSessions.add(sessionToUpdate);
    }

    if (sessionToUpdate == null) return;

    if (shiftAction == ShiftAction.endForm) {
      final hideTaps = Map<String, dynamic>.from(
          sessionToUpdate.tapsInItemsToHideSession ?? {});
      final key = questionId;
      final List<String> tapsList = (hideTaps[key] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      if (tapsList.contains(answerQuestion)) {
        tapsList.remove(answerQuestion);
      } else {
        if (answerQuestion != null) {
          tapsList.add(answerQuestion);
        }
      }
      if (tapsList.isEmpty) {
        hideTaps.remove(key);
      } else {
        hideTaps[key] = tapsList;
      }
      sessionToUpdate.tapsInItemsToHideSession = hideTaps;
      final hasHide = sessionToUpdate.tapsInItemsToHideSession?.values
              .any((list) => (list as List).isNotEmpty) ??
          false;
      final hasShow = sessionToUpdate.tapsInItemsToShowSession?.values
              .any((list) => (list as List).isNotEmpty) ??
          false;
      final defaultVisible = targetSessionViewModel?.visible == true;
      final isVisibleByAnswer = sessionToUpdate.isVisibleByAnswer;
      final finalVisible = isVisibleByAnswer == false
          ? false
          : (hasHide ? false : (hasShow ? true : defaultVisible));
      if (finalVisible == false) {
        final questionsList = sessionToUpdate.questions;
        if (questionsList != null) {
          for (var i = 0; i < questionsList.length; i++) {
            final q = questionsList[i];
            if (q != null) {
              questionsList[i] = q.copyWith(answer: null, answerFile: null);
            }
          }
        }
      }
    } else if (shiftAction == ShiftAction.toSession) {
      // Toggle em mapa de SHOW por questionId (origem)
      final showTaps = Map<String, dynamic>.from(
          sessionToUpdate.tapsInItemsToShowSession ?? {});
      final key = questionId;
      final List<String> tapsList = (showTaps[key] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      if (tapsList.contains(answerQuestion)) {
        tapsList.remove(answerQuestion);
      } else {
        if (answerQuestion != null) {
          tapsList.add(answerQuestion);
        }
      }
      if (tapsList.isEmpty) {
        showTaps.remove(key);
      } else {
        showTaps[key] = tapsList;
      }
      sessionToUpdate.tapsInItemsToShowSession = showTaps;
    }
  }

  void _updateQuestionVisibility({
    required RemoteSessionFill? session,
    required QuestionViewModel? targetQuestionViewModel,
    required QuestionViewModel? question,
    required String? answerQuestion,
  }) {
    if (session == null ||
        targetQuestionViewModel?.id == null ||
        question?.id == null) {
      return;
    }

    final questionIndexInAnswer = session.questions
        ?.indexWhere((q) => q?.questionId == targetQuestionViewModel!.id);
    RemoteQuestionFill? questionToUpdate;

    if (questionIndexInAnswer != null && questionIndexInAnswer != -1) {
      questionToUpdate = session.questions?[questionIndexInAnswer];
    } else {
      questionToUpdate = RemoteQuestionFill(
        questionId: targetQuestionViewModel!.id,
      );
      session.questions ??= [];
      session.questions?.add(questionToUpdate);
    }

    if (questionToUpdate == null) return;

    final taps = Map<String, dynamic>.from(
        questionToUpdate.tapsInItemsToShowQuestion ?? {});
    // chave = questionId da pergunta de ORIGEM
    final key = question!.id!;
    final List<String> tapsList =
        (taps[key] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    if (tapsList.contains(answerQuestion)) {
      tapsList.remove(answerQuestion);
    } else {
      if (answerQuestion != null) {
        tapsList.add(answerQuestion);
      }
    }
    if (tapsList.isEmpty) {
      taps.remove(key);
    } else {
      taps[key] = tapsList;
    }
    questionToUpdate.tapsInItemsToShowQuestion = taps;

    final hasHide = questionToUpdate.tapsInItemsToHideQuestion?.values
            .any((list) => (list as List).isNotEmpty) ??
        false;
    final hasShow = questionToUpdate.tapsInItemsToShowQuestion?.values
            .any((list) => (list as List).isNotEmpty) ??
        false;
    final defaultVisible = targetQuestionViewModel?.visible == true;
    final finalVisible = hasHide ? false : (hasShow ? true : defaultVisible);
    if (finalVisible == false) {
      final idx = questionIndexInAnswer ??
          session.questions
              ?.indexWhere((q) => q?.questionId == targetQuestionViewModel!.id);
      if (idx != null && idx != -1) {
        final original = session.questions![idx];
        if (original != null) {
          session.questions![idx] =
              original.copyWith(answer: null, answerFile: null);
        }
      }
    }
  }
}
