import 'package:flutter/material.dart';

import '../../../../ui/modules/forms/forms_page.dart';
import 'forms_presenter_factory.dart';

Widget makeFormsPage() => FormsPage(
      presenter: makeFormsPresenter(),
    );
