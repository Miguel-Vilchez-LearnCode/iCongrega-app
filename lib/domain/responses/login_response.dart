// enum LoginResponse { ok, accessDenied, networkError, unknownError }
import 'package:icongrega/domain/models/user.dart';

class LoginResponse {
  final String message;
  final String token;
  final String tokenType;
  final User user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.tokenType,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      user: User.fromJson(json['user']),
    );
  }
}
