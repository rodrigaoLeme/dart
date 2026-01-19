import 'dart:async';

import '../../../domain/usecases/resources/load_resources.dart';
import '../../../ui/modules/home/home_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../resources/resources_view_model.dart';
import 'home_view_model.dart';

class HomePresentation
    with NavigationManager, LoadingManager
    implements HomePresenter {
  final LoadResources loadResources;

  HomePresentation({
    required this.loadResources,
  });
  final StreamController<HomeViewModel?> _formsViewModel =
      StreamController<HomeViewModel?>.broadcast();
  @override
  Stream<HomeViewModel?> get formsViewModel => _formsViewModel.stream;

  final StreamController<ResourcesViewModel?> _resourcesViewModel =
      StreamController<ResourcesViewModel?>.broadcast();
  @override
  Stream<ResourcesViewModel?> get resourcesViewModel =>
      _resourcesViewModel.stream;

  @override
  Future<void> loadForms() async {
    throw UnimplementedError();
  }

  @override
  Future<void> fetchResources() async {
    try {
      final resources = await loadResources.load();
      _resourcesViewModel.add(resources.toViewModel());
    } catch (e) {
      _resourcesViewModel.addError(e);
    }
  }
}
