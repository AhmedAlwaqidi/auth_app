import '../models/auth_result.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';

/// Abstract contract for authentication operations.
abstract class AuthRepository {
  /// Authenticates a user using Academic ID / email and password.
  Future<AuthResult> login(LoginRequest request);

  /// Registers a new student account.
  Future<AuthResult> register(RegisterRequest request);

  /// Initiates password recovery and generates a verification code.
  Future<AuthResult> sendPasswordResetCode(String identifier);

  /// Resets the user's password using the pending reset code.
  Future<AuthResult> resetPassword(ResetPasswordRequest request);
}

