import 'package:flutter_modular/flutter_modular.dart';

import '../../../../data/usecases/account/remote_social_authentication.dart';
import '../../../../domain/usecases/account/social_auth_repository.dart';
import '../../../../domain/usecases/account/social_authentication.dart';

SocialAuthentication makeSocialAuthentication() =>
    RemoteSocialAuthentication(repository: Modular.get<SocialAuthRepository>());
