import 'package:flutter/material.dart';

import '../../../../domain/entities/form_verify/form_verify_entity.dart';
import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/adra_text_field.dart';
import '../../../components/alert_existing_registration.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';

class ShortText extends StatefulWidget {
  final QuestionViewModel? question;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Function(String)? onEndEditing;
  final FormVerifyEntity? formVerifyEntity;
  final Function(FormVerifyEntity? formVerifyEntity)? onReuse;

  const ShortText({
    required this.question,
    required this.onChanged,
    super.key,
    this.controller,
    this.onEndEditing,
    this.formVerifyEntity,
    this.onReuse,
  });

  @override
  State<ShortText> createState() => _ShortTextState();
}

class _ShortTextState extends State<ShortText> {
  final focusNode = FocusNode();
  bool isEdit = false;
  String currentValue = '';
  TextEditingController? _internalController;
  TextEditingController? get _controller =>
      widget.controller ?? _internalController;
  bool get _ownsController => widget.controller == null;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () {
        if (!focusNode.hasFocus) {
          // Ao perder o foco, consideramos que a edição terminou.
          // Isso permite que atualizações programáticas (ex: reload/navegação)
          // sincronizem o controller com o modelo novamente.
          if (isEdit) {
            if (widget.onEndEditing != null &&
                widget.question?.identificador == true) {
              widget.onEndEditing!(currentValue);
            }
            isEdit = false;
          }
        }
      },
    );
    if (_ownsController) {
      _internalController =
          TextEditingController(text: widget.question?.answer ?? '');
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (_ownsController) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShortText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newAnswer = widget.question?.answer ?? '';
    final oldAnswer = oldWidget.question?.answer ?? '';
    final textChangedInModel = newAnswer != oldAnswer;
    if (textChangedInModel &&
        _controller != null &&
        _controller!.text != newAnswer) {
      final questionChanged = oldWidget.question?.id != widget.question?.id;
      if (!isEdit || questionChanged) {
        _controller!.value = TextEditingValue(
          text: newAnswer,
          selection: TextSelection.collapsed(offset: newAnswer.length),
        );
        currentValue = newAnswer;
        isEdit = false; // programmatic change
      }
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
            // Não usar chave baseada no valor atual para evitar recriar o campo durante digitação
            key: widget.question?.id != null
                ? ValueKey('short_text_${widget.question!.id}')
                : null,
            controller: _controller,
            // initialValue não é necessário quando usamos controller
            initialValue: null,
            hint: '',
            icon: null,
            style: const TextStyle(color: AdraColors.weBlackLight),
            onChanged: (value) {
              currentValue = value;
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              isEdit = true;
            },
            focusNode: focusNode,
          ),
        ),
        if (widget.question?.identificador == true &&
            widget.formVerifyEntity?.data?.isEmpty == false)
          AlertExistingRegistration(
            formVerifyEntity: widget.formVerifyEntity,
            onReuse: widget.onReuse,
          ),
      ],
    );
  }
}
