import 'dart:async';

mixin LoadingManager {
  final StreamController<LoadingData> _isLoadingStreamController =
      StreamController<LoadingData>.broadcast();

  Stream<LoadingData> get isLoadingStream => _isLoadingStreamController.stream;
  set isLoading(LoadingData value) =>
      _isLoadingStreamController.sink.add(value);
}

class LoadingData {
  bool isLoading;
  LoadingStyle style;

  LoadingData({
    required this.isLoading,
    this.style = LoadingStyle.light,
  });
}

enum LoadingStyle {
  primary,
  light,
  none,
}
