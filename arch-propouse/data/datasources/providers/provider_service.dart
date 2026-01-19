import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../main/firebase_options_env.dart';

class ProviderService {
  final googleSignIn = GoogleSignIn(
    clientId: DefaultFirebaseOptionsEnv.currentPlatform.androidClientId,
  );

  Future<GoogleSignInAuthentication?> googleAuth() async {
    final googleUser = await googleSignIn.signIn();
    return await googleUser?.authentication;
  }

  Future<OAuthProvider> microsoftAuth() async {
    OAuthProvider provider = OAuthProvider('microsoft.com');
    provider.addScope('user.read');
    provider.addScope('profile');
    provider.addScope('email');
    provider.addScope('phone');

    return provider;
  }
}
