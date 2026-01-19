import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InitialName extends StatelessWidget {
  final String text;
  TextStyle textStyle;
  Color? color;

  InitialName({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.0,
      height: 46.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Theme.of(context).focusColor,
      ),
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
