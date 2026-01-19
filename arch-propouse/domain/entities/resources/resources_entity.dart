class ResourcesEntity {
  final bool? success;
  final String? error;
  final List<ResourceEntity>? data;

  ResourcesEntity({
    required this.success,
    required this.error,
    required this.data,
  });
}

class ResourceEntity {
  final String? resource;
  final bool? create;
  final bool? edit;
  final bool? view;
  final bool? delete;
  final bool? approve;

  ResourceEntity({
    required this.resource,
    required this.create,
    required this.edit,
    required this.view,
    required this.delete,
    required this.approve,
  });
}
