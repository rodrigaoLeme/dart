import 'package:flutter/material.dart';

import '../components/components.dart';

mixin UISuccessManager {
  void handleMainSuccessMessage(BuildContext context, Stream<String?> stream) {
    stream.listen((error) {
      if (error != null) {
        showSuccessMessage(context, error);
      }
    });
  }
}
