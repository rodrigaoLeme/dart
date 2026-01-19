import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'adra_colors.dart';

class AdraTimePickerField extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? placeholder;
  final TextStyle? style;
  final Widget? iconLeading;
  final String? iconAsset;

  const AdraTimePickerField({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    this.placeholder,
    this.style,
    this.iconLeading,
    this.iconAsset,
  });

  @override
  State<AdraTimePickerField> createState() => _AdraTimePickerFieldState();
}

class _AdraTimePickerFieldState extends State<AdraTimePickerField> {
  TimeOfDay? _selectedTime;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    if (_selectedTime != null) {
      _controller.text = _formatTime(_selectedTime!);
    }
  }

  @override
  void didUpdateWidget(covariant AdraTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldT = oldWidget.initialTime;
    final newT = widget.initialTime;
    final changed = oldT?.hour != newT?.hour || oldT?.minute != newT?.minute;
    if (changed) {
      _selectedTime = newT;
      if (newT != null) {
        _controller.text = _formatTime(newT);
      } else {
        _controller.clear();
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: const Locale('pt', 'BR'),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime(picked);
      });
      widget.onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      style: widget.style,
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Selecione o horário',
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
        suffixIcon: widget.iconAsset != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  widget.iconAsset!,
                  width: 14,
                  height: 16,
                  color: AdraColors.secundary,
                ),
              )
            : null,
      ),
      onTap: () => _pickTime(context),
    );
  }
}
