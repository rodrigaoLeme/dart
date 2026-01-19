import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';
import 'enum/adra_size_enum.dart';
import 'theme/adra_styles.dart';

// ignore: must_be_immutable
class AdraText extends StatefulWidget {
  final String text;
  final TextOverflow? overflow;
  final int? maxLines;
  TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final AdraTextSizeEnum textSize;
  final AdraTextStyleEnum textStyleEnum;
  final Color? color;
  final AdraStyles adraStyles;

  AdraText({
    super.key,
    required this.text,
    this.overflow,
    this.maxLines,
    this.style,
    this.textAlign,
    this.softWrap,
    this.textSize = AdraTextSizeEnum.h1,
    this.textStyleEnum = AdraTextStyleEnum.regular,
    this.color,
    required this.adraStyles,
  }) {
    if (textStyleEnum == AdraTextStyleEnum.regular) {
      fontRegularStyleResolver(textSize, adraStyles);
    } else {
      fontBoldStyleResolver(textSize);
    }
  }

  @override
  State<AdraText> createState() => _AdraTextState();

  void fontRegularStyleResolver(
      AdraTextSizeEnum textSizeEnum, AdraStyles adraStyles) {
    switch (textSizeEnum) {
      case AdraTextSizeEnum.h1:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 32.0,
          letterSpacing: 0.37,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;

      case AdraTextSizeEnum.h2:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 24.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h3:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h3w5:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h4:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h4w500:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;

      case AdraTextSizeEnum.headline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.body:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.callout:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          letterSpacing: -0.32,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.subheadline:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: -0.24,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.footnote:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          letterSpacing: -0.08,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.caption1:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.caption2:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 10.0,
          letterSpacing: 0.07,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.handModel:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          letterSpacing: 0.07,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.subheadlineW400:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
    }
  }

  void fontBoldStyleResolver(AdraTextSizeEnum textSizeEnum) {
    switch (textSizeEnum) {
      case AdraTextSizeEnum.h1:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 32.0,
          letterSpacing: 0.37,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h2:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h3:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h3w5:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h4:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.h4w500:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.headline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.body:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.callout:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.32,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.subheadline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.subheadlineW400:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.footnote:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          letterSpacing: -0.08,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.caption1:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
      case AdraTextSizeEnum.caption2:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 10.0,
          letterSpacing: 0.06,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;

      case AdraTextSizeEnum.handModel:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 10.0,
          letterSpacing: 0.06,
          fontFamily: TypographyHelper.getFontFamily(adraStyles),
          color: color ?? AppColors.onSurface,
        );
        break;
    }
  }

  void styleStyleModifier({
    bool inherit = true,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? lineHeight,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? fontFamily,
    TextOverflow? overflow,
  }) {
    style = TextStyle(
      inherit: inherit,
      color: color ?? style?.color,
      backgroundColor: backgroundColor ?? style?.backgroundColor,
      fontSize: fontSize ?? style?.fontSize,
      fontWeight: fontWeight ?? style?.fontWeight,
      fontStyle: fontStyle ?? style?.fontStyle,
      letterSpacing: letterSpacing ?? style?.letterSpacing,
      wordSpacing: wordSpacing ?? style?.wordSpacing,
      textBaseline: textBaseline ?? style?.textBaseline,
      height: lineHeight ?? style?.height,
      locale: locale ?? style?.locale,
      foreground: foreground ?? style?.foreground,
      background: background ?? style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      fontVariations: style?.fontVariations,
      decoration: decoration ?? style?.decoration,
      decorationColor: decorationColor ?? style?.decorationColor,
      decorationStyle: decorationStyle ?? style?.decorationStyle,
      decorationThickness: decorationThickness ?? style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: fontFamily ?? style?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      overflow: overflow ?? style?.overflow,
    );
  }
}

class _AdraTextState extends State<AdraText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      style: widget.style,
      textAlign: widget.textAlign,
      softWrap: widget.softWrap,
    );
  }
}
