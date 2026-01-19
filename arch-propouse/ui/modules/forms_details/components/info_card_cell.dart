import 'package:flutter/material.dart';

import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart'
    show FormsDetailsDataViewModel;
import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';

class InfoCardCell extends StatelessWidget {
  final FormsDetailsDataViewModel? viewModel;
  const InfoCardCell({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AdraColors.secondaryFixed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem('${viewModel?.send ?? 0}', R.string.shippedItems),
          _buildInfoItem(viewModel?.formatDate ?? '-', R.string.closureLabel),
          _buildInfoItem(viewModel?.type ?? '-', R.string.productType),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AdraText(
            text: title,
            color: AdraColors.primary,
            textSize: AdraTextSizeEnum.subheadline,
            textStyleEnum: AdraTextStyleEnum.semibold,
            adraStyles: AdraStyles.poppins,
          ),
          AdraText(
            text: subtitle,
            textSize: AdraTextSizeEnum.caption1,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.secundary,
            adraStyles: AdraStyles.poppins,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
