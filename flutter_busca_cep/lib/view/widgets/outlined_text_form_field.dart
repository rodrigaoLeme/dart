import 'package:flutter/material.dart';
import 'package:flutter_desafio_via_cep/view/widgets/custom_text_form_field.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField(
      {super.key,
      this.initialValue,
      this.hintText,
      this.onChanged,
      this.controller,
      this.keyboardType});

  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary));

    return CustomTextFormField(
      initialValue: initialValue,
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
