import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/components.dart';

class LinearScale extends StatefulWidget {
  final QuestionViewModel? question;
  final Function(String) onChanged;

  const LinearScale({
    required this.question,
    required this.onChanged,
    super.key,
  });

  @override
  LinearScaleState createState() => LinearScaleState();
}

class LinearScaleState extends State<LinearScale> {
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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: AdraText(
              text: (widget.question?.pergunta ?? '') +
                  (widget.question?.required == true ? ' *' : ''),
              textSize: AdraTextSizeEnum.callout,
              textStyleEnum: AdraTextStyleEnum.regular,
              color: AdraColors.black,
              adraStyles: AdraStyles.poppins,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(optionsList?.length ?? 0, (index) {
              final option = optionsList?[index];
              return Column(
                children: [
                  Text(
                    option?.value.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AdraColors.globalTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Transform.scale(
                    scale: 1.1,
                    child: Radio<int>(
                      value: index,
                      groupValue: _selectedOption,
                      onChanged: (int? value) {
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
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      visualDensity: const VisualDensity(horizontal: -4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      );
    });
  }
}
