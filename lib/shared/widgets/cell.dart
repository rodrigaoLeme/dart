import 'package:bibleplan/common.dart';

class Cell extends StatelessWidget {
  final Widget child;
  final Widget? accessory;
  final Widget? prefix;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double prefixSpacing;
  final double minHeight;

  const Cell(
      {Key? key,
      required this.child,
      this.accessory,
      this.prefix,
      this.onPressed,
      this.padding = const EdgeInsets.all(16),
      this.prefixSpacing = 16,
      this.minHeight = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefix != null) prefix!,
            if (prefix != null && prefixSpacing > 0)
              SizedBox(width: prefixSpacing),
            child,
            const Spacer(),
            if (accessory != null) accessory!,
          ],
        ),
      ),
    );

    if (onPressed != null) widget = InkWell(child: widget, onTap: onPressed!);

    return widget;
  }
}
