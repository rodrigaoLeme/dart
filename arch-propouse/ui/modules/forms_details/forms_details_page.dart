import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/routes/routes_app.dart';
import '../../../presentation/presenters/forms_details/forms_details_state.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import '../answer_form/answer_form_presenter.dart';
import 'components/forms_details_app_bar.dart';
import 'components/forms_details_error.dart';
import 'components/forms_details_header.dart';
import 'components/forms_details_loading.dart';
import 'components/forms_details_tabs.dart';
import 'components/list_empty_register.dart';
import 'components/list_status_details_section.dart';
import 'forms_details_presenter.dart';

class FormsDetailsPage extends StatefulWidget {
  final FormsDetailsPresenter presenter;

  const FormsDetailsPage({super.key, required this.presenter});

  @override
  FormsDetailsPageState createState() => FormsDetailsPageState();
}

class FormsDetailsPageState extends State<FormsDetailsPage>
    with NavigationManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToListener);
    widget.presenter.loadData();
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      appBar: const FormsDetailsAppBar(),
      body: StreamBuilder<FormsDetailsState>(
        stream: widget.presenter.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const FormsDetailsLoadingWidget();
          }
          final state = snapshot.data;
          if (state is FormsDetailsLoading) {
            return const FormsDetailsLoadingWidget();
          }
          if (state is FormsDetailsError) {
            return FormsDetailsErrorWidget(
              error: state.error,
              onRetry: widget.presenter.loadData,
            );
          }
          if (state is! FormsDetailsData) {
            return const SizedBox.shrink();
          }
          final details = state.details;

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                FormsDetailsHeader(viewModel: details),
                FormsDetailsTabs(viewModel: details),
                Expanded(
                  child: TabBarView(
                    children: [
                      (details.data?.localForms?.isNotEmpty == true)
                          ? ListStatusDetailsSection(
                              viewModels: details.data?.localForms ?? [],
                              onPressed: (latestFormSendedViewModel) async {
                                await widget.presenter.save(
                                  latestFormSendedViewModel,
                                  details,
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () => widget.presenter.goToStatusPage(),
                                );
                              },
                              showMoreOptionsIcon: true,
                              showRefreshIcon: true,
                              sessions: details.data?.sessions,
                              onTapEdit:
                                  (session, latestFormSendedViewModel) async {
                                final paramsViewModel = details.copyWith(
                                  sessionToEdit: session,
                                  answerFlow: AnswerFlow.main,
                                  currentUUID: latestFormSendedViewModel?.id,
                                );
                                await Modular.to.pushNamed(
                                  Routes.answerForm,
                                  arguments: paramsViewModel,
                                );
                                widget.presenter.loadData();
                              },
                              onTapDelete: (latestFormSendedViewModel) {
                                widget.presenter.delete(
                                  viewModel: details,
                                  latestFormSendedViewModel:
                                      latestFormSendedViewModel,
                                );
                              },
                              presenter: widget.presenter,
                            )
                          : ListEmptyRegister(
                              text: R.string.activitySubtitle,
                            ),
                      (details.data?.latestFormSended?.isNotEmpty == true)
                          ? ListStatusDetailsSection(
                              viewModels: details.data?.latestFormSended ?? [],
                              showMoreOptionsIcon: false,
                              showRefreshIcon: false,
                              sessions: const [],
                              presenter: widget.presenter,
                            )
                          : ListEmptyRegister(
                              text: R.string.messageEmptySend,
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: StreamBuilder<FormsDetailsState>(
        stream: widget.presenter.state,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data is FormsDetailsData) {
            final data = snapshot.data as FormsDetailsData;
            if (data.forms?.isExpired == true) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 72.0,
              width: 72.0,
              child: FloatingActionButton(
                onPressed: () async {
                  await Modular.to.pushNamed(
                    Routes.answerForm,
                    arguments: data.details,
                  );
                  widget.presenter.loadData();
                },
                backgroundColor: AdraColors.primary,
                elevation: 6.0,
                shape: const CircleBorder(),
                child: SvgPicture.asset(
                  'lib/ui/assets/images/icon/user-plus-solid.svg',
                  height: 24,
                  width: 24,
                  color: AdraColors.white,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
