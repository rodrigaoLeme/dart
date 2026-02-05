import '../models/sync/sync.dart';

abstract class SyncRepository {
  // ========== PROGRESSO DO PLANO ANUAL ==========

  /// Envia progresso para o Firestore
  Future<void> uploadProgress(ReadingProgressModel progress);

  /// Baixa progresso do Firestore
  Future<ReadingProgressModel?> downloadProgress();

  // ========== MARCAÇÕES ==========

  /// Envia marcaçÕes para o Firestore
  Future<void> uploadHighlight(HighlightModel highlight);

  /// Baixa todas as marcações do Firestore
  Future<List<HighlightModel>> downloadHighlights();

  /// Deleta marcações do Firestore
  Future<void> deleteHighlight(String highlightId);

  // ========== NOTAS ==========

  /// Envia nota para o FIrestore
  Future<void> uploadNote(NoteModel note);

  /// Baixa todas as notas do Firestore
  Future<List<NoteModel>> downloadNotes();

  /// Deleta toas as notas do Firestore
  Future<void> deleteNote(String noteId);

  // ========== METADATA ==========

  /// Pega metadados de sincronização
  Future<SyncMetadataModel?> getSyncMetadata();

  /// Atualiza metadados de sincronização
  Future<void> updateSyncMetadata(SyncMetadataModel metadata);
}
