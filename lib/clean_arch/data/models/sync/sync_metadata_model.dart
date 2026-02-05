import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sync/sync.dart';

class SyncMetadataModel {
  final DateTime lastSyncAt;
  final String deviceId;
  final String appVersion;
  final bool hasPendingChanges;

  const SyncMetadataModel({
    required this.lastSyncAt,
    required this.deviceId,
    required this.appVersion,
    this.hasPendingChanges = false,
  });

  SyncMetadataEntity toEntity() {
    return SyncMetadataEntity(
      lastSyncAt: lastSyncAt,
      deviceId: deviceId,
      appVersion: appVersion,
      hasPendingChanges: hasPendingChanges,
    );
  }

  factory SyncMetadataModel.fromEntity(SyncMetadataEntity entity) {
    return SyncMetadataModel(
      lastSyncAt: entity.lastSyncAt,
      deviceId: entity.deviceId,
      appVersion: entity.appVersion,
      hasPendingChanges: entity.hasPendingChanges,
    );
  }

  factory SyncMetadataModel.fromFirestore(Map<String, dynamic> data) {
    return SyncMetadataModel(
      lastSyncAt: (data['lastSyncAt'] as Timestamp).toDate(),
      deviceId: data['deviceId'] as String,
      appVersion: data['appVersion'] as String,
      hasPendingChanges: data['hasPendingChanges'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lastSyncAt': Timestamp.fromDate(lastSyncAt),
      'deviceId': deviceId,
      'appVersion': appVersion,
      'hasPendingChanges': hasPendingChanges,
    };
  }
}
