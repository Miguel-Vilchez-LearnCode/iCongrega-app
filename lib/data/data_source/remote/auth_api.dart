import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:icongrega/core/errors/api_exception.dart';
import 'package:icongrega/data/helpers/http.dart';
import 'package:icongrega/data/helpers/http_method.dart';
import 'package:icongrega/domain/responses/login_response.dart';

class AuthAPI {
  final Http _http;
  final String version = dotenv.env['API_VERSION'] ?? 'v1';
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final String appApiKey = dotenv.env['APP_API_KEY'] ?? '';

  AuthAPI(this._http);

  Future<LoginResponse> login(String email, String password) async {
    final result = await _http.request<Map<String, dynamic>>(
      '/api/$version/auth/login',
      method: HttpMethod.post,
      body: {'email': email, 'password': password},
      parser: (data) => Map<String, dynamic>.from(data as Map),
    );

    if (kDebugMode) {
      debugPrint('Status Code: ${result.statusCode}');
      debugPrint('Response Body: ${result.body}');
    }

    if (result.error != null) {
      final message =
          _extractErrorMessage(result.error?.data) ??
          'Error en el servidor: ${result.statusCode}';
      throw ApiException(message, statusCode: result.statusCode);
    }

    final data = result.data;
    if (data == null) {
      throw ApiException(
        'Respuesta vacía del servidor',
        statusCode: result.statusCode,
      );
    }

    return LoginResponse.fromJson(data);
  }

  String? _extractErrorMessage(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      return errorData['message'] as String?;
    }
    if (errorData is String) {
      return errorData;
    }
    return null;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final result = await _http.request<Map<String, dynamic>>(
      '/api/$version/auth/register',
      method: HttpMethod.post,
      body: payload,
    );

    if (kDebugMode) {
      debugPrint('Status Code: ${result.statusCode}');
      debugPrint('Response Body: ${result.body}');
    }

    if (result.error != null) {
      final message =
          _extractErrorMessage(result.error?.data) ??
          'Error en el servidor: ${result.statusCode}';
      throw ApiException(message, statusCode: result.statusCode);
    }

    return result.data!;
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    final result = await _http.request<Map<String, dynamic>>(
      '/api/$version/auth/verify-email',
      method: HttpMethod.post,
      body: {"email": email, "code": code},
    );

    if (kDebugMode) {
      debugPrint('Status Code: ${result.statusCode}');
      debugPrint('Response Body: ${result.body}');
    }

    if (result.error != null) {
      final message =
          _extractErrorMessage(result.error?.data) ??
          'Error en el servidor: ${result.statusCode}';
      throw ApiException(message, statusCode: result.statusCode);
    }

    return result.data!;
  }

  Future<Map<String, dynamic>> uploadFile(
    File file,
    String token,
    int userId,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/api/$version/upload/file');
      final request = http.MultipartRequest('POST', uri);

      // Agregar headers
      request.headers['Authorization'] = token;
      request.headers['Accept'] = 'application/json';
      if (appApiKey.isNotEmpty) {
        request.headers['app-api-key'] = appApiKey;
      }

      // Agregar campos requeridos por el backend
      request.fields['folder'] = 'users/$userId';
      request.fields['content_type'] = 'user_image';

      // Agregar archivo
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      if (kDebugMode) {
        debugPrint('Uploading file: ${file.path}');
        debugPrint('To URL: $uri');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        debugPrint('Upload File Status Code: ${response.statusCode}');
        debugPrint('Upload File Response: ${response.body}');
      }

      if (response.statusCode >= 400) {
        final errorData = jsonDecode(response.body);
        final message =
            _extractErrorMessage(errorData) ??
            'Error al subir archivo: ${response.statusCode}';
        throw ApiException(message, statusCode: response.statusCode);
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      if (kDebugMode) {
        debugPrint('Error uploading file: $e');
      }
      throw ApiException('Error al subir archivo: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? profileImage,
    String? about,
    required String token,
  }) async {
    final body = <String, dynamic>{};

    if (profileImage != null) {
      body['profile_image'] = profileImage;
    }

    if (about != null) {
      body['about'] = about;
    }

    final result = await _http.request<Map<String, dynamic>>(
      '/api/$version/auth/profile',
      method: HttpMethod.put,
      body: body,
      headers: {'Authorization': token},
    );

    if (kDebugMode) {
      debugPrint('Update Profile Status Code: ${result.statusCode}');
      debugPrint('Update Profile Response: ${result.body}');
    }

    if (result.error != null) {
      final message =
          _extractErrorMessage(result.error?.data) ??
          'Error al actualizar perfil: ${result.statusCode}';
      throw ApiException(message, statusCode: result.statusCode);
    }

    return result.data!;
  }
}
