import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icongrega/data/helpers/http.dart';
import 'package:icongrega/data/helpers/http_method.dart';
import 'package:icongrega/domain/responses/login_response.dart';

class AuthAPI {
  final Http _http;
  final String version = dotenv.env['API_VERSION'] ?? 'v1';
  final String appApiKey = dotenv.env['APP_API_KEY'] ?? '';

  AuthAPI(this._http);
  Future<LoginResponse> login(String email, String password) async {
    // implementar la logica de login
    final result = await _http.request(
      '/api/$version/auth/login',
      method: HttpMethod.post,
      body: {'email': email, 'password': password},
    );

    // print("Result data: ${result.data}");
    // print("Result data runtimeType: ${result.data.runtimeType}");
    // print("Result error : ${result.error}");
    // print("Result statusCode : ${result.statusCode}");

    print('Status Code: ${result.statusCode}');
    print('Response Body: ${result.body}');

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      return LoginResponse.fromJson(jsonResponse);
    } else if (result.statusCode == 401) {
      // Credenciales incorrectas
      final errorResponse = json.decode(result.body);
      throw Exception(errorResponse['message'] ?? 'Credenciales incorrectas');
    } else {
      // Otros errores
      throw Exception('Error en el servidor: ${result.statusCode}');
    }

  }
}
