import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../helpers/extensions/string_extension.dart';
import 'adra_colors.dart';

class AdraDatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? placeholder;
  final TextStyle? style;
  final Widget? iconLeading;
  final String? iconAsset;

  const AdraDatePickerField(
      {super.key,
      required this.onDateSelected,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      this.placeholder,
      this.style,
      this.iconLeading,
      this.iconAsset});

  @override
  State<AdraDatePickerField> createState() => _AdraDatePickerFieldState();
}

class _AdraDatePickerFieldState extends State<AdraDatePickerField> {
  DateTime? _selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _controller.text = _formatDate(_selectedDate!);
    }
  }

  @override
  void didUpdateWidget(covariant AdraDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se a data inicial mudar (ex.: reutilizar cadastro), sincroniza o campo.
    final oldDate = oldWidget.initialDate;
    final newDate = widget.initialDate;
    final changed =
        (oldDate?.millisecondsSinceEpoch != newDate?.millisecondsSinceEpoch);
    if (changed) {
      _selectedDate = newDate;
      if (newDate != null) {
        _controller.text = _formatDate(newDate);
      } else {
        _controller.clear();
      }
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(3100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      style: widget.style,
      decoration: InputDecoration(
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
        prefixIcon: widget.iconLeading,
        suffixIcon: widget.iconAsset == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  widget.iconAsset!,
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
            final formatted =
                _formatDate(newValue.text.toEnDate ?? DateTime.now());
            return TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          },
        ),
      ],
      onTap: () => _pickDate(context),
    );
  }
}
