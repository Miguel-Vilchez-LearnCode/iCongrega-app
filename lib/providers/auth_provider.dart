import 'package:flutter/material.dart';
import 'package:icongrega/data/data_source/remote/auth_api.dart';
import 'package:icongrega/data/helpers/http.dart';
import 'package:icongrega/domain/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  bool _isLoading = false;
  String _errorMessage = '';
  LoginResponse? _loginResponse;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _loginResponse = await AuthAPI(Http()).login(email, password); 
      
      // Login exitoso - guardar el token
      print('Login exitoso: ${_loginResponse!.message}');
      print('Token: ${_loginResponse!.token}');
      print('Usuario: ${_loginResponse!.user.fullName}');
      
      // guardar el token en SharedPreferences
      await _saveToken(_loginResponse!.token);
      
    } catch (e) {
      _errorMessage = e.toString();
      print('Error en login: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    try {

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('token_type', _loginResponse?.tokenType ?? 'Bearer');
      await prefs.setInt('user_id', _loginResponse?.user.id ?? 0);
      await prefs.setString('user_name', _loginResponse?.user.fullName ?? '');
      await prefs.setString('user_email', _loginResponse?.user.email ?? '');
      
      print('Token guardado exitosamente');

    } catch (e) {
      print('Error guardando token: $e');
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

}