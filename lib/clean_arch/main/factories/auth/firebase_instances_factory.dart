import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Centraliza a criação das isntâncias singleton do Firebase Auth e Google Sign-In
class FirebaseInstancesFactory {
  static FirebaseAuth makeFirebaseAuth() {
    return FirebaseAuth.instance;
  }

  static GoogleSignIn makeGoogleSignIn() {
    return GoogleSignIn.instance;
  }

  static FirebaseFirestore makeFirestore() {
    return FirebaseFirestore.instance;
  }
}
