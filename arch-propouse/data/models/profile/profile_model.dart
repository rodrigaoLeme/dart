import '../../../domain/entities/profile/profile_entity.dart';
import '../../http/http_error.dart';

class ProfileModel {
  final String? userId;
  final String? name;
  final String? entityId;
  final String? entityName;
  final int? level;
  final bool? hasAcceptedTerm;
  final bool? isDefault;
  final ProfileImageModel? profileImage;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.entityId,
    required this.entityName,
    required this.level,
    required this.hasAcceptedTerm,
    required this.isDefault,
    required this.profileImage,
  });

  factory ProfileModel.fromJson(Map json) {
    if (!json.containsKey('userId')) {
      throw HttpError.invalidData;
    }
    return ProfileModel(
      userId: json['userId'],
      name: json['name'],
      entityId: json['entityId'],
      entityName: json['entityName'],
      level: json['level'],
      hasAcceptedTerm: json['hasAcceptedTerm'],
      isDefault: json['isDefault'],
      profileImage: ProfileImageModel.fromJson(json['profileImage']),
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
        userId: entity.userId,
        name: entity.name,
        entityId: entity.entityId,
        entityName: entity.entityName,
        level: entity.level,
        hasAcceptedTerm: entity.hasAcceptedTerm,
        isDefault: entity.isDefault,
        profileImage: entity.profileImage != null
            ? ProfileImageModel.fromEntity(entity.profileImage!)
            : null,
      );

  ProfileEntity toEntity() => ProfileEntity(
        userId: userId,
        name: name,
        entityId: entityId,
        entityName: entityName,
        level: level,
        hasAcceptedTerm: hasAcceptedTerm,
        isDefault: isDefault,
        profileImage: profileImage?.toEntity(),
      );

  Map toJson() => {
        'userId': userId,
        'name': name,
        'entityId': entityId,
        'entityName': entityName,
        'level': level,
        'hasAcceptedTerm': hasAcceptedTerm,
        'isDefault': isDefault,
        'profileImage': profileImage?.toJson(),
      };
}

class ProfileImageModel {
  final String? name;
  final String? content;
  final String? url;

  ProfileImageModel({
    required this.name,
    required this.content,
    required this.url,
  });

  factory ProfileImageModel.fromJson(Map json) {
    if (!json.containsKey('name')) {
      throw HttpError.invalidData;
    }
    return ProfileImageModel(
      name: json['name'],
      content: json['content'],
      url: json['url'],
    );
  }

  factory ProfileImageModel.fromEntity(ProfileImageEntity entity) =>
      ProfileImageModel(
        name: entity.name,
        content: entity.content,
        url: entity.url,
      );

  ProfileImageEntity toEntity() => ProfileImageEntity(
        name: name,
        content: content,
        url: url,
      );

  Map toJson() => {
        'name': name,
        'content': content,
        'url': url,
      };
}
