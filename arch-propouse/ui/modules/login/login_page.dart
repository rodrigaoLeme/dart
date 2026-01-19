import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/account/logged_user.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({
    super.key,
    required this.presenter,
  });

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with LoadingManager, NavigationManager, UIErrorManager {
  @override
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToListener);
    handleMainError(context, widget.presenter.mainErrorStream);
    handleLoading(context, widget.presenter.isLoadingStream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      body: Column(
        children: [
          Container(
            height: 282,
            color: AdraColors.primary,
            child: Center(
              child: SvgPicture.asset(
                'lib/ui/assets/images/logo/adra_lg.svg',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16.0, top: 40.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 42.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdraText(
                        text: R.string.welcomeBack,
                        textSize: AdraTextSizeEnum.h4,
                        textStyleEnum: AdraTextStyleEnum.bold,
                        color: AdraColors.primary,
                        adraStyles: AdraStyles.poppins,
                      ),
                      AdraText(
                        text: R.string.loginCredentials,
                        textSize: AdraTextSizeEnum.subheadline,
                        textStyleEnum: AdraTextStyleEnum.regular,
                        color: AdraColors.cardColor,
                        adraStyles: AdraStyles.poppins,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      widget.presenter.socialAuth(ProviderLogin.google);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AdraColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/ui/assets/images/icon/google.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 24),
                          AdraText(
                            text: R.string.continueWithGoogle,
                            textSize: AdraTextSizeEnum.subheadline,
                            textStyleEnum: AdraTextStyleEnum.bold,
                            color: AdraColors.primary,
                            adraStyles: AdraStyles.poppins,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.presenter.socialAuth(ProviderLogin.microsoft);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AdraColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'lib/ui/assets/images/icon/microsoft.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 24),
                        AdraText(
                          text: R.string.continueWithMicrosoft,
                          textSize: AdraTextSizeEnum.subheadline,
                          textStyleEnum: AdraTextStyleEnum.bold,
                          color: AdraColors.primary,
                          adraStyles: AdraStyles.poppins,
                        ),
                      ],
                    ),
                  ),
                ),
                if (Platform.isIOS)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        widget.presenter.socialAuth(ProviderLogin.apple);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AdraColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.apple),
                            const SizedBox(width: 24),
                            AdraText(
                              text: R.string.continueWithApple,
                              textSize: AdraTextSizeEnum.subheadline,
                              textStyleEnum: AdraTextStyleEnum.bold,
                              color: AdraColors.primary,
                              adraStyles: AdraStyles.poppins,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
