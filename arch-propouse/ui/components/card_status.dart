import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/entities/share/generic_error_entity.dart';
import '../../presentation/presenters/status/status_view_model.dart';
import 'adra_colors.dart';
import 'adra_id.dart';
import 'adra_text.dart';
import 'enum/adra_size_enum.dart';
import 'error_action_sheet.dart';
import 'theme/adra_styles.dart';

class CardStatus extends StatelessWidget {
  final StatusCardViewModel? viewModel;
  final void Function(GenericErrorEntity?) onPressed;
  const CardStatus({
    required this.viewModel,
    required this.onPressed,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            viewModel?.iconAsset ?? '',
            width: 48,
            height: 48,
            color: viewModel?.iconColor,
            alignment: Alignment.topLeft,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 4.0),
            child: AdraText(
              text: viewModel?.title ?? '',
              textSize: AdraTextSizeEnum.h1,
              textStyleEnum: AdraTextStyleEnum.bold,
              color: viewModel?.textColor,
              adraStyles: AdraStyles.poppins,
            ),
          ),
          AdraText(
            text: viewModel?.description ?? '',
            textSize: AdraTextSizeEnum.callout,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.neutralLowDark,
            adraStyles: AdraStyles.poppins,
          ),
          const SizedBox(height: 24),
          if (viewModel?.state == StatusCardState.success)
            AdraId(
              title: viewModel?.error?.data ?? '',
            ),
          if (viewModel?.state == StatusCardState.error)
            ErrorActionSheet(
              errorEntity: viewModel?.error,
              onPressed: onPressed,
            )
        ],
      ),
    );
  }
}
