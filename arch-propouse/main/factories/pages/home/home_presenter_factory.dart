import '../../../../presentation/presenters/home/home_presentation.dart';
import '../../../../ui/modules/home/home_presenter.dart';
import '../../usecases/resources/load_resources_factory.dart';

HomePresenter makeHomePresenter() => HomePresentation(
      loadResources: makeRemoteLoadAttendeestWithLocalFallback(),
    );
