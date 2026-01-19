import 'package:flutter/material.dart';

import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';
import 'info_card_section.dart';

class FormsDetailsHeader extends StatelessWidget {
  final FormsDetailsViewModel? viewModel;
  const FormsDetailsHeader({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdraColors.cyanBlue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/ui/assets/images/icon/adra.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    AdraText(
                      text: viewModel?.data?.projectName?.toUpperCase() ?? '',
                      textSize: AdraTextSizeEnum.caption2,
                      textStyleEnum: AdraTextStyleEnum.bold,
                      color: AdraColors.neutralLowDark,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AdraText(
                    text: viewModel?.data?.group?.toUpperCase() ?? '',
                    adraStyles: AdraStyles.poppins,
                    textSize: AdraTextSizeEnum.caption1,
                    textStyleEnum: AdraTextStyleEnum.regular,
                    color: AdraColors.secundary,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
            child: AdraText(
              text: viewModel?.data?.formName ?? '',
              textSize: AdraTextSizeEnum.h2,
              textStyleEnum: AdraTextStyleEnum.bold,
              color: AdraColors.black,
              adraStyles: AdraStyles.poppins,
            ),
          ),
          AdraText(
            text: R.string.descriptionForms,
            textSize: AdraTextSizeEnum.subheadline,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.secundary,
            adraStyles: AdraStyles.poppins,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: InfoCardSection(viewModel: viewModel?.data),
          ),
        ],
      ),
    );
  }
}
