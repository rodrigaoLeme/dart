import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/usecases/auth/auth.dart';

abstract class AuthRepository {
  firebase.User? get currentUser;

  Stream<firebase.User?> get authStateChanges;

  Future<firebase.User> signInWithGoogle();

  Future<firebase.User> signInWithApple();

  Future<firebase.User> signInAnonymously();

  Future<void> signOut();

  // Vincula conta anônima com um provedor
  Future<firebase.User> linkWithProvider(LinkProvider provider);

  Future<void> deleteAccount();
}
