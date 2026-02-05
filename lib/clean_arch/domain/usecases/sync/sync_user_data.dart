/// Faz a sincronização do:
/// - Processo de leitura
/// - Marcações
/// - Notas
abstract class SyncUserData {
  /// Sincroniza todos os dados do usuário com o Firestore
  ///
  /// COmo ele processa:
  /// 1. Baixa dados do Firestore
  /// 2. Compara timestamps
  /// 3. Atualiza local se Firestore for mais recente
  /// 4. Atualiza Firestore se local for mais recente
  ///
  /// ForceUpload - Se for true, força o upload mesmo se não houver mudanças
  Future<SyncResultEntity> call({bool forceUpload = false});
}

class SyncResultEntity {
  final bool success;
  final String? errorMessage;
  final DateTime syncedAt;
  final bool progressUpdated;
  final int highLightsUploaded;
  final int notesUploaded;

  const SyncResultEntity({
    required this.success,
    this.errorMessage,
    required this.syncedAt,
    this.progressUpdated = false,
    this.highLightsUploaded = 0,
    this.notesUploaded = 0,
  });

  factory SyncResultEntity.success({
    bool progressUpdated = false,
    int highLightsUploaded = 0,
    int notesUploaded = 0,
  }) {
    return SyncResultEntity(
      success: true,
      syncedAt: DateTime.now(),
      progressUpdated: progressUpdated,
      highLightsUploaded: highLightsUploaded,
      notesUploaded: notesUploaded,
    );
  }

  factory SyncResultEntity.failure(String errorMessage) {
    return SyncResultEntity(
        success: false, errorMessage: errorMessage, syncedAt: DateTime.now());
  }
}
