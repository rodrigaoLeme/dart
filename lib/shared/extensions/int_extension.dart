extension IntExtensions on int {
  String zeroPadded([int width = 2]) => toString().padLeft(width, "0");
  double toMB() => this / (1024 * 1024);
}
