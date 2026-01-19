import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/adra_text_field.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';

class LongText extends StatefulWidget {
  final QuestionViewModel? question;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const LongText({
    required this.question,
    required this.onChanged,
    this.controller,
    super.key,
  });

  @override
  State<LongText> createState() => _LongTextState();
}

class _LongTextState extends State<LongText> {
  TextEditingController? _internalController;
  TextEditingController? get _controller =>
      widget.controller ?? _internalController;
  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    if (_ownsController) {
      _internalController =
          TextEditingController(text: widget.question?.answer ?? '');
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LongText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza texto somente quando o valor do modelo realmente muda
    final newAnswer = widget.question?.answer ?? '';
    final oldAnswer = oldWidget.question?.answer ?? '';
    if (newAnswer != oldAnswer &&
        _controller != null &&
        _controller!.text != newAnswer) {
      _controller!.value = TextEditingValue(
        text: newAnswer,
        selection: TextSelection.collapsed(offset: newAnswer.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 16.0),
          child: AdraText(
            text: (widget.question?.pergunta ?? '') +
                (widget.question?.required == true ? ' *' : ''),
            textSize: AdraTextSizeEnum.callout,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.black,
            adraStyles: AdraStyles.poppins,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
          child: AdraTextField(
            // Evita recriar pelo valor; usa controller estável
            key: widget.question?.id != null
                ? ValueKey('long_text_${widget.question!.id}')
                : null,
            initialValue: null,
            controller: _controller,
            hint: '',
            icon: null,
            style: const TextStyle(color: AdraColors.weBlackLight),
            minLines: 3,
            maxLines: 5,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
