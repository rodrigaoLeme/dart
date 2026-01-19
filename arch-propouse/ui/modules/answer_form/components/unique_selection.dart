import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';

class UniqueSelection extends StatefulWidget {
  final QuestionViewModel? question;
  final void Function(String) onChanged;
  const UniqueSelection({
    required this.question,
    required this.onChanged,
    super.key,
  });

  @override
  State<UniqueSelection> createState() => _UniqueSelectionState();
}

class _UniqueSelectionState extends State<UniqueSelection> {
  int? _selectedOption;

  @override
  void initState() {
    final optionsList = widget.question?.opcoes?.options?.entries.toList();
    _selectedOption = optionsList
        ?.indexWhere((element) => element.key == widget.question?.answer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final optionsList = widget.question?.opcoes?.options?.entries.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(optionsList?.length ?? 0, (index) {
              final option = optionsList?[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Radio<int>(
                        value: index,
                        groupValue: _selectedOption,
                        onChanged: (int? value) {
                          if (value == _selectedOption) return;
                          setState(() {
                            _selectedOption = value;
                          });
                          widget.onChanged(option?.key ?? '');
                        },
                        activeColor: AdraColors.primary,
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AdraColors.primary;
                            }
                            return AdraColors.canvasColor;
                          },
                        ),
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        visualDensity: const VisualDensity(horizontal: -4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AdraText(
                      text: option?.value.toString() ?? '',
                      textSize: AdraTextSizeEnum.subheadline,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
