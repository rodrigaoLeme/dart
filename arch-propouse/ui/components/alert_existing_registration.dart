import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/entities/form_verify/form_verify_entity.dart';
import '../helpers/i18n/resources.dart';
import 'components.dart';
import 'reuse_registration_modal.dart';

class AlertExistingRegistration extends StatelessWidget {
  final FormVerifyEntity? formVerifyEntity;
  final Function(FormVerifyEntity? formVerifyEntity)? onReuse;
  const AlertExistingRegistration({
    super.key,
    required this.formVerifyEntity,
    required this.onReuse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color: AdraColors.pastelOrangeColor.withAlpha(60),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            'lib/ui/assets/images/icon/exclamation-triangle.svg',
            width: 14,
            height: 14,
            color: AdraColors.orangeColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AdraText(
              text: R.string.alreadyExistingLabel,
              color: AdraColors.orangeColor,
              textSize: AdraTextSizeEnum.subheadline,
              textStyleEnum: AdraTextStyleEnum.regular,
              adraStyles: AdraStyles.poppins,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AdraColors.orangeWarningColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
            onPressed: () {
              ReuseRegistrationModal.showReuseRegistrationActionSheet(
                context,
                formVerifyEntity,
                onReuse,
              );
            },
            child: AdraText(
              text: R.string.viewRegistration,
              color: AdraColors.white,
              textSize: AdraTextSizeEnum.subheadline,
              textStyleEnum: AdraTextStyleEnum.bold,
              adraStyles: AdraStyles.poppins,
            ),
          )
        ],
      ),
    );
  }
}
