import 'package:flutter/material.dart';

import '../../../components/components.dart';

class FormsDetailsErrorWidget extends StatelessWidget {
  final String? message;
  final Object? error;
  final VoidCallback onRetry;

  const FormsDetailsErrorWidget({
    super.key,
    this.message,
    this.error,
    required this.onRetry,
  });

  String _resolveMessage() {
    if (message != null && message!.isNotEmpty) return message!;
    if (error != null && error.toString().isNotEmpty) {
      return error.toString();
    }
    return 'Ocorreu um erro ao carregar os detalhes do formulário.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AdraColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              _resolveMessage(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
