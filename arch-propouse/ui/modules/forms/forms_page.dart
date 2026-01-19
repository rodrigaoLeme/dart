import 'package:flutter/material.dart';

import '../../../presentation/presenters/forms/forms_view_model.dart';
import '../../../share/utils/app_color.dart';
import '../../components/components.dart';
import '../../components/empty_state.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import 'components/filter_section.dart';
import 'components/form_card_section.dart';
import 'components/forms_app_bar.dart';
import 'forms_presenter.dart';

class FormsPage extends StatefulWidget {
  final FormsPresenter presenter;

  const FormsPage({
    super.key,
    required this.presenter,
  });

  @override
  FormsPageState createState() => FormsPageState();
}

class FormsPageState extends State<FormsPage>
    with NavigationManager, LoadingManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToListener);
    handleLoading(context, widget.presenter.isLoadingStream);

    widget.presenter.loadForms();
    widget.presenter.loadUser();
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
      appBar: FormsAppBar(presenter: widget.presenter),
      body: StreamBuilder<FormViewModel?>(
        stream: widget.presenter.formViewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          final hasData =
              viewModel?.data != null && viewModel!.data!.isNotEmpty;
          final isWaiting = snapshot.connectionState == ConnectionState.waiting;

          return Column(
            children: [
              // Seção de filtros - só aparece quando há dados
              if (hasData) FilterSection(presenter: widget.presenter),

              // Lista de formulários
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Builder(
                    builder: (context) {
                      if (!hasData && !isWaiting) {
                        return EmptyState(
                          title: R.string.messageEmpty,
                        );
                      }
                      return RefreshIndicator(
                        color: AppColors.outline,
                        backgroundColor: Colors.white,
                        strokeWidth: 3,
                        displacement: 40,
                        onRefresh: () => widget.presenter.refreshForms(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                FormCardSection(
                                  viewModel: viewModel,
                                  onTap: (element) {
                                    if (element != null) {
                                      widget.presenter
                                          .goToDetailsForms(viewModel: element);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
