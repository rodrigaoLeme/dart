//import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/common.dart';

class RoundedButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final Color? color;
  final TextStyle? textStyle;
  final double cornerRadius;
  final EdgeInsetsGeometry padding;

  const RoundedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.color,
      this.textStyle,
      this.cornerRadius = 40,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)})
      : super(key: key);

  RoundedButton.text(String text,
      {Key? key,
      required this.onPressed,
      this.color,
      this.textStyle,
      this.cornerRadius = 40,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)})
      : child = Txt(text),
        super(key: key);

  RoundedButton.secondary(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.cornerRadius = 40,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)})
      : color = AppStyle.secondaryColor,
        textStyle = TextStyle(color: AppStyle.primaryColor),
        super(key: key);

  RoundedButton.textSecondary(String text,
      {Key? key,
      required this.onPressed,
      this.cornerRadius = 40,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)})
      : child = Txt(text),
        color = AppStyle.secondaryColor,
        textStyle = TextStyle(color: AppStyle.onBackgroundColor),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        padding: padding,
        backgroundColor: color ?? AppStyle.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: textStyle ??
            TextStyle(color: AppStyle.onPrimaryColor, fontSize: 16),
        child: child,
      ),
    );
  }
}
