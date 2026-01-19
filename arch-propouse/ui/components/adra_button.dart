import 'package:flutter/material.dart';

class AdraButton extends StatelessWidget {
  final Function()? onPressed;
  final String? title;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final Color? buttonColor;
  final double? borderRadius;
  final double? buttonHeigth;
  final Color? disableButtonColor;
  final Color? titleColor;
  final double? prefixSpacing;

  const AdraButton({
    super.key,
    required this.onPressed,
    this.title,
    this.prefixIcon,
    this.sufixIcon,
    this.buttonColor,
    this.borderRadius,
    this.buttonHeigth,
    this.disableButtonColor,
    this.titleColor,
    this.prefixSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final isFormValid = onPressed != null;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size.fromHeight(buttonHeigth ?? 0),
        backgroundColor: buttonColor,
        disabledBackgroundColor: disableButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixIcon ?? const SizedBox.shrink(),
          if (prefixIcon != null) SizedBox(width: prefixSpacing ?? 8.0),
          Text(
            title ?? '',
            style: TextStyle(
              color: isFormValid ? titleColor : titleColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (sufixIcon != null) const SizedBox(width: 4.0),
          sufixIcon ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
