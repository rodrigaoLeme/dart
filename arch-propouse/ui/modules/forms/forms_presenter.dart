import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/account/account_token_entity.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/forms/forms_view_model.dart';
import '../../mixins/mixins.dart';

enum FilterType {
  all,
  group,
  project,
  form,
}

abstract class FormsPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;
  Stream<FormViewModel?> get formViewModel;
  ValueNotifier<AccountTokenEntity?> get userNotifier;

  // Filtros
  Stream<FilterType> get filterTypeStream;
  Stream<List<String>> get availableFiltersStream;
  Stream<Map<FilterType, List<String>>> get allSelectedFiltersStream;
  Stream<String> get searchTextStream;

  Future<void> loadForms();
  void goToDetailsForms({required FormsViewModel viewModel});
  Future<AccountTokenEntity?> getLoggedUser();
  Future<void> refreshForms();
  goToProfile();
  Future<void> loadUser();
  void setFilterType(FilterType type);
  void addFilterValues(FilterType type, List<String> values);
  void removeFilterValue(FilterType type, String value);
  void clearFilterType(FilterType type);
  void clearAllFilters();
  void setSearchText(String text);
  void dispose();
}
