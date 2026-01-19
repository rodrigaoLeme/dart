import 'package:flutter/material.dart';

import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';

class SeccoundaryButton extends StatelessWidget {
  final void Function() onPressed;
  const SeccoundaryButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            color: AdraColors.primary,
            size: 22.0,
          ),
          TextButton(
            onPressed: onPressed,
            child: AdraText(
              text: 'Adicionar depedente',
              textSize: AdraTextSizeEnum.subheadline,
              textStyleEnum: AdraTextStyleEnum.bold,
              color: AdraColors.primary,
              adraStyles: AdraStyles.poppins,
            ),
          ),
        ],
      ),
    );
  }
}
