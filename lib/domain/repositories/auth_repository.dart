import '../responses/login_response.dart';

abstract class AuthRepository {
  Future<String?> get accessToken;

  Future<LoginResponse> login(String email, String password);
}
