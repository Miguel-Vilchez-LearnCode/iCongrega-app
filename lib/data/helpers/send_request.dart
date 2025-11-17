import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'http_method.dart';

dynamic _parseBody(dynamic body) {
  try {
    return json.encode(body.toJson());
    // return jsonEncode(body);
  } catch (_) {
    return body;
  }
}

Future<Response> sendRequest({
  required Uri url,
  required HttpMethod method,
  required Map<String, String> headers,
  required dynamic body,
  required Duration timeOut,
}) {
  var finalHeader = {...headers};
  // Implementación de la solicitud HTTP
  if (method != HttpMethod.get) {
    final contentType = headers['Content-Type'];

    final appApiKey = dotenv.env['APP_API_KEY'] ?? '';

    if (contentType == null || contentType.contains("application/json")) {
      finalHeader['Content-Type'] = 'application/json; charset=UTF-8';
      finalHeader['app-api-key'] = appApiKey;
      finalHeader['Accept'] = 'application/json';
      body = _parseBody(body);
    }
  }
  final client = Client();

  switch (method) {
    case HttpMethod.get:
      // Lógica para solicitud GET
      return client.get(url, headers: finalHeader).timeout(timeOut);
    case HttpMethod.post:
      // Lógica para solicitud POST
      return client
          .post(url, headers: finalHeader, body: body)
          .timeout(timeOut);
    case HttpMethod.put:
      // Lógica para solicitud PUT
      return client.put(url, headers: finalHeader, body: body).timeout(timeOut);
    case HttpMethod.delete:
      // Lógica para solicitud DELETE
      return client
          .delete(url, headers: finalHeader, body: body)
          .timeout(timeOut);
  }
}
