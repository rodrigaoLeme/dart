import 'package:flutter/material.dart';

class CepInformationExpansionItem extends StatelessWidget {
  const CepInformationExpansionItem(
      {super.key, required this.label, required this.content});

  final String label;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: style,
        ),
        const Spacer(),
        Expanded(
          child: Text(
            _getContent(),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  final TextStyle style = const TextStyle(fontWeight: FontWeight.bold);

  String _getContent() {
    if (content == null || content!.isEmpty) {
      return 'N/A';
    }

    return content!;
  }
}
