import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ListEmptyRegister extends StatelessWidget {
  final String text;

  const ListEmptyRegister({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 180,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: AdraColors.cyanBlue,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Center(
            child: AdraText(
              text: text,
              textSize: AdraTextSizeEnum.h2,
              textStyleEnum: AdraTextStyleEnum.regular,
              color: AdraColors.secundary,
              adraStyles: AdraStyles.poppins,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
