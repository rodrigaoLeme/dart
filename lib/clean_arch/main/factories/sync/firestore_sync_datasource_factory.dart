import '../../../data/repositories/sync_repository.dart';
import '../../../infra/sync/sync.dart';
import '../auth/firebase_instances_factory.dart';

class FirestoreSyncDatasourceFactory {
  static SyncRepository make() {
    return FirestoreSyncDatasource(
      firestore: FirebaseInstancesFactory.makeFirestore(),
      firebaseAuth: FirebaseInstancesFactory.makeFirebaseAuth(),
    );
  }
}
