import 'package:flutter/material.dart';

import 'adra_colors.dart';
import 'adra_text.dart';
import 'enum/adra_size_enum.dart';
import 'theme/adra_styles.dart';

class AdraId extends StatelessWidget {
  final String title;

  const AdraId({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 68.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdraText(
              text: 'ADRA ID',
              textSize: AdraTextSizeEnum.callout,
              textStyleEnum: AdraTextStyleEnum.regular,
              color: AdraColors.neutralLowDark,
              adraStyles: AdraStyles.poppins,
            ),
            AdraText(
              text: title,
              textSize: AdraTextSizeEnum.h1,
              textStyleEnum: AdraTextStyleEnum.bold,
              color: AdraColors.neutralLowDark,
              adraStyles: AdraStyles.poppins,
            ),
            AdraText(
              text: 'Informe o ID para o usuário',
              textSize: AdraTextSizeEnum.callout,
              textStyleEnum: AdraTextStyleEnum.regular,
              color: AdraColors.neutralLowDark,
              adraStyles: AdraStyles.poppins,
            ),
          ],
        ),
      ),
    );
  }
}
