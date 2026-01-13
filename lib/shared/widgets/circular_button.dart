import 'package:bibleplan/common.dart';
//import 'package:flutter/material.dart';

enum CircularButtonType {
  primary,
  accent,
  alt,
  accentAlt,
}

class CircularButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPressed;
  final CircularButtonType type;
  final String? label;
  final TextStyle? labelStyle;
  final double labelSpacing;
  final double? diameter;

  const CircularButton(
      {Key? key,
      this.child,
      required this.onPressed,
      this.type = CircularButtonType.primary,
      this.label,
      this.labelStyle,
      this.diameter,
      this.labelSpacing = 5})
      : super(key: key);

  const CircularButton.alt(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.label,
      this.labelStyle,
      this.diameter,
      this.labelSpacing = 5})
      : type = CircularButtonType.alt,
        super(key: key);

  const CircularButton.accent(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.label,
      this.labelStyle,
      this.diameter,
      this.labelSpacing = 5})
      : type = CircularButtonType.accent,
        super(key: key);

  const CircularButton.accentAlt(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.label,
      this.labelStyle,
      this.diameter,
      this.labelSpacing = 5})
      : type = CircularButtonType.accentAlt,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var scheme = AppStyle.palette;
    var onSurface = AppTheme.of(context).onSurface;

    Color color;
    Color foreground;

    switch (type) {
      case CircularButtonType.accentAlt:
        color = onSurface ? scheme.secondaryVariant : scheme.primaryVariant;
        foreground = onSurface ? scheme.onSecondary : scheme.onPrimary;
        break;
      case CircularButtonType.alt:
        color = onSurface ? scheme.primaryVariant : scheme.secondaryVariant;
        foreground = onSurface ? scheme.onPrimary : scheme.onSecondary;
        break;
      case CircularButtonType.accent:
        color = onSurface ? scheme.primary : scheme.secondary;
        foreground = onSurface ? scheme.onPrimary : scheme.primary;
        break;
      default:
        color = onSurface ? scheme.secondary : scheme.primary;
        foreground = onSurface ? scheme.primary : scheme.onPrimary;
        break;
    }

    Widget result = TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: foreground),
        backgroundColor: color,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: foreground),
        child: IconTheme(
          data: IconThemeData(color: foreground),
          child: child ?? Container(),
        ),
      ),
    );

    if (diameter != null) {
      result = SizedBox(width: diameter, height: diameter, child: result);
    }

    if (label != null) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          result,
          VSpacer(labelSpacing),
          Txt(
            label!,
            style: labelStyle,
            align: TextAlign.center,
          )
        ],
      );
    }

    return result;
  }
}
