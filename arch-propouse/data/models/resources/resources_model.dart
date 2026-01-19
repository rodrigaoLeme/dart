import '../../../domain/entities/resources/resources_entity.dart';
import '../../http/http.dart';

class ResourcesModel {
  final bool? success;
  final String? error;
  final List<ResourceModel>? data;

  ResourcesModel({
    required this.success,
    required this.error,
    required this.data,
  });

  factory ResourcesModel.fromJson(Map json) {
    if (!json.containsKey('success')) {
      throw HttpError.invalidData;
    }

    return ResourcesModel(
      success: json['success'],
      error: json['error'],
      data: json['data']
          .map<ResourceModel>((dataJson) => ResourceModel.fromJson(dataJson))
          .toList(),
    );
  }

  ResourcesEntity toEntity() => ResourcesEntity(
        success: success,
        error: error,
        data: data?.map<ResourceEntity>((data) => data.toEntity()).toList(),
      );

  factory ResourcesModel.fromEntity(ResourcesEntity entity) => ResourcesModel(
        success: entity.success,
        error: entity.error,
        data: entity.data?.map((e) => ResourceModel.fromEntity(e)).toList(),
      );

  Map toJson() => {
        'success': success,
        'key': error,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class ResourceModel {
  final String? resource;
  final bool? create;
  final bool? edit;
  final bool? view;
  final bool? delete;
  final bool? approve;

  ResourceModel({
    required this.resource,
    required this.create,
    required this.edit,
    required this.view,
    required this.delete,
    required this.approve,
  });

  factory ResourceModel.fromJson(Map json) {
    if (!json.containsKey('resource')) {
      throw HttpError.invalidData;
    }
    return ResourceModel(
      resource: json['resource'],
      create: json['create'],
      edit: json['edit'],
      view: json['view'],
      delete: json['delete'],
      approve: json['approve'],
    );
  }
  ResourceEntity toEntity() => ResourceEntity(
        resource: resource,
        create: create,
        edit: edit,
        view: view,
        delete: delete,
        approve: approve,
      );

  factory ResourceModel.fromEntity(ResourceEntity entity) => ResourceModel(
        resource: entity.resource,
        create: entity.create,
        edit: entity.edit,
        view: entity.view,
        delete: entity.delete,
        approve: entity.approve,
      );

  Map toJson() => {
        'resource': resource,
        'create': create,
        'edit': edit,
        'view': view,
        'delete': delete,
        'approve': approve,
      };
}
