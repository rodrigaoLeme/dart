import '../../../data/repositories/auth_repository.dart';
import '../../../infra/auth/auth.dart';
import './firebase_instances_factory.dart';

class FirebaseAuthAdapterFactory {
  static AuthRepository make() {
    return FirebaseAuthAdapter(
      firebaseAuth: FirebaseInstancesFactory.makeFirebaseAuth(),
      googleSignIn: FirebaseInstancesFactory.makeGoogleSignIn(),
    );
  }
}
