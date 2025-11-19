class HttpResult<T> {
  final T? data;
  final int statusCode;
  final HttpError? error;
  final String? body;

  HttpResult({
    required this.data,
    required this.statusCode,
    required this.error,
    required this.body,
  });
}

class HttpError {
  final Object? exception;
  final StackTrace stackTrace;
  final dynamic data;
  final int? statusCode;
  final String? body;

  HttpError({
    required this.exception,
    required this.stackTrace,
    required this.data,
    this.statusCode,
    this.body,
  });
}
