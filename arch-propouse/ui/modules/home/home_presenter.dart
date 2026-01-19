import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/home/home_view_model.dart';
import '../../../presentation/presenters/resources/resources_view_model.dart';
import '../../mixins/mixins.dart';

abstract class HomePresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;

  Stream<HomeViewModel?> get formsViewModel;
  Stream<ResourcesViewModel?> get resourcesViewModel;

  Future<void> loadForms();
  Future<void> fetchResources();
}
