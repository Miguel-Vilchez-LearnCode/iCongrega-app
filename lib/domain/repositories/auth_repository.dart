import 'dart:io';

import '../models/user.dart';
import '../responses/login_response.dart';

abstract class AuthRepository {
  Future<String?> get accessToken;

  Future<LoginResponse> login(String email, String password);

  Future<LoginResponse?> loadStoredSession();

  Future<void> logout();

  Future<Map<String, dynamic>> register(Map<String, dynamic> body);

  Future<Map<String, dynamic>> verifyEmail(String email, String code);

  Future<String> uploadFile(File file);

  Future<User> updateProfile({String? profileImage, String? about});
}
