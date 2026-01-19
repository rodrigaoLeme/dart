import '../../../domain/entities/profile/profile_entity.dart';

class ProfileViewModel {
  final String? userId;
  final String? name;
  final String? entityId;
  final String? entityName;
  final int? level;
  final bool? hasAcceptedTerm;
  final bool? isDefault;
  final ProfileImageViewModel? profileImage;
  final String version;

  ProfileViewModel({
    required this.userId,
    required this.name,
    required this.entityId,
    required this.entityName,
    required this.level,
    required this.hasAcceptedTerm,
    required this.isDefault,
    required this.profileImage,
    required this.version,
  });
}

class ProfileImageViewModel {
  final String? name;
  final String? content;
  final String? url;

  ProfileImageViewModel({
    required this.name,
    required this.content,
    required this.url,
  });
}

extension ProfileViewModelExtensions on ProfileEntity {
  ProfileViewModel toViewModel(String version) => ProfileViewModel(
      userId: userId,
      name: name,
      entityId: entityId,
      entityName: entityName,
      level: level,
      hasAcceptedTerm: hasAcceptedTerm,
      isDefault: isDefault,
      profileImage: profileImage?.toViewModel(),
      version: version);
}

extension ProfileImageViewModelExtensions on ProfileImageEntity {
  ProfileImageViewModel toViewModel() => ProfileImageViewModel(
        name: name,
        content: content,
        url: url,
      );
}
