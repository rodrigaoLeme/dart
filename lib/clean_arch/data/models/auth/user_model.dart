import '../../../domain/entities/auth/auth.dart';

class UserModel {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isEmailVerified;
  final String? providerId;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  const UserModel({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
    required this.isEmailVerified,
    this.providerId,
    this.createdAt,
    this.lastSignInAt,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      isAnonymous: isAnonymous,
      isEmailVerified: isEmailVerified,
      providerId: providerId,
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      isAnonymous: entity.isAnonymous,
      isEmailVerified: entity.isEmailVerified,
      providerId: entity.providerId,
      createdAt: entity.createdAt,
      lastSignInAt: entity.lastSignInAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      providerId: json['providerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastSignInAt: json['lastSignInAt'] != null
          ? DateTime.parse(json['lastSignInAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'isEmailVerified': isEmailVerified,
      'providerId': providerId,
      'createdAt': createdAt,
      'lastSignInAt': lastSignInAt,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl &&
        other.isAnonymous == isAnonymous &&
        other.isEmailVerified == isEmailVerified &&
        other.providerId == providerId;
  }

  @override
  int get hashCode => Object.hash(id, email, displayName, photoUrl, isAnonymous,
      isEmailVerified, providerId);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, isAnonymous: $isAnonymous, providerId: $providerId)';
  }
}
