import 'package:flutter/foundation.dart';

import '../models/auth_result.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../repositories/auth_repository.dart';

/// Controller managing student authentication state and interactions.
///
/// Follows MVC architecture and coordinates between Views and the [AuthRepository].
/// Does not depend on UI widgets or direct navigation logic.
class AuthController extends ChangeNotifier {
  final AuthRepository repository;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  AuthResult? _lastResult;

  AuthController({required this.repository});

  // --- Getters for observable UI state ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AuthResult? get lastResult => _lastResult;

  /// Resets transient error and success feedback messages.
  void clearMessages() {
    if (_errorMessage != null || _successMessage != null) {
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();
    }
  }

  /// Handles student login request.
  Future<AuthResult> login(LoginRequest request) async {
    if (_isLoading) {
      return AuthResult.failure('An operation is already in progress.');
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await repository.login(request);
      _lastResult = result;

      if (result.success) {
        _successMessage = result.message;
      } else {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      final failure = AuthResult.failure('An unexpected error occurred: $e');
      _lastResult = failure;
      _errorMessage = failure.message;
      return failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles student registration request.
  Future<AuthResult> register(RegisterRequest request) async {
    if (_isLoading) {
      return AuthResult.failure('An operation is already in progress.');
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await repository.register(request);
      _lastResult = result;

      if (result.success) {
        _successMessage = result.message;
      } else {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      final failure = AuthResult.failure('An unexpected error occurred: $e');
      _lastResult = failure;
      _errorMessage = failure.message;
      return failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Requests a password reset verification code for an identifier.
  Future<AuthResult> sendPasswordResetCode(String identifier) async {
    if (_isLoading) {
      return AuthResult.failure('An operation is already in progress.');
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await repository.sendPasswordResetCode(identifier);
      _lastResult = result;

      if (result.success) {
        _successMessage = result.message;
      } else {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      final failure = AuthResult.failure('An unexpected error occurred: $e');
      _lastResult = failure;
      _errorMessage = failure.message;
      return failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Submits new password with the OTP code.
  Future<AuthResult> resetPassword(ResetPasswordRequest request) async {
    if (_isLoading) {
      return AuthResult.failure('An operation is already in progress.');
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await repository.resetPassword(request);
      _lastResult = result;

      if (result.success) {
        _successMessage = result.message;
      } else {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      final failure = AuthResult.failure('An unexpected error occurred: $e');
      _lastResult = failure;
      _errorMessage = failure.message;
      return failure;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
