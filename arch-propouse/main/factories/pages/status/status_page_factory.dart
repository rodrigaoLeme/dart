import 'package:flutter/material.dart';

import '../../../../ui/modules/status/status_page.dart';
import 'status_presenter_factory.dart';

Widget makeStatusPage() => StatusPage(
      presenter: makeStatusPresenter(),
    );
