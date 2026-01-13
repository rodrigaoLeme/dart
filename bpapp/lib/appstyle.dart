// ignore_for_file: deprecated_member_use

import 'package:bibleplan/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;
  final Color navigationBarColor;
  final Brightness brightness;

  static const AppPalette light = AppPalette._light();
  static const AppPalette dark = AppPalette._dark();

  const AppPalette._light()
      : primary = const Color(0xFF306284),
        primaryVariant = const Color(0xFF0B5773),
        secondary = const Color(0xFFEFEFEF),
        secondaryVariant = const Color(0xFF6B6B6B),
        background = const Color(0xFFFFFFFF),
        surface = const Color(0xFF306284),
        error = const Color(0xFFFF0000),
        onPrimary = const Color(0xFFFFFFFF),
        onSecondary = const Color(0xFFFFFFFF),
        onBackground = const Color(0xFF001C38),
        onSurface = const Color(0xFFFFFFFF),
        onError = const Color(0xFFFFFFFF),
        navigationBarColor = const Color(0xFFFFFFFF),
        brightness = Brightness.light;

  const AppPalette._dark()
      : primary = const Color(0xFF57A5BF),
        primaryVariant = const Color(0xFF0B5773),
        secondary = const Color(0xFF2B2B2B),
        secondaryVariant = const Color(0xFF2B2B2B),
        background = const Color(0xFF121212),
        surface = const Color(0xFF57A5BF),
        error = const Color(0xFFFF0000),
        onPrimary = const Color(0xFF001326),
        onSecondary = const Color(0xFFFFFFFF),
        onBackground = const Color(0xFFDDDDDE),
        onSurface = const Color(0xFF121212),
        onError = const Color(0xFFFFFFFF),
        navigationBarColor = const Color(0xFF222222),
        brightness = Brightness.dark;
}

class AppStyle {
  static AppPalette _palette = AppPalette.light;
  static AppPalette get palette => _palette;

  static Color get primaryColor => palette.primary;
  static Color get primaryVariant => palette.primaryVariant;
  static Color get secondaryColor => palette.secondary;
  static Color get secondaryVariant => palette.secondaryVariant;
  static Color get backgroundColor => palette.background;
  static Color get onPrimaryColor => palette.onPrimary;
  static Color get onSecondaryColor => palette.onSecondary;
  static Color get onBackgroundColor => palette.onBackground;

  static final List<List<Color>> shareColors = [
    [const Color(0xFFEEEEEE), const Color(0xFFEEEEEE)],
    ...highlightColors.map((e) => [e, e]),
    [const Color(0xFFFAF28F), const Color(0xFFFB7C7C)],
    [const Color(0xFF96E2FF), const Color(0xFF69DDA7)],
    [const Color(0xFFFFF467), const Color(0xFF69DDA7)],
    [const Color(0xFFFFBFBF), const Color(0xFF96E2FF)],
  ];

  static TextStyle fancyFont = GoogleFonts.merriweather();
  static const double defaultMargin = 16.0;
  static const double tinyMargin = 8.0;
  static const double bigMargin = 32.0;

  static const List<Color> highlightColors = [
    Color(0xFFFFBFBF),
    Color(0xFF96E2FF),
    Color(0xFFFAF28F),
    Color(0xFF69DDA7)
  ];

  static const double roundedCorner = 14.0;

  static void setStyle(Brightness brightness) => _palette =
      brightness == Brightness.light ? AppPalette.light : AppPalette.dark;

  AppStyle._();

  static Color _foregroundColor(ThemeMode mode, {bool onSurface = false}) {
    var palette = mode == ThemeMode.light ? AppPalette.light : AppPalette.dark;
    return onSurface ? palette.onSurface : palette.onBackground;
  }

  static TextTheme _textTheme(ThemeMode mode, {bool onSurface = false}) {
    return GoogleFonts.robotoTextTheme().merge(TextTheme(
      bodySmall: TextStyle(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontWeight: FontWeight.bold,
          fontSize: 16),
      bodyMedium:
          TextStyle(color: _foregroundColor(mode, onSurface: onSurface)),
      displayLarge: GoogleFonts.merriweather(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontSize: 48,
          fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.merriweather(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontSize: 32,
          fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.merriweather(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.merriweather(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontSize: 16,
          fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: _foregroundColor(mode, onSurface: onSurface),
          fontWeight: FontWeight.bold),
    ));
  }

  static ColorScheme _buildScheme(ThemeMode mode) {
    AppPalette palette =
        mode == ThemeMode.light ? AppPalette.light : AppPalette.dark;

    return ColorScheme(
      primary: palette.primary,
      secondary: palette.secondary,
      surface: palette.surface,
      error: palette.error,
      onPrimary: palette.onPrimary,
      onSecondary: palette.onSecondary,
      onSurface: palette.onSurface,
      onError: palette.onError,
      brightness: palette.brightness,
      surfaceContainerHighest: palette.surface,
    );
  }

  static ThemeData buildTheme(BuildContext context, ThemeMode mode,
      {bool onSurface = false}) {
    var palette = mode == ThemeMode.light ? AppPalette.light : AppPalette.dark;
    var scheme = _buildScheme(mode);

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      textTheme: _textTheme(mode, onSurface: onSurface),
      primaryTextTheme: _textTheme(mode, onSurface: onSurface),
      iconTheme:
          IconThemeData(color: onSurface ? scheme.onSurface : scheme.secondary),
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: palette.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.navigationBarColor,
        foregroundColor: palette.primary,
        elevation: 2,
      ),
      dividerTheme: DividerThemeData(
          thickness: 1, color: scheme.onSurface.withAlpha(30), space: 0),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: palette.primary,
            textStyle: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
