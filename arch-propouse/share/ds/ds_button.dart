import 'package:flutter/material.dart';

class DSButton extends StatelessWidget {
  final String label;
  final FontWeight? labelWeight;
  final Color? labelColor, backgroundColor;
  final Function()? onPressed;
  final EdgeInsetsGeometry? margin, padding;
  const DSButton({
    super.key,
    required this.label,
    this.labelWeight,
    this.labelColor,
    this.backgroundColor,
    this.onPressed,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontWeight: labelWeight,
          ),
        ),
      ),
    );
  }
}
