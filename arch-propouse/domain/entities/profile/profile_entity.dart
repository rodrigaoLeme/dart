class ProfileEntity {
  final String? userId;
  final String? name;
  final String? entityId;
  final String? entityName;
  final int? level;
  final bool? hasAcceptedTerm;
  final bool? isDefault;
  final ProfileImageEntity? profileImage;

  ProfileEntity({
    required this.userId,
    required this.name,
    required this.entityId,
    required this.entityName,
    required this.level,
    required this.hasAcceptedTerm,
    required this.isDefault,
    required this.profileImage,
  });
}

class ProfileImageEntity {
  final String? name;
  final String? content;
  final String? url;

  ProfileImageEntity({
    required this.name,
    required this.content,
    required this.url,
  });
}
