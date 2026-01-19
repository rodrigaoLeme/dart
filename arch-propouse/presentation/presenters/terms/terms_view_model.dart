import '../../../domain/entities/terms/terms_entity.dart';

class TermsViewModel {
  final UserTermsViewModel? data;
  final bool? success;

  TermsViewModel({
    required this.success,
    required this.data,
  });
}

class UserTermsViewModel {
  final String? id;
  final String? policy;
  final String? term;
  final bool? current;
  final String? version;

  UserTermsViewModel({
    required this.id,
    required this.policy,
    required this.term,
    required this.current,
    required this.version,
  });
}

extension TermsViewModelExtensions on TermsEntity {
  TermsViewModel toViewModel() => TermsViewModel(
        success: success,
        data: data?.toViewModel(),
      );
}

extension UserTermsViewModelExtensions on UserTermsEntity {
  UserTermsViewModel toViewModel() => UserTermsViewModel(
        id: id,
        policy: policy,
        term: term,
        current: current,
        version: version,
      );
}
