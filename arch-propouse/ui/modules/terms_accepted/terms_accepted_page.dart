import 'package:flutter/material.dart';

import '../../../presentation/presenters/terms/terms_view_model.dart';
import '../../components/adra_button.dart';
import '../../components/components.dart';
import '../../components/html_view_page.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import 'terms_accepted_presenter.dart';

class TermsAcceptedPage extends StatefulWidget {
  final TermsAcceptedPresenter presenter;

  const TermsAcceptedPage({
    super.key,
    required this.presenter,
  });

  @override
  TermsAcceptedPageState createState() => TermsAcceptedPageState();
}

class TermsAcceptedPageState extends State<TermsAcceptedPage>
    with NavigationManager, UIErrorManager, LoadingManager {
  @override
  void initState() {
    handleMainError(context, widget.presenter.mainErrorStream);
    handleNavigation(widget.presenter.navigateToListener);
    handleLoading(context, widget.presenter.isLoadingStream);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      appBar: AppBar(
        backgroundColor: AdraColors.primary,
      ),
      body: Builder(builder: (context) {
        widget.presenter.fetchTerms();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<TermsViewModel?>(
            stream: widget.presenter.termsViewModel,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: AdraText(
                              text: R.string.termsUse,
                              textSize: AdraTextSizeEnum.h3,
                              textStyleEnum: AdraTextStyleEnum.bold,
                              color: AdraColors.black,
                              adraStyles: AdraStyles.poppins,
                            ),
                          ),
                          CustomHtml(
                            htmlData: snapshot.data?.data?.term ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                    child: AdraButton(
                      onPressed: widget.presenter.acceptTerms,
                      title: R.string.accept,
                      buttonColor: AdraColors.primary,
                      borderRadius: 50.0,
                      buttonHeigth: 52.0,
                      titleColor: AdraColors.white,
                    ),
                  )
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
