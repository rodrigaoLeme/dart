class SyncMetadataEntity {
  final DateTime lastSyncAt;
  final String deviceId;
  final String appVersion;
  final bool hasPendingChanges;

  const SyncMetadataEntity({
    required this.lastSyncAt,
    required this.deviceId,
    required this.appVersion,
    this.hasPendingChanges = false,
  });

  SyncMetadataEntity copyWith({
    DateTime? lastSyncAt,
    String? deviceId,
    String? appVersion,
    bool? hasPendingChanges,
  }) {
    return SyncMetadataEntity(
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      deviceId: deviceId ?? this.deviceId,
      appVersion: appVersion ?? this.appVersion,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
    );
  }
}
