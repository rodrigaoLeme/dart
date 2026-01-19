import 'package:flutter/material.dart';

import '../../../../ui/modules/answer_form/answer_form_page.dart';
import 'answer_form_presenter_factory.dart';

Widget makeAnswerFormPage() => AnswerFormPage(
      presenter: makeAnswerFormPresenter(null),
    );
