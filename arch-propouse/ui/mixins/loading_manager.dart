import 'package:flutter/material.dart';

import '../../presentation/mixins/loading_manager.dart';
import '../components/components.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, Stream<LoadingData?> stream) {
    stream.listen((value) async {
      if (!context.mounted) return;
      if (value != null && value.isLoading == true) {
        await showLoading(context, value);
      } else {
        hideLoading(context);
      }
    });
  }
}
