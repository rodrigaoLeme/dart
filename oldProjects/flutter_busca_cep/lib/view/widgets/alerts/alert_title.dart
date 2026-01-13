import 'package:flutter/material.dart';

class AlertTitle extends StatelessWidget {
  const AlertTitle({super.key, required this.prefixIcon, required this.title});

  final Widget prefixIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        prefixIcon,
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
