import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/account/account_token_entity.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../../domain/usecases/forms/load_forms.dart';
import '../../../domain/usecases/terms/save_current_account_terms.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/forms/forms_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import 'forms_view_model.dart';

class FormsPresentation
    with NavigationManager, LoadingManager
    implements FormsPresenter {
  final LoadForms loadForm;
  final SaveCurrentAccountTerms saveCurrentAccountTerms;
  final LoadCurrentAccount loadCurrentAccount;

  FormsPresentation({
    required this.loadForm,
    required this.saveCurrentAccountTerms,
    required this.loadCurrentAccount,
  });

  final StreamController<FormViewModel?> _formsViewModel =
      StreamController<FormViewModel?>.broadcast();
  final ValueNotifier<AccountTokenEntity?> _userNotifier =
      ValueNotifier<AccountTokenEntity?>(null);

  // Filtros
  final StreamController<FilterType> _filterTypeController =
      StreamController<FilterType>.broadcast();
  final StreamController<List<String>> _availableFiltersController =
      StreamController<List<String>>.broadcast();
  final StreamController<Map<FilterType, List<String>>>
      _allSelectedFiltersController =
      StreamController<Map<FilterType, List<String>>>.broadcast();
  final StreamController<String> _searchTextController =
      StreamController<String>.broadcast();

  List<FormsViewModel> _allForms = [];
  FilterType _currentFilterType = FilterType.all;
  final Map<FilterType, List<String>> _selectedFilters = {
    FilterType.group: [],
    FilterType.project: [],
    FilterType.form: [],
  };
  String _currentSearchText = '';

  @override
  Stream<FormViewModel?> get formViewModel => _formsViewModel.stream;

  @override
  ValueNotifier<AccountTokenEntity?> get userNotifier => _userNotifier;

  @override
  Stream<FilterType> get filterTypeStream => _filterTypeController.stream;

  @override
  Stream<List<String>> get availableFiltersStream =>
      _availableFiltersController.stream;

  @override
  Stream<Map<FilterType, List<String>>> get allSelectedFiltersStream =>
      _allSelectedFiltersController.stream;

  @override
  Stream<String> get searchTextStream => _searchTextController.stream;

  @override
  Future<void> loadForms() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final forms = await loadForm.load();
      _allForms = forms.data?.map((e) => e.toViewModel()).toList() ?? [];

      // Emitir estado inicial dos filtros
      _allSelectedFiltersController.add(Map.from(_selectedFilters));

      _applyFilters();
    } catch (e) {
      _formsViewModel.addError(e);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  void _applyFilters() {
    List<FormsViewModel> filtered = List.from(_allForms);

    // Filtrar por grupos selecionados
    final selectedGroups = _selectedFilters[FilterType.group] ?? [];
    if (selectedGroups.isNotEmpty) {
      filtered = filtered
          .where((f) => f.group != null && selectedGroups.contains(f.group))
          .toList();
    }

    // Filtrar por projetos selecionados
    final selectedProjects = _selectedFilters[FilterType.project] ?? [];
    if (selectedProjects.isNotEmpty) {
      filtered = filtered
          .where((f) =>
              f.projectName != null && selectedProjects.contains(f.projectName))
          .toList();
    }

    // Filtrar por formulários selecionados
    final selectedForms = _selectedFilters[FilterType.form] ?? [];
    if (selectedForms.isNotEmpty) {
      filtered = filtered
          .where(
              (f) => f.formName != null && selectedForms.contains(f.formName))
          .toList();
    }

    // Filtrar por texto de busca
    if (_currentSearchText.isNotEmpty) {
      final searchLower = _currentSearchText.toLowerCase();
      filtered = filtered.where((form) {
        return (form.formName?.toLowerCase().contains(searchLower) ?? false) ||
            (form.projectName?.toLowerCase().contains(searchLower) ?? false) ||
            (form.group?.toLowerCase().contains(searchLower) ?? false) ||
            (form.type?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    _formsViewModel.add(FormViewModel(
      data: filtered,
      success: true,
      error: false,
    ));
  }

  void _updateAvailableFilters() {
    List<String> available = [];

    switch (_currentFilterType) {
      case FilterType.group:
        available = _allForms
            .map((f) => f.group)
            .where((g) => g != null && g.isNotEmpty)
            .toSet()
            .cast<String>()
            .toList()
          ..sort();
        break;
      case FilterType.project:
        available = _allForms
            .map((f) => f.projectName)
            .where((p) => p != null && p.isNotEmpty)
            .toSet()
            .cast<String>()
            .toList()
          ..sort();
        break;
      case FilterType.form:
        available = _allForms
            .map((f) => f.formName)
            .where((fn) => fn != null && fn.isNotEmpty)
            .toSet()
            .cast<String>()
            .toList()
          ..sort();
        break;
      case FilterType.all:
        available = [];
        break;
    }

    _availableFiltersController.add(available);
  }

  @override
  goToDetailsForms({required FormsViewModel viewModel}) {
    navigateTo = NavigationData(
      route: Routes.formsDetails,
      clear: false,
      arguments: viewModel,
    );
  }

  @override
  Future<AccountTokenEntity?> getLoggedUser() async {
    try {
      final user = await loadCurrentAccount.load();
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> loadUser() async {
    try {
      final user = await loadCurrentAccount.load();
      _userNotifier.value = user;
    } catch (_) {
      _userNotifier.value = null;
    }
  }

  @override
  Future<void> refreshForms() async {
    await loadForms();
  }

  @override
  goToProfile() {
    navigateTo = NavigationData(
      route: Routes.profile,
      clear: false,
    );
  }

  @override
  void setFilterType(FilterType type) {
    _currentFilterType = type;
    _filterTypeController.add(type);
    _updateAvailableFilters();
  }

  @override
  void addFilterValues(FilterType type, List<String> values) {
    _selectedFilters[type] = values;
    _allSelectedFiltersController.add(Map.from(_selectedFilters));
    _applyFilters();
  }

  @override
  void removeFilterValue(FilterType type, String value) {
    _selectedFilters[type]?.remove(value);
    _allSelectedFiltersController.add(Map.from(_selectedFilters));
    _applyFilters();
  }

  @override
  void clearFilterType(FilterType type) {
    _selectedFilters[type] = [];
    _allSelectedFiltersController.add(Map.from(_selectedFilters));
    _applyFilters();
  }

  @override
  void clearAllFilters() {
    _selectedFilters[FilterType.group] = [];
    _selectedFilters[FilterType.project] = [];
    _selectedFilters[FilterType.form] = [];
    _currentFilterType = FilterType.all;
    _filterTypeController.add(FilterType.all);
    _allSelectedFiltersController.add(Map.from(_selectedFilters));
    _applyFilters();
  }

  @override
  void setSearchText(String text) {
    _currentSearchText = text;
    _searchTextController.add(text);
    _applyFilters();
  }

  @override
  void dispose() {
    _formsViewModel.close();
    _userNotifier.dispose();
    _filterTypeController.close();
    _availableFiltersController.close();
    _allSelectedFiltersController.close();
    _searchTextController.close();
  }
}
