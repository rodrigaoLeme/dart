import 'package:flutter/material.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_data_picker.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';
import '../../../helpers/extensions/date_formater_extension.dart';
import '../../../helpers/extensions/string_extension.dart';

class SelectDate extends StatelessWidget {
  final QuestionViewModel? question;
  final Function(String) onDateSelected;
  const SelectDate({
    super.key,
    required this.question,
    required this.onDateSelected,
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
          child: AdraDatePickerField(
            iconAsset: 'lib/ui/assets/images/icon/calendar-regular.svg',
            style: const TextStyle(color: AdraColors.weBlackLight),
            // Se não houver resposta, não pré-popular com hoje; deixa nulo para refletir fielmente o modelo
            initialDate: question?.answer?.toEnDate,
            onDateSelected: (date) {
              onDateSelected(date.dayToStringEn);
            },
          ),
        ),
      ],
    );
  }
}
