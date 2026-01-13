import 'package:bibleplan/appstyle.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  final bool onSurface;
  const AppThemeData({required this.onSurface});
}

class _AppTheme extends InheritedWidget {
  final AppTheme theme;

  const _AppTheme(this.theme, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return theme.onSurface != (oldWidget as _AppTheme?)?.theme.onSurface;
  }
}

class AppTheme extends StatelessWidget {
  final Widget child;
  final bool onSurface;
  const AppTheme({required this.child, this.onSurface = false, Key? key})
      : super(key: key);

  const AppTheme.surface({required this.child, Key? key})
      : onSurface = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var mode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    var theme = AppStyle.buildTheme(context, mode, onSurface: onSurface);

    return _AppTheme(
      this,
      AnimatedTheme(
        data: theme,
        child:
            DefaultTextStyle(style: theme.textTheme.bodyMedium!, child: child),
      ),
    );
  }

  static AppThemeData of(BuildContext context) {
    final _AppTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_AppTheme>();
    if (inheritedTheme == null) return const AppThemeData(onSurface: false);
    return AppThemeData(onSurface: inheritedTheme.theme.onSurface);
  }
}
