import '../../../domain/usecases/sync/sync.dart';
import './sync_usecases_factory.dart';

class SyncFactory {
  // ========== PROGRESS ==========

  static UploadProgress makeUploadProgress() {
    return SyncUsecasesFactory.makeUploadProgress();
  }

  static DownloadProgress makeDownloadProgress() {
    return SyncUsecasesFactory.makeDownloadProgress();
  }

  // ========== HIGHLIGHTS ==========

  static UploadHighlight makeUploadHighlight() {
    return SyncUsecasesFactory.makeUploadHighlight();
  }

  static DownloadHighlights makeDownloadHighlights() {
    return SyncUsecasesFactory.makeDownloadHighlights();
  }

  static DeleteHighlight makeDeleteHighlight() {
    return SyncUsecasesFactory.makeDeleteHighlight();
  }

  // ========== NOTAS ==========

  static UploadNote makeUploadNote() {
    return SyncUsecasesFactory.makeUploadNote();
  }

  static DownloadNotes makekDownloadNotes() {
    return SyncUsecasesFactory.makeDownloadNotes();
  }

  static DeleteNote makeDeleteNote() {
    return SyncUsecasesFactory.makeDeleteNote();
  }

  // ========== METADATA ==========

  static GetSyncMetadata makeGetSyncMetadata() {
    return SyncUsecasesFactory.makeGetSyncMetadata();
  }
}
