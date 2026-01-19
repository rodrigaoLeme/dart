import 'package:flutter/material.dart';

import '../../../../ui/modules/terms_accepted/terms_accepted_page.dart';
import 'terms_presenter_factory.dart';

Widget makeTermsPage() => TermsAcceptedPage(
      presenter: makeTermsPresenter(),
    );
