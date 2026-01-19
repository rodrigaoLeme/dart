import 'package:flutter/material.dart';

import '../../../../ui/modules/forms_details/forms_details_page.dart';
import 'forms_details_presenter_factory.dart';

Widget makeFormsDetailsPage() => FormsDetailsPage(
      presenter: makeFormsDetailsPresenter(),
    );
