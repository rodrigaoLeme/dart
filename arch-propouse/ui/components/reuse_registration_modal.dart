import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/entities/form_verify/form_verify_entity.dart';
import '../helpers/i18n/resources.dart';
import 'components.dart';

class ReuseRegistrationModal extends StatelessWidget {
  final FormVerifyEntity? formVerifyEntity;
  final void Function(FormVerifyEntity? formVerifyEntity)? onReuse;

  const ReuseRegistrationModal({
    super.key,
    required this.formVerifyEntity,
    required this.onReuse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                'lib/ui/assets/images/icon/xmark-regular.svg',
                height: 20,
                width: 15,
                color: AdraColors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16),
          child: AdraText(
            text: R.string.reuseRegistrationLabel,
            adraStyles: AdraStyles.poppins,
            color: AdraColors.black,
            textSize: AdraTextSizeEnum.body,
            textStyleEnum: AdraTextStyleEnum.regular,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: formVerifyEntity?.dataFiltered?.length ?? 0,
          itemBuilder: (context, index) {
            final session = formVerifyEntity?.dataFiltered?[index];
            return Padding(
              padding:
                  const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdraText(
                    text: session?.questionText ?? '',
                    adraStyles: AdraStyles.poppins,
                    color: AdraColors.black,
                    textSize: AdraTextSizeEnum.headline,
                    textStyleEnum: AdraTextStyleEnum.bold,
                  ),
                  const SizedBox(height: 4),
                  AdraText(
                    text: session?.answer ?? '',
                    adraStyles: AdraStyles.poppins,
                    color: AdraColors.secundary,
                    textSize: AdraTextSizeEnum.subheadline,
                    textStyleEnum: AdraTextStyleEnum.regular,
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 117,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AdraColors.neutralHighMedium,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: AdraText(
                    text: R.string.cancel,
                    adraStyles: AdraStyles.poppins,
                    color: AdraColors.neutralLowMedium,
                    textSize: AdraTextSizeEnum.body,
                    textStyleEnum: AdraTextStyleEnum.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onReuse != null) {
                      onReuse!(formVerifyEntity);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AdraColors.primary,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: AdraText(
                      text: R.string.reuseRegistrationLabel,
                      adraStyles: AdraStyles.poppins,
                      color: AdraColors.white,
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void showReuseRegistrationActionSheet(
      BuildContext context,
      FormVerifyEntity? formVerifyEntity,
      void Function(FormVerifyEntity? formVerifyEntity)? onReuse) {
    showModalBottomSheet(
      backgroundColor: AdraColors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: SingleChildScrollView(
              child: ReuseRegistrationModal(
                formVerifyEntity: formVerifyEntity,
                onReuse: onReuse,
              ),
            ),
          ),
        );
      },
    );
  }
}
