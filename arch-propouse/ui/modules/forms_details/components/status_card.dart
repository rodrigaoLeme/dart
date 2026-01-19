import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../components/components.dart';
import '../forms_details_presenter.dart';
import 'status_action_sheet.dart';

class StatusCard extends StatelessWidget {
  final LatestFormSendedViewModel? viewModel;
  final bool showRefreshIcon;
  final bool showMoreOptionsIcon;
  final void Function()? onPressed;
  final void Function(SessionViewModel, LatestFormSendedViewModel?)? onTapEdit;
  final List<SessionViewModel>? sessions;
  final void Function(LatestFormSendedViewModel?)? onTapDelete;
  final FormsDetailsPresenter presenter;

  const StatusCard({
    super.key,
    required this.viewModel,
    required this.showRefreshIcon,
    required this.showMoreOptionsIcon,
    this.onPressed,
    this.onTapEdit,
    this.onTapDelete,
    required this.sessions,
    required this.presenter,
  });

  Color _getStatusColor(LocalFormStatus status) {
    switch (status) {
      case LocalFormStatus.error:
        return AdraColors.indicatorColor;
      case LocalFormStatus.draft:
        return AdraColors.secundary;
      case LocalFormStatus.wait:
        return AdraColors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: showRefreshIcon,
                      child: AdraText(
                        text: viewModel?.localFormStatus?.label.toUpperCase() ??
                            '',
                        adraStyles: AdraStyles.poppins,
                        color: _getStatusColor(viewModel?.localFormStatus ??
                            LocalFormStatus.draft),
                        textSize: AdraTextSizeEnum.caption1,
                        textStyleEnum: AdraTextStyleEnum.regular,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AdraText(
                      text: viewModel?.identificator ?? '',
                      adraStyles: AdraStyles.poppins,
                      color: AdraColors.black,
                      textSize: AdraTextSizeEnum.callout,
                      textStyleEnum: AdraTextStyleEnum.bold,
                    ),
                    const SizedBox(height: 4),
                    AdraText(
                      text: viewModel?.formatDateHour ?? '',
                      textSize: AdraTextSizeEnum.subheadline,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.secundary,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible:
                        (viewModel?.localFormStatus?.shouldShowRefreshIcon ??
                            false),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/ui/assets/images/icon/arrows-rotate-regular.svg',
                        height: 20,
                        width: 20,
                        color: AdraColors.primary,
                      ),
                      onPressed: onPressed,
                    ),
                  ),
                  Visibility(
                    visible: showMoreOptionsIcon,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/ui/assets/images/icon/ellipsis-vertical-regular.svg',
                        height: 20,
                        width: 20,
                        color: AdraColors.primary,
                      ),
                      onPressed: () async {
                        final visiblaSessions = await presenter.getSessions(
                            viewModel, sessions ?? []);
                        StatusActionSheet.showActionSheet(
                          context,
                          onPressed,
                          visiblaSessions,
                          (session) {
                            if (onTapEdit != null) {
                              onTapEdit!(session, viewModel);
                            }
                          },
                          () {
                            if (onTapDelete != null) {
                              onTapDelete!(viewModel);
                            }
                          },
                          viewModel,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
