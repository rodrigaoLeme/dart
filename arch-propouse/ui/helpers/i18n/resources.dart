import 'package:flutter/widgets.dart';

import './strings/strings.dart';

class R {
  static Translation string = Us();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        string = Us();
        break;
    }
  }
}
