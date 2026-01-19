import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adra_colors.dart';

class DateInputPlaceholder extends StatefulWidget {
  final String hint;
  final String iconAsset;
  final TextStyle style;
  final TextEditingController? controller;
  final Widget? iconLeading;
  final VoidCallback? onIconLeadingTap;
  final double? height;

  const DateInputPlaceholder({
    super.key,
    required this.hint,
    required this.iconAsset,
    required this.style,
    this.controller,
    this.iconLeading,
    this.onIconLeadingTap,
    this.height,
  });

  @override
  State<DateInputPlaceholder> createState() => _DateInputPlaceholderState();
}

class _DateInputPlaceholderState extends State<DateInputPlaceholder> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _formatDate(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      style: widget.style,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.style,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: AdraColors.neutralHighMedium),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: AdraColors.neutralHighMedium),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        prefixIcon: widget.iconLeading != null
            ? GestureDetector(
                onTap: widget.onIconLeadingTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.iconLeading,
                ),
              )
            : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            widget.iconAsset,
            width: 14,
            height: 16,
            color: AdraColors.secundary,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            final formatted = _formatDate(newValue.text);
            return TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          },
        ),
      ],
    );
  }
}
