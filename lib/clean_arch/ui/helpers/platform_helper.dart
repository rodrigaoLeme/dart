import 'dart:io';

class PlatformHelper {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static bool get isAppleSignInAvailable => isIOS;
}
