import 'dart:async';

import '../models/auth_result.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Concrete in-memory implementation of [AuthRepository] with simulated network delay.
class AuthRepositoryImpl implements AuthRepository {
  /// In-memory storage of registered users.
  final List<UserModel> _users = [
    // Pre-seeded demo student for instant testing and demonstration
    const UserModel(
      fullName: 'Ahmed Alwakidi',
      academicId: '202410101',
      universityEmail: 'student@university.edu',
      password: 'Password123',
    ),
  ];

  /// Active verification code and identity for simulated OTP verification.
  String? _pendingResetIdentifier;
  String? _pendingResetCode;

  /// Simulated network latency duration.
  final Duration simulatedDelay;

  AuthRepositoryImpl({this.simulatedDelay = const Duration(milliseconds: 600)});

  @override
  Future<AuthResult> login(LoginRequest request) async {
    await Future.delayed(simulatedDelay);

    final trimmedIdentifier = request.identifier.trim().toLowerCase();

    // Find user matching Academic ID or University Email
    final index = _users.indexWhere(
      (u) =>
          u.academicId == request.identifier.trim() ||
          u.universityEmail.toLowerCase() == trimmedIdentifier,
    );

    if (index == -1) {
      return AuthResult.failure(
        'Account not found. Please verify your Academic ID or email.',
      );
    }

    final user = _users[index];

    if (user.password != request.password) {
      return AuthResult.failure('Incorrect password. Please try again.');
    }

    return AuthResult.success(
      'Login successful. Welcome, ${user.fullName}!',
      user,
    );
  }

  @override
  Future<AuthResult> register(RegisterRequest request) async {
    await Future.delayed(simulatedDelay);

    final trimmedAcademicId = request.academicId.trim();
    final trimmedEmail = request.universityEmail.trim().toLowerCase();

    // Check for duplicate academic ID
    final academicIdExists = _users.any(
      (u) => u.academicId == trimmedAcademicId,
    );
    if (academicIdExists) {
      return AuthResult.failure(
        'A student with this Academic ID is already registered.',
      );
    }

    // Check for duplicate university email
    final emailExists = _users.any(
      (u) => u.universityEmail.toLowerCase() == trimmedEmail,
    );
    if (emailExists) {
      return AuthResult.failure(
        'An account with this university email already exists.',
      );
    }

    // Create and store new user
    final newUser = UserModel(
      fullName: request.fullName.trim(),
      academicId: trimmedAcademicId,
      universityEmail: request.universityEmail.trim(),
      password: request.password,
    );

    _users.add(newUser);

    return AuthResult.success(
      'Registration successful! You can now log in with your credentials.',
      newUser,
    );
  }

  @override
  Future<AuthResult> sendPasswordResetCode(String identifier) async {
    await Future.delayed(simulatedDelay);

    final trimmedIdentifier = identifier.trim().toLowerCase();

    // Verify student account exists
    final index = _users.indexWhere(
      (u) =>
          u.academicId == identifier.trim() ||
          u.universityEmail.toLowerCase() == trimmedIdentifier,
    );

    if (index == -1) {
      return AuthResult.failure(
        'No student account found with the provided identifier.',
      );
    }

    // Set simulated OTP code
    _pendingResetIdentifier = identifier.trim();
    _pendingResetCode = '123456';

    return AuthResult.success(
      'Verification code generated. (Demo Code: 123456)',
    );
  }

  @override
  Future<AuthResult> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(simulatedDelay);

    final trimmedIdentifier = request.identifier.trim().toLowerCase();

    // Check if reset was initiated
    if (_pendingResetIdentifier == null || _pendingResetCode == null) {
      return AuthResult.failure(
        'Password reset session has expired or was not initiated. Please request a new code.',
      );
    }

    // Check OTP match
    if (request.otp.trim() != _pendingResetCode) {
      return AuthResult.failure(
        'Invalid verification code. Please check the code and try again.',
      );
    }

    // Locate student account
    final index = _users.indexWhere(
      (u) =>
          u.academicId == request.identifier.trim() ||
          u.universityEmail.toLowerCase() == trimmedIdentifier,
    );

    if (index == -1) {
      return AuthResult.failure(
        'Account could not be found to update password.',
      );
    }

    // Update password
    final updatedUser = _users[index].copyWith(password: request.newPassword);
    _users[index] = updatedUser;

    // Clear pending reset session
    _pendingResetIdentifier = null;
    _pendingResetCode = null;

    return AuthResult.success(
      'Password updated successfully! You can now log in with your new password.',
      updatedUser,
    );
  }
}
