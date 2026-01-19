import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uuid/uuid.dart';

import '../../../../main/factories/pages/answer_form/answer_form_presenter_factory.dart';
import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../answer_form_page.dart';
// No direct use of components barrel here
import '../answer_form_presenter.dart';
import '../components/seccoundary_button.dart';
import '../components/user_card.dart';

class SubFormSection extends StatelessWidget {
  final AnswerFormPresenter presenter;
  final AnswerFormViewModel? viewModel;
  final SessionViewModel tab;

  const SubFormSection({
    super.key,
    required this.presenter,
    required this.viewModel,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    final localSubFormAnswerCount =
        viewModel?.localAnswer?.subForms?.length ?? 0;
    final isShowAddSubFormButton =
        (tab.familyGroupQuantity ?? 0) > localSubFormAnswerCount;

    return Column(
      children: [
        ...(viewModel?.localAnswer?.subForms?.map((subForm) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: UserCard(
                  subForm: subForm,
                  sessions: viewModel?.data?.subForm?.sessions,
                  onTapDelete: () {
                    presenter.delete(
                      viewModel: viewModel,
                      subForm: subForm,
                    );
                  },
                  onTapEdit: (sessionViewModel) async {
                    final formsDetailsViewModel =
                        presenter.formsDetailsViewModel?.copyWith(
                      sessionToEdit: sessionViewModel,
                      answerFlow: AnswerFlow.subForm,
                    );
                    final subFormPresenter =
                        makeAnswerFormPresenter(formsDetailsViewModel);
                    subFormPresenter.setFlow(
                      flow: AnswerFlow.subForm,
                      answerFormViewModel: viewModel,
                      isEditMode: true,
                      currentSubFormUUID: subForm.localUUID,
                    );

                    final _ = await Modular.to.push(
                      MaterialPageRoute(
                        builder: (context) => AnswerFormPage(
                          presenter: subFormPresenter,
                        ),
                      ),
                    );
                    presenter.setFlow(
                      flow: AnswerFlow.main,
                      answerFormViewModel: viewModel,
                      isEditMode: false,
                      currentSubFormUUID: null,
                    );
                    presenter.loadAnswer();
                  },
                ),
              );
            }).toList() ??
            []),
        if (isShowAddSubFormButton == true)
          SeccoundaryButton(
            onPressed: () async {
              final subFormPresenter =
                  makeAnswerFormPresenter(presenter.formsDetailsViewModel);
              subFormPresenter.setFlow(
                flow: AnswerFlow.subForm,
                answerFormViewModel: viewModel,
                isEditMode: false,
                currentSubFormUUID: const Uuid().v4(),
              );
              final _ = await Modular.to.push(
                MaterialPageRoute(
                  builder: (context) => AnswerFormPage(
                    presenter: subFormPresenter,
                  ),
                ),
              );
              presenter.setFlow(
                flow: AnswerFlow.main,
                answerFormViewModel: viewModel,
                isEditMode: false,
                currentSubFormUUID: null,
              );
              presenter.loadAnswer();
            },
          ),
      ],
    );
  }
}
