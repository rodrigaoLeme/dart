import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../presentation/presenters/status/status_view_model.dart';
import '../../components/adra_button.dart';
import '../../components/card_status.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import 'status_presenter.dart';

class StatusPage extends StatefulWidget {
  final StatusPresenter presenter;

  const StatusPage({
    super.key,
    required this.presenter,
  });

  @override
  StatusPageState createState() => StatusPageState();
}

class StatusPageState extends State<StatusPage> with NavigationManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      widget.presenter.loadStatus();
      return Scaffold(
        backgroundColor: AdraColors.white,
        body: StreamBuilder<StatusCardViewModel?>(
            stream: widget.presenter.statusViewModel,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const SizedBox.shrink();
              }
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CardStatus(
                    viewModel: snapshot.data,
                    onPressed: (errorEntity) {
                      Modular.to.pop();
                    },
                  ),
                ),
              );
            }),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdraButton(
                onPressed: () {
                  widget.presenter.goToFormsSesion();
                },
                title: R.string.newRegister,
                buttonColor: AdraColors.primary,
                borderRadius: 50.0,
                buttonHeigth: 52.0,
                titleColor: AdraColors.white,
              ),
              const SizedBox(height: 8.0),
              AdraButton(
                onPressed: () {
                  widget.presenter.goToForms();
                },
                title: R.string.backToProjects,
                buttonColor: AdraColors.hintColor,
                borderRadius: 50.0,
                buttonHeigth: 52.0,
                titleColor: AdraColors.primary,
              ),
            ],
          ),
        ),
      );
    });
  }
}
