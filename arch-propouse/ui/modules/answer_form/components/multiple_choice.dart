import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';
import '../../../helpers/extensions/string_extension.dart';

// ignore: must_be_immutable
class MultipleChoice extends StatefulWidget {
  QuestionViewModel? question;
  final void Function(String) onChanged;

  MultipleChoice({
    required this.question,
    required this.onChanged,
    super.key,
  });

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  final List<int> _selectedOptions = [];
  String fullAnswer = '';
  @override
  void initState() {
    final answers = widget.question?.answer?.trim().isEmpty ?? true
        ? null
        : widget.question?.answer?.split(',');
    answers?.asMap().forEach((index, value) {
      final safeIndex = int.tryParse(value);
      if (safeIndex != null) {
        _selectedOptions.add(safeIndex);
      }
    });
    _selectedOptions.sort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final optionsList = widget.question?.opcoes?.options?.entries.toList();
        fullAnswer = widget.question?.answer ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
              child: AdraText(
                text: (widget.question?.pergunta ?? '') +
                    (widget.question?.required == true ? ' *' : ''),
                textSize: AdraTextSizeEnum.callout,
                textStyleEnum: AdraTextStyleEnum.regular,
                color: AdraColors.black,
                adraStyles: AdraStyles.poppins,
              ),
            ),
            Column(
              children: List.generate(optionsList?.length ?? 0, (index) {
                final option = optionsList?[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _selectedOptions.contains(index),
                        onChanged: (bool? value) {
                          setState(() {
                            if (!_selectedOptions.contains(index)) {
                              _selectedOptions.add(index);
                            } else {
                              _selectedOptions.remove(index);
                            }
                            _selectedOptions.sort();
                          });
                          fullAnswer = fullAnswer
                              .addCommaSeparatedItem(option?.key ?? '');

                          widget.onChanged(fullAnswer);
                        },
                        activeColor: AdraColors.primary,
                        checkColor: AdraColors.white,
                        side: const BorderSide(
                          color: AdraColors.canvasColor,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AdraText(
                          text: option?.value.toString() ?? '',
                          textSize: AdraTextSizeEnum.subheadline,
                          textStyleEnum: AdraTextStyleEnum.regular,
                          color: AdraColors.black,
                          adraStyles: AdraStyles.poppins,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
