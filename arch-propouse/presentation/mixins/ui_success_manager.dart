import 'dart:async';

import '../../ui/helpers/helpers.dart';

mixin UISuccessManager {
  final StreamController<UIError?> _mainSuccessController =
      StreamController<UIError?>.broadcast();
  Stream<UIError?> get mainSuccessStream => _mainSuccessController.stream;
  set mainSuccess(UIError? value) => _mainSuccessController.sink.add(value);
}
