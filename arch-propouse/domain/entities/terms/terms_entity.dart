class TermsEntity {
  final UserTermsEntity? data;
  final bool? success;

  TermsEntity({
    required this.data,
    required this.success,
  });
}

class UserTermsEntity {
  final String? id;
  final String? policy;
  final String? term;
  final bool? current;
  final String? version;

  UserTermsEntity({
    required this.id,
    required this.policy,
    required this.term,
    required this.current,
    required this.version,
  });
}
