import 'package:flutter/material.dart';

import '../helpers/errors/ui_error.dart';
import 'components.dart';

class AdraTextField extends StatelessWidget {
  // Shared no-error notifier to avoid creating a new ValueNotifier on every build
  static final ValueNotifier<UIError?> _noError = ValueNotifier<UIError?>(null);
  final String hint;
  final Widget? icon;
  final TextStyle style;
  final Widget? iconLeading;
  final VoidCallback? onIconLeadingTap;
  final double? height;
  final ValueNotifier<UIError?>? error;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final BorderRadius? borderRadius;
  final int? minLines;
  final int? maxLines;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AdraTextField({
    super.key,
    required this.hint,
    this.icon,
    required this.style,
    this.iconLeading,
    this.onIconLeadingTap,
    this.height,
    this.error,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.minLines,
    this.maxLines,
    this.borderRadius,
    this.initialValue,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UIError?>(
      valueListenable: error ?? _noError,
      builder: (context, snapshot, _) {
        final hasError = snapshot?.description != null;

        final textField = TextFormField(
          controller: controller,
          // TextFormField does not allow using initialValue together with controller
          initialValue: controller == null ? initialValue : null,
          autocorrect: false,
          obscureText: obscureText,
          minLines: minLines,
          maxLines: maxLines ?? 1,
          expands: false,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: style,
            filled: true,
            fillColor: AdraColors.white,
            border: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                color: hasError ? AdraColors.error : AdraColors.canvasColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                color: hasError ? AdraColors.error : AdraColors.canvasColor,
              ),
            ),
            prefixIcon: iconLeading != null
                ? GestureDetector(
                    onTap: onIconLeadingTap,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: iconLeading,
                    ),
                  )
                : null,
            suffixIcon: icon != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: icon,
                  )
                : null,
          ),
          keyboardType: keyboardType ??
              (maxLines != null && maxLines! > 1
                  ? TextInputType.multiline
                  : TextInputType.text),
          onChanged: onChanged,
        );

        if (height != null) {
          return SizedBox(
            height: height,
            child: textField,
          );
        }
        return textField;
      },
    );
  }
}
