import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../helpers/extensions/date_formater_extension.dart';
import '../answer_form_presenter.dart';
import 'add_file.dart';
import 'linear_scale.dart';
import 'long_text.dart';
import 'multiple_choice.dart';
import 'select_date.dart';
import 'select_time.dart';
import 'short_text.dart';
import 'subform_section.dart';
import 'unique_selection.dart';

class SectionContent extends StatelessWidget {
  final AnswerFormPresenter presenter;
  final AnswerFormViewModel? viewModel;
  final SessionViewModel tab;
  final bool isMainFlow;
  final bool isEditMode;
  final ValueListenable<FormVerifyEntity?> existingRegister;
  final void Function(QuestionViewModel?, String answer) onEndEditingValidate;

  const SectionContent({
    super.key,
    required this.presenter,
    required this.viewModel,
    required this.tab,
    required this.isMainFlow,
    required this.isEditMode,
    required this.existingRegister,
    required this.onEndEditingValidate,
  });

  @override
  Widget build(BuildContext context) {
    QuestionViewModel? questionToValidate;

    final shouldShowSubForm = tab.shouldShowSubForm;
    final sectionLength = tab.questions?.length ?? 0;
    return ListView.builder(
      itemCount: sectionLength + (shouldShowSubForm ? 1 : 0),
      itemBuilder: (context, index) {
        if (shouldShowSubForm && index == sectionLength) {
          return SubFormSection(
              presenter: presenter, viewModel: viewModel, tab: tab);
        }

        QuestionViewModel? question = tab.questions?[index];
        if (!isMainFlow && isEditMode) {
          final subQuestion = presenter.getSubQuestion(
            viewModel,
            question,
            tab.id ?? '',
          );
          question = question?.copyWith(
            answer: subQuestion?.answer,
            answerFile: subQuestion?.answerFile,
          );
        }

        if (question?.visible == false) {
          return const SizedBox.shrink();
        }

        switch (question?.questionType) {
          case QuestionType.textoCurto:
            return ValueListenableBuilder<FormVerifyEntity?>(
              valueListenable: existingRegister,
              builder: (context, value, child) {
                return ShortText(
                  question: question,
                  onChanged: (answer) {
                    presenter.saveAnswer(
                      question: question,
                      answer: answer,
                      answerFormDataViewModel: viewModel?.data,
                      sessionId: tab.id ?? '',
                      answerFlow: presenter.answerFlow,
                      questionType: question?.questionType,
                      answerFormViewModel: viewModel,
                      shouldReload: question?.isFamilyGroupQuantity == true,
                    );
                  },
                  onEndEditing: (answer) {
                    questionToValidate = question;
                    onEndEditingValidate(question, answer);
                  },
                  formVerifyEntity:
                      questionToValidate?.id == question?.id ? value : null,
                  onReuse: (formVerifyEntity) {
                    presenter.saveAnswerOnReuse(
                      answerFormDataViewModel: viewModel?.data,
                      sessionId: tab.id ?? '',
                      questionType: question?.questionType,
                      answerFormViewModel: viewModel,
                      data: formVerifyEntity,
                    );
                  },
                );
              },
            );
          case QuestionType.textoLongo:
            return LongText(
              question: question,
              onChanged: (answer) {
                presenter.saveAnswer(
                  question: question,
                  answer: answer,
                  answerFormDataViewModel: viewModel?.data,
                  sessionId: tab.id ?? '',
                  answerFlow: presenter.answerFlow,
                  questionType: question?.questionType,
                  answerFormViewModel: viewModel,
                  shouldReload: false,
                );
              },
            );
          case QuestionType.anexo:
            return AddFile(
              question: question,
              onChanged: (answer) {
                presenter.saveAnswer(
                  question: question,
                  answer: answer,
                  answerFormDataViewModel: viewModel?.data,
                  sessionId: tab.id ?? '',
                  answerFlow: presenter.answerFlow,
                  questionType: question?.questionType,
                  answerFormViewModel: viewModel,
                );
              },
            );
          case QuestionType.linearScale:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 48.0),
              child: LinearScale(
                question: question,
                onChanged: (answer) {
                  presenter.saveAnswer(
                    question: question,
                    answer: answer,
                    answerFormDataViewModel: viewModel?.data,
                    sessionId: tab.id ?? '',
                    answerFlow: presenter.answerFlow,
                    questionType: question?.questionType,
                    answerFormViewModel: viewModel,
                  );
                },
              ),
            );
          case QuestionType.multiplaEscolha:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: MultipleChoice(
                question: question,
                onChanged: (answer) {
                  presenter.saveAnswer(
                    question: question,
                    answer: answer,
                    answerFormDataViewModel: viewModel?.data,
                    sessionId: tab.id ?? '',
                    answerFlow: presenter.answerFlow,
                    questionType: question?.questionType,
                    answerFormViewModel: viewModel,
                  );
                },
              ),
            );
          case QuestionType.data:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0),
              child: SelectDate(
                question: question,
                onDateSelected: (answer) {
                  presenter.saveAnswer(
                    question: question,
                    answer: answer,
                    answerFormDataViewModel: viewModel?.data,
                    sessionId: tab.id ?? '',
                    answerFlow: presenter.answerFlow,
                    questionType: question?.questionType,
                    answerFormViewModel: viewModel,
                  );
                },
              ),
            );
          case QuestionType.hora:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0),
              child: SelectTime(
                question: question,
                onTimeSelected: (timeOfDay) {
                  presenter.saveAnswer(
                    question: question,
                    answer: timeOfDay.timeOfDayToString,
                    answerFormDataViewModel: viewModel?.data,
                    sessionId: tab.id ?? '',
                    answerFlow: presenter.answerFlow,
                    questionType: question?.questionType,
                    answerFormViewModel: viewModel,
                  );
                },
              ),
            );
          case QuestionType.unicaSelecao:
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: UniqueSelection(
                question: question,
                onChanged: (answer) {
                  presenter.saveAnswer(
                    question: question,
                    answer: answer,
                    answerFormDataViewModel: viewModel?.data,
                    sessionId: tab.id ?? '',
                    answerFlow: presenter.answerFlow,
                    questionType: question?.questionType,
                    answerFormViewModel: viewModel,
                  );
                },
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
