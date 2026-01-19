import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../components/components.dart';
import '../forms_details_presenter.dart';
import 'status_card.dart';

class ListStatusDetailsCell extends StatelessWidget {
  final LatestFormSendedViewModel? viewModel;
  final void Function(LatestFormSendedViewModel?)? onPressed;
  final bool showRefreshIcon;
  final bool showMoreOptionsIcon;
  final List<SessionViewModel>? sessions;
  final void Function(SessionViewModel, LatestFormSendedViewModel?)? onTapEdit;
  final void Function(LatestFormSendedViewModel?)? onTapDelete;
  final FormsDetailsPresenter presenter;

  const ListStatusDetailsCell({
    super.key,
    required this.viewModel,
    this.onPressed,
    required this.showRefreshIcon,
    required this.showMoreOptionsIcon,
    required this.sessions,
    this.onTapEdit,
    this.onTapDelete,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: StatusCard(
            showRefreshIcon: showRefreshIcon,
            showMoreOptionsIcon: showMoreOptionsIcon,
            viewModel: viewModel,
            onPressed: () {
              if (onPressed != null) {
                onPressed!(viewModel);
              }
            },
            sessions: sessions,
            onTapEdit: onTapEdit,
            onTapDelete: onTapDelete,
            presenter: presenter,
          ),
        ),
        const Divider(
          color: AdraColors.cyanBlue,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
