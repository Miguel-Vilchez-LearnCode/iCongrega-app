import 'dart:convert';
import 'dart:io';

import 'package:icongrega/domain/models/user.dart';
import 'package:icongrega/data/data_source/remote/auth_api.dart';
import 'package:icongrega/domain/repositories/auth_repository.dart';
import 'package:icongrega/domain/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthAPI _authAPI;

  AuthRepositoryImpl(this._authAPI);

  @override
  Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final tokenType = prefs.getString('token_type');

    if (token == null || token.isEmpty) return null;

    return tokenType != null && tokenType.isNotEmpty
        ? '$tokenType $token'
        : token;
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await _authAPI.login(email, password);
    await _persistSession(response);
    return response;
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> body) {
    return _authAPI.register(body);
  }

  @override
  Future<LoginResponse?> loadStoredSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final tokenType = prefs.getString('token_type') ?? 'Bearer';

    if (token == null || token.isEmpty) {
      return null;
    }

    Map<String, dynamic>? userMap;
    final userJsonString = prefs.getString('user_json');
    if (userJsonString != null && userJsonString.isNotEmpty) {
      userMap = jsonDecode(userJsonString) as Map<String, dynamic>;
    } else {
      final userId = prefs.getInt('user_id');
      final userName = prefs.getString('user_name');
      final userEmail = prefs.getString('user_email');

      if (userId != null && userName != null && userEmail != null) {
        final parts = userName.split(' ');
        final firstName = parts.isNotEmpty ? parts.first : '';
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        userMap = {
          'id': userId,
          'name': firstName,
          'lastname': lastName,
          'email': userEmail,
        };
      }
    }

    if (userMap == null) {
      return null;
    }

    return LoginResponse(
      message: 'stored_session',
      token: token,
      tokenType: tokenType,
      user: User.fromJson(userMap),
    );
  }

  Future<void> _persistSession(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', response.token);
    await prefs.setString('token_type', response.tokenType);
    await prefs.setInt('user_id', response.user.id);
    await prefs.setString('user_name', response.user.fullName);
    await prefs.setString('user_email', response.user.email);
    await prefs.setString('user_json', jsonEncode(response.user.toJson()));
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final response = await _authAPI.verifyEmail(email: email, code: code);

    // Si la verificación es exitosa, persistir la sesión
    if (response.containsKey('token') && response.containsKey('user')) {
      final loginResponse = LoginResponse(
        message: response['message'],
        token: response['token'],
        tokenType: response['token_type'],
        user: User.fromJson(response['user']),
      );
      await _persistSession(loginResponse);
    }

    return response;
  }

  @override
  Future<String> uploadFile(File file) async {
    final token = await accessToken;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    // Obtener el ID del usuario desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('No se encontró el ID del usuario');
    }

    final response = await _authAPI.uploadFile(file, token, userId);

    // El backend debería devolver la ruta del archivo
    // Ajusta esto según la estructura de respuesta de tu API
    return response['path'] ?? response['url'] ?? response['file_path'] ?? '';
  }

  @override
  Future<User> updateProfile({String? profileImage, String? about}) async {
    final token = await accessToken;
    if (token == null) {
      throw Exception('No hay token de autenticación');
    }

    final response = await _authAPI.updateProfile(
      profileImage: profileImage,
      about: about,
      token: token,
    );

    // Actualizar el usuario en la sesión
    final updatedUser = User.fromJson(response['user']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_json', jsonEncode(updatedUser.toJson()));

    return updatedUser;
  }
}
