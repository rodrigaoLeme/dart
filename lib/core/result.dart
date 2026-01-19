enum ResultStatus {
  success,
  error,
  loading,
}

class Result<T> {
  final ResultStatus status;
  final T? data;
  final String? error;

  const Result._({
    required this.status,
    this.data,
    this.error,
  });

  factory Result.success(T data) {
    return Result._(status: ResultStatus.success, data: data);
  }

  factory Result.error(String error) {
    return Result._(status: ResultStatus.error, error: error);
  }

  factory Result.loading() {
    return const Result._(status: ResultStatus.loading);
  }

  bool get isSuccess => status == ResultStatus.success;
  bool get isError => status == ResultStatus.error;
  bool get isLoading => status == ResultStatus.loading;

  Result<R> when<R>({
    required R Function(T data) success,
    required R Function(String error) error,
    required R Function() loading,
  }) {
    switch (status) {
      case ResultStatus.success:
        return Result.success(success(data as T));
      case ResultStatus.error:
        return Result.error(this.error!);
      case ResultStatus.loading:
        return Result.loading();
    }
  }

  @override
  String toString() {
    switch (status) {
      case ResultStatus.success:
        return 'Result.success($data)';
      case ResultStatus.error:
        return 'Result.error($error)';
      case ResultStatus.loading:
        return 'Result.loading()';
    }
  }
}
