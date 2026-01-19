import 'package:flutter/material.dart';

import '../../components/adra_button.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import 'terms_use_presenter.dart';

class TermsUsePage extends StatefulWidget {
  final TermsUsePresenter presenter;

  const TermsUsePage({
    super.key,
    required this.presenter,
  });

  @override
  TermsUsePageState createState() => TermsUsePageState();
}

class TermsUsePageState extends State<TermsUsePage> with NavigationManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
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
                      text: R.string.termsOfUseUpdate,
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.bold,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: AdraText(
                      text:
                          'Lorem ipsum dolor sit amet consectetur. Malesuada sed gravida consectetur pellentesque nulla donec elit gravida velit. Morbi faucibus eu dui nibh laoreet risus mus proin gravida. Sapien egestas lorem at sed vulputate libero morbi. Natoque rhoncus ut elementum nulla enim mi platea scelerisque.',
                      textSize: AdraTextSizeEnum.subheadline,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.black,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
              child: AdraButton(
                onPressed: () {},
                title: R.string.accept,
                buttonColor: AdraColors.primary,
                borderRadius: 50.0,
                buttonHeigth: 52.0,
                titleColor: AdraColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // handleNavigation(widget.presenter.navigateToListener);
    super.initState();
  }
}
