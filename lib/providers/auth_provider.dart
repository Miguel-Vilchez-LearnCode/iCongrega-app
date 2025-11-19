import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icongrega/core/errors/api_exception.dart';
import 'package:icongrega/domain/models/user.dart';
import 'package:icongrega/domain/repositories/auth_repository.dart';
import 'package:icongrega/domain/responses/login_response.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  bool _isLoading = false;
  String _emailForVerification = '';
  String _errorMessage = '';
  LoginResponse? _loginResponse;
  String? verificationError;

  bool get isLoading => _isLoading;
  String get emailForVerification => _emailForVerification;
  String get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;
  User? get currentUser => _loginResponse?.user;
  bool get isAuthenticated => _loginResponse != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _loginResponse = await _authRepository.login(email, password);
      if (kDebugMode) {
        debugPrint('Login exitoso: ${_loginResponse!.message}');
        debugPrint('Token: ${_loginResponse!.token}');
        debugPrint('Usuario: ${_loginResponse!.user.fullName}');
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      if (kDebugMode) {
        debugPrint('Error en login: $e');
      }
    } catch (e) {
      _errorMessage = 'Error inesperado. Intenta nuevamente.';
      if (kDebugMode) {
        debugPrint('Error inesperado en login: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerUser(Map<String, dynamic> body) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.register(body);

      setEmailForVerification(response["email"]);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      if (kDebugMode) {
        debugPrint('Error de registro: $e');
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado. Intenta nuevamente.';
      if (kDebugMode) {
        debugPrint('Error inesperado al registrar usuario: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<bool> verifyEmailCode(String code) async {
    if (_emailForVerification.isEmpty) {
      verificationError = 'No hay email pendiente de verificación';
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authRepository.verifyEmail(
        _emailForVerification,
        code,
      );

      // Crear LoginResponse y persistir sesión
      final loginResponse = LoginResponse(
        message: response["message"] ?? "Email verificado",
        token: response["token"],
        tokenType: response["token_type"],
        user: User.fromJson(response["user"]),
      );

      // Persistir la sesión como en el login
      _loginResponse = loginResponse;

      // Limpiar estado de verificación
      _emailForVerification = '';
      verificationError = null;

      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      verificationError = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      verificationError = 'Error inesperado. Intenta nuevamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // método para establecer el email pendiente
  void setEmailForVerification(String email) {
    _emailForVerification = email;
    verificationError = null;
    notifyListeners();
  }

  Future<String?> getStoredToken() {
    return _authRepository.accessToken;
  }

  Future<void> restoreSession() async {
    try {
      final storedSession = await _authRepository.loadStoredSession();
      _loginResponse = storedSession;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error restaurando sesión: $e');
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _loginResponse = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final imagePath = await _authRepository.uploadFile(imageFile);
      return imagePath;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      if (kDebugMode) {
        debugPrint('Error al subir imagen: $e');
      }
      return null;
    } catch (e) {
      _errorMessage = 'Error al subir imagen. Intenta nuevamente.';
      if (kDebugMode) {
        debugPrint('Error inesperado al subir imagen: $e');
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserProfile({String? profileImage, String? about}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final updatedUser = await _authRepository.updateProfile(
        profileImage: profileImage,
        about: about,
      );

      // Actualizar el usuario en el loginResponse
      if (_loginResponse != null) {
        _loginResponse = LoginResponse(
          message: _loginResponse!.message,
          token: _loginResponse!.token,
          tokenType: _loginResponse!.tokenType,
          user: updatedUser,
        );
      }

      if (kDebugMode) {
        debugPrint('Perfil actualizado exitosamente');
      }

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      if (kDebugMode) {
        debugPrint('Error al actualizar perfil: $e');
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar perfil. Intenta nuevamente.';
      if (kDebugMode) {
        debugPrint('Error inesperado al actualizar perfil: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
