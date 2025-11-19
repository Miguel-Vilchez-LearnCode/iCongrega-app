import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'http_method.dart';

String? _encodeBody(dynamic body) {
  if (body == null) return null;
  if (body is String) return body;
  if (body is List || body is Map) {
    return jsonEncode(body);
  }

  try {
    // Intentar serializar objetos con toJson
    final dynamic jsonReady = body.toJson();
    return jsonEncode(jsonReady);
  } catch (_) {
    try {
      return jsonEncode(body);
    } catch (_) {
      return body.toString();
    }
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
  final appApiKey = dotenv.env['APP_API_KEY'] ?? '';
  // Implementación de la solicitud HTTP
  if (method != HttpMethod.get) {
    final contentType = headers['Content-Type'];

    if (contentType == null || contentType.contains("application/json")) {
      finalHeader['Content-Type'] = 'application/json; charset=UTF-8';
      finalHeader['Accept'] = 'application/json';
    }

    if (appApiKey.isNotEmpty) {
      finalHeader['app-api-key'] = appApiKey;
    }

    body = _encodeBody(body);
  } else {
    if (appApiKey.isNotEmpty) {
      finalHeader['app-api-key'] = appApiKey;
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
