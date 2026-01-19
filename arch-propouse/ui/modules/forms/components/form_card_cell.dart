import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../presentation/presenters/forms/forms_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';

class FormCardCell extends StatelessWidget {
  final FormsViewModel? viewModel;
  final Function(FormsViewModel?) onTap;

  const FormCardCell({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(viewModel);
      },
      child: Card(
        color: AdraColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AdraColors.cyanBlue,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AdraColors.cyanBlue,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'lib/ui/assets/images/logo/log.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            AdraText(
                              text: viewModel?.projectName?.toUpperCase() ?? '',
                              textSize: AdraTextSizeEnum.caption2,
                              textStyleEnum: AdraTextStyleEnum.bold,
                              color: AdraColors.neutralLowDark,
                              adraStyles: AdraStyles.poppins,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AdraText(
                        text: viewModel?.group?.toUpperCase() ?? '',
                        adraStyles: AdraStyles.poppins,
                        textSize: AdraTextSizeEnum.caption1,
                        textStyleEnum: AdraTextStyleEnum.regular,
                        color: AdraColors.secundary,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AdraText(
                text: viewModel?.formName ?? '',
                textSize: AdraTextSizeEnum.h4,
                textStyleEnum: AdraTextStyleEnum.bold,
                color: AdraColors.black,
                adraStyles: AdraStyles.poppins,
              ),
              const SizedBox(height: 8),
              AdraText(
                text: 'Enviados: ${viewModel?.send}',
                adraStyles: AdraStyles.poppins,
                textSize: AdraTextSizeEnum.caption1,
                textStyleEnum: AdraTextStyleEnum.regular,
                color: AdraColors.secundary,
              ),
              const SizedBox(height: 4),
              AdraText(
                text:
                    'Tipo: ${viewModel?.type} · Encerramento: ${viewModel?.formatDate}',
                adraStyles: AdraStyles.poppins,
                textSize: AdraTextSizeEnum.caption1,
                textStyleEnum: AdraTextStyleEnum.regular,
                color: AdraColors.secundary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
