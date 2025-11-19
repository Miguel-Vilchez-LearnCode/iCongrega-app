import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'http_result.dart';
import 'parse_response_body.dart';
import 'send_request.dart';
import 'http_method.dart';

typedef Parser<T> = T Function(dynamic data);

class Http {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  Http();
  Future<HttpResult<T>> request<T>(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
    dynamic body,
    Parser<T>? parser,
    Duration timeOut = const Duration(seconds: 10),
  }) async {
    int? statusCode;
    dynamic data;
    String? rawBody;
    try {
      // Implementación de la solicitud HTTP aquí
      late Uri url;

      if (path.startsWith('http://') || path.startsWith('https://')) {
        url = Uri.parse(path);
      } else {
        url = Uri.parse('$baseUrl$path');
      }

      if (queryParameters.isNotEmpty) {
        url = url.replace(
          queryParameters: {...url.queryParameters, ...queryParameters},
        );
      }

      final response = await sendRequest(
        url: url,
        method: method,
        headers: headers,
        body: body,
        timeOut: timeOut,
      );

      rawBody = response.body;
      data = parseResponseBody(rawBody);
      statusCode = response.statusCode;
      if (statusCode >= 400) {
        throw HttpError(
          data: data,
          exception: null,
          stackTrace: StackTrace.current,
          statusCode: statusCode,
          body: rawBody,
        );
      }

      return HttpResult<T>(
        data: parser != null ? parser(data) : data,
        statusCode: statusCode,
        error: null,
        body: rawBody,
      );
    } catch (e, s) {
      if (e is HttpError) {
        return HttpResult<T>(
          data: null,
          statusCode: e.statusCode ?? statusCode ?? -1,
          error: e,
          body: e.body,
        );
      }

      return HttpResult<T>(
        data: null,
        statusCode: statusCode ?? -1,
        error: HttpError(
          exception: e,
          stackTrace: s,
          data: data,
          statusCode: statusCode,
          body: rawBody,
        ),
        body: rawBody,
      );
    }
  }
}
