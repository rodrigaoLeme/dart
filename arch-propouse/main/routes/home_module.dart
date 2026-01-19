import 'package:flutter_modular/flutter_modular.dart';

import '../factories/pages/answer_form/answer_form_page_factory.dart';
import '../factories/pages/cpf_login/cpf_login_page_factory.dart';
import '../factories/pages/forms/forms_page_factory.dart';
import '../factories/pages/forms_details/forms_details_page_factory.dart';
import '../factories/pages/home/home_page_factory.dart';
import '../factories/pages/profile/profile_page_factory.dart';
import '../factories/pages/status/status_page_factory.dart';
import '../factories/pages/terms/terms_page_factory.dart';
import 'core_module.dart';
import 'routes_app.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.home,
      child: (_) => makeHomePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.forms,
      child: (_) => makeFormsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.accountTerms,
      child: (_) => makeTermsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.formsDetails,
      child: (_) => makeFormsDetailsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.answerForm,
      child: (_) => makeAnswerFormPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.status,
      child: (_) => makeStatusPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.cpfLogin,
      child: (_) => makeCpfLoginPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.profile,
      child: (_) => makeProfilePage(),
      transition: TransitionType.fadeIn,
    );
  }
}
