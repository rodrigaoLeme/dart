import 'dart:async';

import '../../../domain/entities/terms/account_terms_status.dart';
import '../../../domain/usecases/terms/load_terms.dart';
import '../../../domain/usecases/terms/save_current_account_terms.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/terms_accepted/terms_accepted_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/ui_error_manager.dart';
import 'terms_view_model.dart';

class TermsAcceptedPresentation
    with NavigationManager, LoadingManager, UIErrorManager
    implements TermsAcceptedPresenter {
  final LoadTerms loadTerms;
  final SaveCurrentAccountTerms saveCurrentAccountTerms;

  TermsAcceptedPresentation({
    required this.loadTerms,
    required this.saveCurrentAccountTerms,
  });

  final StreamController<TermsViewModel?> _termsViewModel =
      StreamController<TermsViewModel?>.broadcast();

  @override
  Stream<TermsViewModel?> get termsViewModel => _termsViewModel.stream;

  @override
  Future<void> fetchTerms() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final terms = await loadTerms.load();
      _termsViewModel.add(terms.toViewModel());
    } catch (e) {
      _termsViewModel.addError(e);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  Future<void> acceptTerms() async {
    try {
      saveCurrentAccountTerms.save(AccountTermsStatus.done);
      navigateTo = NavigationData(route: Routes.forms, clear: true);
    } catch (e) {
      mainError = UIError.unexpected.description;
    }
  }
}
