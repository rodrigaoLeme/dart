import 'package:flutter/material.dart';

import '../../../../ui/modules/profile/profile_page.dart';
import 'profile_presenter_factory.dart';

Widget makeProfilePage() => ProfilePage(
      presenter: makeProfilePresenter(),
    );
