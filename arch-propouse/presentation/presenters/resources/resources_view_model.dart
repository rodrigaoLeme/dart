import '../../../domain/entities/resources/resources_entity.dart';

class ResourcesViewModel {
  final bool? success;
  final String? error;
  final List<ResourceViewModel>? data;

  ResourcesViewModel({
    required this.success,
    required this.error,
    required this.data,
  });
}

class ResourceViewModel {
  final String? resource;
  final bool? create;
  final bool? edit;
  final bool? view;
  final bool? delete;
  final bool? approve;

  ResourceViewModel({
    required this.resource,
    required this.create,
    required this.edit,
    required this.view,
    required this.delete,
    required this.approve,
  });
}

extension ResourcesViewModelExtensions on ResourcesEntity {
  ResourcesViewModel toViewModel() => ResourcesViewModel(
        success: success,
        error: error,
        data: data
            ?.map(
              (element) => element.toViewModel(),
            )
            .toList(),
      );
}

extension ResourceViewModelExtensions on ResourceEntity {
  ResourceViewModel toViewModel() => ResourceViewModel(
        resource: resource,
        create: create,
        edit: edit,
        view: view,
        delete: delete,
        approve: approve,
      );
}
