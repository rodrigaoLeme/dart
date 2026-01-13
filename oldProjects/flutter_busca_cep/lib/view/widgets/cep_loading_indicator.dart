import 'package:flutter/material.dart';

class CepLoadingIndicator extends StatelessWidget {
  const CepLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(width: 310, child: LinearProgressIndicator()),
    );
  }
}
