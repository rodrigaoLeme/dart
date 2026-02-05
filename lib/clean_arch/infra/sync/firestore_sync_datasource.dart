import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/sync/sync.dart';
import '../../data/repositories/sync_repository.dart';

/// DataSource que implementa o SyncRepository usando o Firestore
///
/// Estrutura do Firestore:
/// users/{userId}/
///  - readingProgress/current (doc)
///  - highlights/{highlightId} (collection)
///  - notes/{noteId} (collection)
///  = metadata/sync (doc)

class FirestoreSyncDatasource implements SyncRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreSyncDatasource({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  String get _userId {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }
    return user.uid;
  }

  DocumentReference get _userDoc => _firestore.collection('user').doc(_userId);

  // ========== READING PROGRESS ==========

  @override
  Future<void> uploadProgress(ReadingProgressModel progress) async {
    try {
      final progressRef = _userDoc.collection('readingProgress').doc('current');

      await progressRef.set(
        progress.toFirestore(),
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<ReadingProgressModel?> downloadProgress() async {
    try {
      final progressRef = _userDoc.collection('readingProgress').doc('current');
      final snapshot = await progressRef.get();

      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      if (data == null) {
        return null;
      }

      return ReadingProgressModel.fromFirestore(data);
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  // ========== HIGHLIGHTS ==========

  @override
  Future<void> uploadHighlight(HighlightModel highlight) async {
    try {
      final highlightRef =
          _userDoc.collection('highlights').doc('highlight.id');

      await highlightRef.set(
        highlight.toFirestore(),
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<List<HighlightModel>> downloadHighlights() async {
    try {
      final highlightsRef = _userDoc.collection('highlights');
      final snapshot = await highlightsRef.get();

      return snapshot.docs
          .map((doc) => HighlightModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> deleteHighlight(String highlightId) async {
    try {
      final highlightRef = _userDoc.collection('highlights').doc(highlightId);

      await highlightRef.delete();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  // ========== NOTES ==========

  @override
  Future<void> uploadNote(NoteModel note) async {
    try {
      final noteRef = _userDoc.collection('notes').doc(note.id);

      await noteRef.set(
        note.toFirestore(),
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<List<NoteModel>> downloadNotes() async {
    try {
      final notesRef = _userDoc.collection('notes');
      final snapshot = await notesRef.get();

      return snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      final noteRef = _userDoc.collection('notes').doc(noteId);

      await noteRef.delete();
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  // ========== METADATA ==========

  @override
  Future<SyncMetadataModel?> getSyncMetadata() async {
    try {
      final metadataRef = _userDoc.collection('metadata').doc('sync');
      final snapshot = await metadataRef.get();

      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      if (data == null) {
        return null;
      }

      return SyncMetadataModel.fromFirestore(data);
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<void> updateSyncMetadata(SyncMetadataModel metadata) async {
    try {
      final metadataRef = _userDoc.collection('metadata').doc('sync');

      await metadataRef.set(
        metadata.toFirestore(),
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  // ========== ERROR MAPPING ==========

  Exception _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return Exception('Permission denied. User not authenticated.');
      case 'unavailable':
      case 'deadline-exceeded':
        return Exception('Network error. Check your connection.');
      case 'not-found':
        return Exception('Document not found.');
      case 'already-exists':
        return Exception('Document already exists.');
      case 'resource-exhausted':
        return Exception('Quota exceeded.');
      case 'unauthenticated':
        return Exception('User not authenticated.');
      default:
        return Exception('Firestore error: ${e.message}');
    }
  }
}
