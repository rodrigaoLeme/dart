import 'dart:async';

mixin UIErrorManager {
  final StreamController<String?> _mainErrorController =
      StreamController<String?>.broadcast();
  Stream<String?> get mainErrorStream => _mainErrorController.stream;
  set mainError(String? value) => _mainErrorController.sink.add(value);
}
