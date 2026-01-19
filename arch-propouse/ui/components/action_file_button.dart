import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/i18n/resources.dart';
import 'adra_colors.dart';
import 'adra_text.dart';
import 'dashed_border_painter.dart';
import 'enum/adra_size_enum.dart';
import 'theme/adra_styles.dart';

class ActionFileButton extends StatelessWidget {
  final VoidCallback onTap;

  const ActionFileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AdraColors.cyanBlue,
          strokeWidth: 1.0,
          borderRadius: 6.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AdraColors.secondaryFixed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/ui/assets/images/icon/upload-regular.svg',
                height: 32,
                width: 32,
                color: AdraColors.primary,
              ),
              const SizedBox(height: 8),
              AdraText(
                text: R.string.addPublication,
                textSize: AdraTextSizeEnum.subheadlineW400,
                textStyleEnum: AdraTextStyleEnum.regular,
                adraStyles: AdraStyles.poppins,
                color: AdraColors.rootLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
