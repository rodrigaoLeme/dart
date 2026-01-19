class GenericErrorEntity {
  final String? data;
  final bool? success;
  final List<GenericErrorsEntity>? errors;

  GenericErrorEntity({
    required this.data,
    required this.success,
    required this.errors,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'success': success,
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }
}

class GenericErrorsEntity {
  final List<GenericSessionsEntity>? sessions;

  GenericErrorsEntity({
    required this.sessions,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessions': sessions?.map((s) => s.toJson()).toList(),
    };
  }
}

class GenericSessionsEntity {
  final int? index;
  final String? title;
  final String? error;

  GenericSessionsEntity({
    required this.index,
    required this.title,
    required this.error,
  });

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'title': title,
      'error': error,
    };
  }
}
