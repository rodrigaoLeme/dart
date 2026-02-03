import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/usecases/auth/auth.dart';

/// Adapter que implementa AuthRepository usando firebase Auth
class FirebaseAuthAdapter implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthAdapter({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<User> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();

      GoogleSignInAccount? googleUser =
          await _googleSignIn.attemptLightweightAuthentication();

      googleUser ??= await _googleSignIn.authenticate(scopeHint: [
        'email',
        'profile',
      ]);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<User> signInWithApple() async {
    try {
      final appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Apple');
      }

      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }
      }

      return _firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Apple sign in cancelled by user');
      }
      throw Exception('Apple sing in failed: ${e.message}');
    } catch (e) {
      throw Exception('Apple sing in failed: $e');
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();

      if (userCredential.user == null) {
        throw Exception('Failed to sign in anonymously');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw Exception('Anonymous sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<User> linkWithProvider(LinkProvider provider) async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        throw Exception('No user signed in to link');
      }

      if (!currentUser.isAnonymous) {
        throw Exception('User is not anonymous');
      }

      late final UserCredential userCredential;
      late final AuthCredential credential;

      switch (provider) {
        case LinkProvider.google:
          await _googleSignIn.initialize();

          GoogleSignInAccount? googleUser =
              await _googleSignIn.attemptLightweightAuthentication();

          googleUser ??= await _googleSignIn.authenticate(scopeHint: [
            'email',
            'profile',
          ]);

          final googleAuth = googleUser.authentication;
          credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
          );

          userCredential = await currentUser.linkWithCredential(credential);

          if (userCredential.user != null) {
            await userCredential.user!
                .updateDisplayName(googleUser.displayName);
            await userCredential.user!.updatePhotoURL(googleUser.photoUrl);
            await userCredential.user!.reload();
          }
          break;

        case LinkProvider.apple:
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          credential = OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

          userCredential = await currentUser.linkWithCredential(credential);

          if (userCredential.user != null &&
              (appleCredential.givenName != null ||
                  appleCredential.familyName != null)) {
            final displayName =
                '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                    .trim();
            if (displayName.isNotEmpty) {
              await userCredential.user!.updateDisplayName(displayName);
              await userCredential.user!.reload();
            }
          }
          break;
      }

      return _firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw Exception('Link accout failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('No user signed in to delete');
      }

      if (!user.isAnonymous) {
        await _googleSignIn.signOut();
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  Exception _mapFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return Exception('Network error. Check your connection.');
      case 'user-disabled':
        return Exception('Account disabled. Contact support.');
      case 'user-not-found':
        return Exception('User not found.');
      case 'wrong-password':
      case 'invalid-credential':
        return Exception('Invalid credentials.');
      case 'email-already-in-use':
      case 'credential-already-in-use':
        return Exception('Email already in use.');
      case 'operation-not-allowed':
        return Exception('Provider not available.');
      case 'weak-password':
        return Exception('Weak password.');
      case 'requires-recent-login':
        return Exception('Session expired. Please login again.');
      case 'account-exists-with-different-credential':
        return Exception('Account exists with different credentials.');
      default:
        return Exception(e.message ?? 'Authentication failed: ${e.code}');
    }
  }
}
