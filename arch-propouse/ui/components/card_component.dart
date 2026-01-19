import 'package:flutter/material.dart';

import 'components.dart';

class CardComponent extends StatelessWidget {
  final String label;
  final String email;
  final AdraTextSizeEnum textSize;
  final AdraTextStyleEnum textStyleEnum;
  final AdraTextSizeEnum emailTextSize;
  final AdraTextStyleEnum emailTextStyleEnum;
  final Color? iconColor;
  final Color? borderColor;
  final IconData? iconLeading;
  final double iconSize;
  final String? imageLeading;

  const CardComponent({
    super.key,
    required this.label,
    required this.email,
    required this.textSize,
    required this.textStyleEnum,
    required this.emailTextSize,
    required this.emailTextStyleEnum,
    this.iconColor,
    this.borderColor,
    this.iconLeading,
    required this.iconSize,
    this.imageLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AdraColors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: borderColor ?? AdraColors.greyLigth,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? Colors.transparent,
              ),
            ),
            child: imageLeading != null
                ? Image.asset(
                    imageLeading!,
                    width: iconSize,
                    height: iconSize,
                  )
                : Icon(
                    iconLeading,
                    color: iconColor,
                    size: iconSize,
                  ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdraText(
                text: label,
                textSize: textSize,
                textStyleEnum: textStyleEnum,
                color: AdraColors.weBlack,
                adraStyles: AdraStyles.poppins,
              ),
              const SizedBox(height: 4.0),
              AdraText(
                text: email,
                textSize: emailTextSize,
                textStyleEnum: emailTextStyleEnum,
                color: AdraColors.weBlackLight,
                adraStyles: AdraStyles.poppins,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
