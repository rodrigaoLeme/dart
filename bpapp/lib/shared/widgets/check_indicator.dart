import 'package:flutter/material.dart';

class CheckIndicator extends StatelessWidget {
  final bool value;
  final EdgeInsetsGeometry margin;
  const CheckIndicator({Key? key, required this.value, this.margin = const EdgeInsets.all(8)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Icon(
        value ? Icons.check_box_rounded : Icons.check_box_outline_blank ,
      ),
    );
  }
}
