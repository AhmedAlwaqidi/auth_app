import 'user_model.dart';

class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;

  const AuthResult({
    required this.success,
    required this.message,
    this.user,
  });

  factory AuthResult.success(String message, [UserModel? user]) {
    return AuthResult(
      success: true,
      message: message,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(
      success: false,
      message: message,
    );
  }
}

