import 'package:flutter/material.dart';

import '../components/components.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<String?> stream) {
    stream.listen((error) {
      if (error != null && context.mounted) {
        showErrorMessage(context, error);
      }
    });
  }
}
