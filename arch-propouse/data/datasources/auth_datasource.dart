import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/account/logged_user.dart';
import '../../domain/helpers/domain_error.dart';
import '../http/http_client.dart';
import 'providers/provider_service.dart';

abstract class AuthDatasource {
  Future<LoggedUser?> loginWithGoogle();
  Future<LoggedUser?> loginWithMicrosoft();
  Future<LoggedUser?> loginWithApple();

  Future<int> logout();
  Future<void> deleteAccount();
  Future<LoggedUser?> getLoggedUser();
  FutureOr<LoggedUser?> linkAccount(ProviderLogin provider);
  Future<LoggedUser?> unlinkAccount(ProviderLogin provider);
  Future<String> obterImagemPerfilMicrosoft(String accessToken);
}

class FirebaseDatasource implements AuthDatasource {
  final FirebaseAuth firebaseAuth;
  final ProviderService provider;
  final AdraHttpClient clientHttp;

  FirebaseDatasource({
    required this.provider,
    required this.firebaseAuth,
    required this.clientHttp,
  });

  @override
  Future<LoggedUser?> getLoggedUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return null;

    return _userFactory(
      currentUser,
      _getProviderLogin(user.providerData),
    );
  }

  List<ProviderLogin?> _getProviderLogin(List<UserInfo> userInfos) {
    return userInfos.map((userInfo) {
      if (userInfo.providerId == 'google.com') {
        ProviderLogin.google.name = userInfo.displayName ?? '';
        ProviderLogin.google.email = userInfo.email ?? '';
        return ProviderLogin.google;
      } else if (userInfo.providerId == 'microsoft.com') {
        ProviderLogin.microsoft.name = userInfo.displayName ?? '';
        ProviderLogin.microsoft.email = userInfo.email ?? '';
        return ProviderLogin.microsoft;
      } else if (userInfo.providerId == 'apple.com') {
        ProviderLogin.apple.name = userInfo.displayName ?? '';
        ProviderLogin.apple.email = userInfo.email ?? '';
        return ProviderLogin.apple;
      } else {
        return null;
      }
    }).toList();
  }

  @override
  Future<LoggedUser?> loginWithGoogle() async {
    GoogleSignInAuthentication? signInAuthenticationResult;
    try {
      signInAuthenticationResult = await provider.googleAuth();
      if (signInAuthenticationResult == null) return null;
      final credential = GoogleAuthProvider.credential(
        accessToken: signInAuthenticationResult.accessToken,
        idToken: signInAuthenticationResult.idToken,
      );

      await provider.googleSignIn.signOut();
      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return null;
      return _userFactory(user, _getProviderLogin(user.providerData));
    } catch (error) {
      throw DomainError.invalidCredentials;
    }
  }

  Future<LoggedUser> _userFactory(
      User firebaseUser, List<ProviderLogin?> providers,
      {String localPathPhoto = '', String msAccessToken = ''}) async {
    final token = await firebaseUser.getIdToken(true);
    return LoggedUser(
      email: firebaseUser.email ?? '',
      googleIdentityId: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      emailVerified: firebaseUser.emailVerified,
      urlPhoto: firebaseUser.photoURL ?? '',
      token: token,
      providers: providers,
      localPathPhoto: localPathPhoto,
      firebaseUid: firebaseUser.uid,
      msAccessToken: msAccessToken,
    );
  }

  @override
  Future<int> logout() async {
    await firebaseAuth.signOut();
    return 0;
  }

  @override
  Future<LoggedUser?> unlinkAccount(ProviderLogin provider) async {
    var user = firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    switch (provider) {
      case ProviderLogin.google:
        user = await user.unlink('google.com');
        break;

      case ProviderLogin.microsoft:
        user = await user.unlink('microsoft.com');
        break;
      case ProviderLogin.apple:
        user = await user.unlink('apple.com');
        break;
    }

    return _userFactory(user, _getProviderLogin(user.providerData));
  }

  @override
  FutureOr<LoggedUser?> linkAccount(ProviderLogin providerLogin) {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    switch (providerLogin) {
      case ProviderLogin.google:
        return _linkGoogle(user);

      case ProviderLogin.microsoft:
        return _linkMicrosoft(user);
      case ProviderLogin.apple:
        return _linkApple(user);
    }
  }

  Future<LoggedUser?> _linkGoogle(User user) async {
    GoogleSignInAuthentication? signInAuthenticationResult;
    try {
      signInAuthenticationResult = await provider.googleAuth();
    } catch (_) {
      rethrow;
    }
    if (signInAuthenticationResult == null) return null;
    final credential = GoogleAuthProvider.credential(
      accessToken: signInAuthenticationResult.accessToken,
      idToken: signInAuthenticationResult.idToken,
    );

    await provider.googleSignIn.signOut();
    UserCredential result;
    try {
      result = await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        rethrow;
      }
      throw Exception();
    }
    final resultUser = result.user;
    if (resultUser == null) return null;

    return _userFactory(resultUser, _getProviderLogin(resultUser.providerData));
  }

  Future<LoggedUser?> _linkMicrosoft(User user) async {
    OAuthProvider? microsoftProvider;
    try {
      microsoftProvider = await provider.microsoftAuth();
    } catch (_) {
      rethrow;
    }
    final getUser =
        await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    UserCredential result;
    try {
      result = await user.linkWithCredential(getUser.credential!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        rethrow;
      }
      throw Exception();
    }
    final resultUser = result.user;
    if (resultUser == null) return null;

    return _userFactory(resultUser, _getProviderLogin(resultUser.providerData));
  }

  Future<LoggedUser?> _linkApple(User user) async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      final getUser =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      UserCredential result;
      try {
        result = await user.linkWithCredential(getUser.credential!);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use') {
          rethrow;
        }
        throw Exception();
      }
      final resultUser = result.user;
      if (resultUser == null) return null;

      return _userFactory(
          resultUser, _getProviderLogin(resultUser.providerData));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<LoggedUser?> loginWithMicrosoft() async {
    OAuthProvider? microsoftProvider;
    try {
      microsoftProvider = await provider.microsoftAuth();
      final result =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      var imagePath = '';

      final user = result.user;
      String token = '';
      if (user == null) return null;
      token = result.credential?.accessToken ?? '';
      if ((user.photoURL == null || user.photoURL!.isEmpty) &&
          (token.isNotEmpty)) {
        imagePath = await obterImagemPerfilMicrosoft(
          token,
        );
      }
      return _userFactory(
        user,
        _getProviderLogin(user.providerData),
        localPathPhoto: imagePath,
        msAccessToken: token,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        rethrow;
      }
      return null;
    }
  }

  @override
  Future<LoggedUser?> loginWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      final result =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      final user = result.user;
      if (user == null) return null;
      return _userFactory(user, _getProviderLogin(user.providerData));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        rethrow;
      }
      return null;
    }
  }

  @override
  Future<String> obterImagemPerfilMicrosoft(String accessToken) async {
    try {
      final response = await clientHttp.request(
        url: 'https://graph.microsoft.com/v1.0/me/photo/\$value',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        method: HttpMethod.get,
      );

      if (response.statusCode == 200) {
        List<int> imageData = response.data;
        final diretorio = await getApplicationDocumentsDirectory();
        final path =
            '${diretorio.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
        File arquivo = File(path);
        await arquivo.writeAsBytes(imageData);
        return path;
      } else {
        return '';
      }
    } catch (error) {
      return '';
    }
  }
}
