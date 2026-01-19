import 'package:flutter/material.dart';

import '../../../../ui/modules/splash/splash_page.dart';
import 'splash_presenter_factory.dart';

Widget makeSplashPage() => SplashPage(presenter: makeSplashPresenter());
