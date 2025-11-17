class HttpResult<T> {
  final T? data;
  final int statusCode;
  final HttpError? error;
  final T? body;

  HttpResult({
    required this.data,
    required this.statusCode,
    required this.error,
    this.body,
  });
}

class HttpError {
  final Object? exception;
  final StackTrace stackTrace;
  final dynamic data;

  HttpError({
    required this.exception,
    required this.stackTrace,
    required this.data,
  });
}
