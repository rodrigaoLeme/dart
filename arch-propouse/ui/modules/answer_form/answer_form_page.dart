import 'package:flutter/material.dart';

import '../../../presentation/presenters/answer_form/answer_form_state.dart';
import '../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../components/components.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import 'answer_form_presenter.dart';
import 'components/bottom_actions.dart';
import 'components/section_content.dart';
import 'components/session_header.dart';

class AnswerFormPage extends StatefulWidget {
  final AnswerFormPresenter presenter;

  const AnswerFormPage({
    super.key,
    required this.presenter,
  });

  @override
  AnswerFormPageState createState() => AnswerFormPageState();
}

class AnswerFormPageState extends State<AnswerFormPage>
    with NavigationManager, TickerProviderStateMixin, UIErrorManager {
  TabController? _tabController;
  final ValueNotifier<int> currentTabIndex = ValueNotifier<int>(0);

  AnswerFormViewModel? viewModel;
  ValueNotifier<SessionViewModel?> sessionViewModel =
      ValueNotifier<SessionViewModel?>(null);
  ValueNotifier<bool> isSaveState = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);
  bool backDidTap = false;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToListener);
    handleMainError(context, widget.presenter.mainErrorStream);

    widget.presenter.loadAnswer();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AnswerFormState>(
      stream: widget.presenter.state,
      initialData: const AnswerFormLoading(),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null || state is AnswerFormLoading) {
          return Scaffold(
            backgroundColor: AdraColors.white,
            appBar: AppBar(
              backgroundColor: AdraColors.primary,
              titleSpacing: 0,
              leading: const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.transparent,
                ),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: AdraText(
                  text: '',
                  textSize: AdraTextSizeEnum.h3,
                  textStyleEnum: AdraTextStyleEnum.regular,
                  color: AdraColors.white,
                  adraStyles: AdraStyles.poppins,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            body: const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  color: AdraColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        }
        if (state is AnswerFormError) {
          // Minimal error UI; keep page consistent
          return Scaffold(
            backgroundColor: AdraColors.white,
            appBar: AppBar(
              backgroundColor: AdraColors.primary,
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AdraColors.white,
                ),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: AdraText(
                  text: '',
                  textSize: AdraTextSizeEnum.h3w5,
                  textStyleEnum: AdraTextStyleEnum.regular,
                  color: AdraColors.white,
                  adraStyles: AdraStyles.poppins,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: AdraColors.primary),
                  const SizedBox(height: 12),
                  AdraText(
                    text: 'Ocorreu um erro ao carregar o formulário',
                    textSize: AdraTextSizeEnum.body,
                    textStyleEnum: AdraTextStyleEnum.regular,
                    color: AdraColors.globalTextColor,
                    adraStyles: AdraStyles.poppins,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => widget.presenter.loadAnswer(),
                    child: const Text('Tentar novamente'),
                  )
                ],
              ),
            ),
          );
        }

        // Data state
        final dataState = state as AnswerFormData;
        viewModel = dataState.viewModel;
        final isMainFlow = widget.presenter.answerFlow == AnswerFlow.main;
        final sections = viewModel?.data
                ?.sessionsByFlow(answerFlow: widget.presenter.answerFlow) ??
            [];
        _setupTabController(sections);
        _setEnableState();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: WillPopScope(
            onWillPop: () async {
              // Bloqueia navegação enquanto está enviando
              if (isSubmitting.value) return false;
              backDidTap = true;
              return true;
            },
            child: Scaffold(
              backgroundColor: AdraColors.white,
              appBar: AppBar(
                backgroundColor: AdraColors.primary,
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () {
                    if (isSubmitting.value) return;
                    backDidTap = true;
                    // Usa maybePop para respeitar WillPopScope
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AdraColors.white,
                  ),
                ),
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: AdraText(
                    text: isMainFlow
                        ? viewModel?.data?.formTitle ?? ''
                        : viewModel?.data?.subForm?.formTitle ?? '',
                    textSize: AdraTextSizeEnum.h3w5,
                    textStyleEnum: AdraTextStyleEnum.regular,
                    color: AdraColors.white,
                    adraStyles: AdraStyles.poppins,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              body: ValueListenableBuilder<bool>(
                valueListenable: isSubmitting,
                builder: (context, submitting, ___) {
                  return Stack(
                    children: [
                      AbsorbPointer(
                        absorbing: submitting,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: sessionViewModel,
                              builder: (context, snapshot, _) {
                                final numberOfSession = sections.length;
                                final currentTab = (_tabController?.index ?? 0);
                                return SessionHeader(
                                  currentIndex: currentTab,
                                  total: numberOfSession,
                                  title: sections[currentTab].title,
                                );
                              },
                            ),
                            const Divider(
                              color: AdraColors.cyanBlue,
                              height: 1,
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: sections
                                    .map(
                                      (tab) => SectionContent(
                                        presenter: widget.presenter,
                                        viewModel: viewModel,
                                        tab: tab,
                                        isMainFlow: isMainFlow,
                                        isEditMode: widget.presenter.isEdidMode,
                                        existingRegister:
                                            widget.presenter.existingRegister,
                                        onEndEditingValidate: (q, answer) {
                                          if (backDidTap) return;
                                          widget.presenter.verifyAnswers(
                                            questionViewModel: q,
                                            answer: answer,
                                            viewModel: viewModel,
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: isSaveState,
                              builder: (context, isSave, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable: isSubmitting,
                                  builder: (context, submitting, __) {
                                    final isFirstTab =
                                        (_tabController?.index ?? 0) == 0;
                                    return BottomActions(
                                      isFirstTab: isFirstTab,
                                      isSaveState: isSave,
                                      isSubmitting: submitting,
                                      onPrevious: _goToPreviousTab,
                                      onNextOrFinalize: () async {
                                        if (isSave) {
                                          if (widget.presenter.answerFlow ==
                                              AnswerFlow.subForm) {
                                            final currentTab =
                                                (_tabController?.index ?? 0);
                                            final isValid = await widget
                                                .presenter
                                                .validateSection(
                                              index: currentTab,
                                              viewModel: viewModel,
                                            );
                                            if (isValid) {
                                              backDidTap = true;
                                              Navigator.of(context).pop();
                                            }
                                          } else {
                                            final currentTab =
                                                (_tabController?.index ?? 0);
                                            final isValid = await widget
                                                .presenter
                                                .validateSection(
                                              index: currentTab,
                                              viewModel: viewModel,
                                            );
                                            if (isValid) {
                                              isSubmitting.value = true;
                                              try {
                                                await widget.presenter.save();
                                              } finally {
                                                isSubmitting.value = false;
                                              }
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 200), () {
                                                widget.presenter
                                                    .goToStatusPage();
                                              });
                                            }
                                          }
                                        } else {
                                          await _goToNextTab();
                                        }
                                      },
                                      onSaveDraft: () async {
                                        final currentTab =
                                            (_tabController?.index ?? 0);
                                        final isValid = await widget.presenter
                                            .validateSection(
                                          index: currentTab,
                                          viewModel: viewModel,
                                        );
                                        if (isValid) {
                                          backDidTap = true;
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (submitting)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToPreviousTab() {
    if (_tabController != null && (_tabController?.index ?? 0) > 0) {
      _tabController?.animateTo((_tabController?.index ?? 0) - 1);
      _setEnableState();
    }
  }

  Future<void> _goToNextTab() async {
    if (_tabController != null &&
        (_tabController?.index ?? 0) < (_tabController?.length ?? 0) - 1) {
      final currentTab = (_tabController?.index ?? 0);
      final isValid = await widget.presenter.validateSection(
        index: currentTab,
        viewModel: viewModel,
      );
      if (isValid) {
        _tabController?.animateTo(currentTab + 1);
      }
    }
  }

  void _setEnableState() {
    final currentTab = _tabController?.index ?? 0;
    currentTabIndex.value = currentTab;

    final sections = viewModel?.data
            ?.sessionsByFlow(answerFlow: widget.presenter.answerFlow) ??
        [];
    isSaveState.value = currentTab + 1 == sections.length;
    sessionViewModel.value = sections[currentTab];
  }

  void _setupTabController(List<SessionViewModel> sections) {
    final isNumberOfSectionsChanged = sections.length != _tabController?.length;
    if (isNumberOfSectionsChanged) {
      _tabController = TabController(
        length: sections.length,
        vsync: this,
      );
    } else {
      _tabController ??= TabController(
        length: sections.length,
        vsync: this,
      );
    }
    _tabController!.addListener(_onTabChanged);
    if (isFirstLoad) {
      if (widget.presenter.isEdidMode) {
        _tabController?.animateTo(
            widget.presenter.formsDetailsViewModel?.sessionToEdit?.index ?? 0);
      }
      isFirstLoad = false;
    }
  }

  void _onTabChanged() {
    if (_tabController == null) return;
    if (_tabController!.indexIsChanging) return;
    widget.presenter.updateCurrentSessionIndex(_tabController!.index);
    _setEnableState();
  }
}
