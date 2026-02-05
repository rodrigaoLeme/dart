import '../../../data/usecases/sync/sync.dart';
import '../../../domain/usecases/sync/sync.dart';
import './firestore_sync_datasource_factory.dart';

class SyncUsecasesFactory {
  static final _repository = FirestoreSyncDatasourceFactory.make();

  // ========== PROGRESS ==========

  static UploadProgress makeUploadProgress() {
    return RemoteUploadProgress(repository: _repository);
  }

  static DownloadProgress makeDownloadProgress() {
    return RemoteDownloadProgress(repository: _repository);
  }

  // ========== HIGHLIGHTS ==========

  static UploadHighlight makeUploadHighlight() {
    return RemoteUploadHighlight(repository: _repository);
  }

  static DownloadHighlights makeDownloadHighlights() {
    return RemoteDownloadHighlights(repository: _repository);
  }

  static DeleteHighlight makeDeleteHighlight() {
    return RemoteDeleteHighlight(repository: _repository);
  }

  // ========== NOTAS ==========

  static UploadNote makeUploadNote() {
    return RemoteUploadNote(repository: _repository);
  }

  static DownloadNotes makeDownloadNotes() {
    return RemoteDownloadNotes(repository: _repository);
  }

  static DeleteNote makeDeleteNote() {
    return RemoteDeleteNote(repository: _repository);
  }

  // ========== METADATA ==========

  static GetSyncMetadata makeGetSyncMetadata() {
    return RemoteGetSyncMetadata(repository: _repository);
  }
}
