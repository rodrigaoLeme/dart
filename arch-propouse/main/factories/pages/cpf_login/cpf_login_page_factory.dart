import 'package:flutter/material.dart';

import '../../../../ui/modules/cpf_login/cpf_login_page.dart';
import 'cpf_login_presenter_factory.dart';

Widget makeCpfLoginPage() => CpfLoginPage(
      presenter: makeCpfLoginPresenter(),
    );
