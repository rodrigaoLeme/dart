import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/adra_button.dart';
import '../../components/adra_data_picker.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import 'cpf_login_presenter.dart';

class CpfLoginPage extends StatefulWidget {
  final CpfLoginPresenter presenter;

  const CpfLoginPage({
    super.key,
    required this.presenter,
  });

  @override
  CpfLoginPageState createState() => CpfLoginPageState();
}

class CpfLoginPageState extends State<CpfLoginPage>
    with NavigationManager, LoadingManager, UIErrorManager {
  String? cpf;
  String? birthday;

  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToListener);
    handleLoading(context, widget.presenter.isLoadingStream);
    handleMainError(context, widget.presenter.mainErrorStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      appBar: AppBar(
        backgroundColor: AdraColors.primary,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back,
            color: AdraColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AdraText(
                      text: R.string.firstAccess,
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.bold,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: AdraText(
                      text: R.string.documentClientHintText,
                      textSize: AdraTextSizeEnum.subheadline,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                  AdraTextField(
                    hint: '',
                    icon: null,
                    style: const TextStyle(
                      color: AdraColors.weBlackLight,
                    ),
                    onChanged: (p0) {
                      cpf = p0;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: AdraText(
                      text: R.string.dateBirth,
                      textSize: AdraTextSizeEnum.subheadline,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                  AdraDatePickerField(
                    style: const TextStyle(
                      color: AdraColors.weBlackLight,
                    ),
                    placeholder: R.string.dateBirth,
                    onDateSelected: (DateTime date) {
                      setState(() {
                        birthday = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AdraColors.neutralLowMedium,
                ),
                children: [
                  TextSpan(
                    text: R.string.termsConditions,
                  ),
                  TextSpan(
                    text: R.string.privacyPolicy,
                    style: const TextStyle(
                      color: AdraColors.primary,
                      decoration: TextDecoration.none,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        widget.presenter.goToTerms();
                      },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
              child: Builder(builder: (context) {
                final isValid = (cpf != null && cpf!.trim().isNotEmpty) &&
                    (birthday != null && birthday!.trim().isNotEmpty);
                return AdraButton(
                  onPressed: isValid
                      ? () {
                          widget.presenter.socialAuth(
                            document: cpf?.trim(),
                            birthday: birthday?.trim(),
                          );
                        }
                      : null,
                  title: R.string.continueLabel,
                  buttonColor: AdraColors.primary,
                  borderRadius: 50.0,
                  buttonHeigth: 52.0,
                  titleColor: AdraColors.white,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
