import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/adra_time_picker.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';
import '../../../helpers/extensions/string_extension.dart';

class SelectTime extends StatelessWidget {
  final QuestionViewModel? question;
  final Function(TimeOfDay) onTimeSelected;

  const SelectTime({
    super.key,
    required this.question,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdraText(
          text: (question?.pergunta ?? '') +
              (question?.required == true ? ' *' : ''),
          textSize: AdraTextSizeEnum.subheadline,
          textStyleEnum: AdraTextStyleEnum.regular,
          color: AdraColors.black,
          adraStyles: AdraStyles.poppins,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 16.0),
          child: AdraTimePickerField(
            initialTime: question?.answer?.stringToTimeOfDay(),
            iconAsset: 'lib/ui/assets/images/icon/clock-regular.svg',
            style: const TextStyle(color: AdraColors.weBlackLight),
            onTimeSelected: (timeOfDay) {
              onTimeSelected(timeOfDay);
            },
          ),
        ),
      ],
    );
  }
}
