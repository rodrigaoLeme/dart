import 'dart:async';

mixin FormManager {
  final StreamController<bool> _isFormValidController =
      StreamController<bool>.broadcast();
  set isFormValid(bool value) => _isFormValidController.sink.add(value);
  Stream<bool> get isFormValidStream => _isFormValidController.stream;
}
