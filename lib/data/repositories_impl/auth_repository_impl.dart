import 'package:icongrega/data/data_source/remote/auth_api.dart';
import 'package:icongrega/domain/repositories/auth_repository.dart';
import 'package:icongrega/domain/responses/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthAPI _authAPI;

  AuthRepositoryImpl(this._authAPI);

  @override
  Future<String?> get accessToken async {
    // Implementación para obtener el token de acceso
    await Future.delayed(const Duration(seconds: 1)); // Simula retardo
    return 'null'; // Placeholder
  }

  @override
  Future<LoginResponse> login(String email, String password) {
    // Implementación para el inicio de sesión
    return _authAPI.login(email, password);
  }
}
