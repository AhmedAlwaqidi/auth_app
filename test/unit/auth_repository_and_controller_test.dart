import 'package:flutter_test/flutter_test.dart';

import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/models/login_request.dart';
import 'package:auth_app/models/register_request.dart';
import 'package:auth_app/models/reset_password_request.dart';
import 'package:auth_app/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;

    setUp(() {
      // Use zero delay in unit tests for instant execution
      repository = AuthRepositoryImpl(simulatedDelay: Duration.zero);
    });

    test('login with pre-seeded student succeeds', () async {
      final result = await repository.login(
        const LoginRequest(identifier: '202410101', password: 'Password123'),
      );

      expect(result.success, isTrue);
      expect(result.user?.fullName, 'Ahmed Alwakidi');
    });

    test('login with email identifier succeeds', () async {
      final result = await repository.login(
        const LoginRequest(
          identifier: 'STUDENT@UNIVERSITY.EDU', // case-insensitive check
          password: 'Password123',
        ),
      );

      expect(result.success, isTrue);
      expect(result.user?.academicId, '202410101');
    });

    test('login with incorrect password fails', () async {
      final result = await repository.login(
        const LoginRequest(identifier: '202410101', password: 'WrongPassword1'),
      );

      expect(result.success, isFalse);
      expect(result.message, contains('Incorrect password'));
    });

    test('login with non-existent account fails', () async {
      final result = await repository.login(
        const LoginRequest(identifier: '999999999', password: 'Password123'),
      );

      expect(result.success, isFalse);
      expect(result.message, contains('Account not found'));
    });

    test('register new student succeeds', () async {
      final registerResult = await repository.register(
        const RegisterRequest(
          fullName: 'Jane Smith',
          academicId: '202420202',
          universityEmail: 'jane.smith@univ.edu',
          password: 'SecurePassword1',
        ),
      );

      expect(registerResult.success, isTrue);
      expect(registerResult.user?.academicId, '202420202');

      // Verify immediate login with newly registered student
      final loginResult = await repository.login(
        const LoginRequest(
          identifier: '202420202',
          password: 'SecurePassword1',
        ),
      );
      expect(loginResult.success, isTrue);
    });

    test('register rejects duplicate academic ID', () async {
      final result = await repository.register(
        const RegisterRequest(
          fullName: 'Duplicate Student',
          academicId: '202410101', // existing ID
          universityEmail: 'different@univ.edu',
          password: 'Password123',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, contains('Academic ID is already registered'));
    });

    test('register rejects duplicate university email', () async {
      final result = await repository.register(
        const RegisterRequest(
          fullName: 'Duplicate Student',
          academicId: '202499999',
          universityEmail: 'student@university.edu', // existing email
          password: 'Password123',
        ),
      );

      expect(result.success, isFalse);
      expect(result.message, contains('university email already exists'));
    });

    test('password recovery and reset flow updates user password', () async {
      // 1. Send code for existing account
      final sendCodeResult = await repository.sendPasswordResetCode(
        '202410101',
      );
      expect(sendCodeResult.success, isTrue);

      // 2. Submit wrong OTP
      final wrongOtpResult = await repository.resetPassword(
        const ResetPasswordRequest(
          identifier: '202410101',
          otp: '000000',
          newPassword: 'BrandNewPassword1',
        ),
      );
      expect(wrongOtpResult.success, isFalse);
      expect(wrongOtpResult.message, contains('Invalid verification code'));

      // 3. Submit valid OTP
      final resetResult = await repository.resetPassword(
        const ResetPasswordRequest(
          identifier: '202410101',
          otp: '123456',
          newPassword: 'BrandNewPassword1',
        ),
      );
      expect(resetResult.success, isTrue);

      // 4. Verify login with old password fails
      final oldLoginResult = await repository.login(
        const LoginRequest(identifier: '202410101', password: 'Password123'),
      );
      expect(oldLoginResult.success, isFalse);

      // 5. Verify login with new password succeeds
      final newLoginResult = await repository.login(
        const LoginRequest(
          identifier: '202410101',
          password: 'BrandNewPassword1',
        ),
      );
      expect(newLoginResult.success, isTrue);
    });

    test('send reset code for non-existent account fails', () async {
      final result = await repository.sendPasswordResetCode(
        'nonexistent@univ.edu',
      );
      expect(result.success, isFalse);
      expect(result.message, contains('No student account found'));
    });
  });

  group('AuthController', () {
    late AuthRepositoryImpl repository;
    late AuthController controller;

    setUp(() {
      repository = AuthRepositoryImpl(simulatedDelay: Duration.zero);
      controller = AuthController(repository: repository);
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state has no loading and no messages', () {
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, isNull);
    });

    test('successful login updates successMessage and lastResult', () async {
      final result = await controller.login(
        const LoginRequest(identifier: '202410101', password: 'Password123'),
      );

      expect(result.success, isTrue);
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, isNotNull);
      expect(controller.lastResult?.success, isTrue);
    });

    test('failed login updates errorMessage', () async {
      final result = await controller.login(
        const LoginRequest(identifier: '202410101', password: 'WrongPassword'),
      );

      expect(result.success, isFalse);
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNotNull);
      expect(controller.successMessage, isNull);
    });

    test('clearMessages resets error and success messages', () async {
      await controller.login(
        const LoginRequest(identifier: '202410101', password: 'WrongPassword'),
      );
      expect(controller.errorMessage, isNotNull);

      controller.clearMessages();
      expect(controller.errorMessage, isNull);
      expect(controller.successMessage, isNull);
    });
  });
}
