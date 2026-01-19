import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class ResponsiveLayout {
  final double width, height, inch;

  ResponsiveLayout({
    required this.width,
    required this.height,
    required this.inch,
  });

  factory ResponsiveLayout.of(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final size = data.size;
    // c2 = a2+b2 => c = sqrt(a2+b2)
    final inch = math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2));
    return ResponsiveLayout(width: size.width, height: size.height, inch: inch);
  }

  double wp(double percent) {
    return width * percent / 100;
  }

  double hp(double percent) {
    return height * percent / 100;
  }

  double ip(double percent) {
    return inch * percent / 100;
  }

  bool get isIpad {
    return width >= 600;
  }
}
