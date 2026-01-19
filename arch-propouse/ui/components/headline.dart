import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const Headline({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          overflow: overflow,
        ),
        softWrap: softWrap);
  }
}
