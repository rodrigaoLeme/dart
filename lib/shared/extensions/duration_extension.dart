import 'int_extension.dart';

extension DurationExtensions on Duration {
  String toTimeString() {
    StringBuffer buffer = StringBuffer();

    int seconds = inSeconds;
    int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    if (hours > 0) {
      buffer.write(hours.zeroPadded());
      buffer.write(":");
    }

    buffer.write("${minutes.zeroPadded()}:");
    buffer.write(seconds.zeroPadded());

    return buffer.toString();
  }
}
