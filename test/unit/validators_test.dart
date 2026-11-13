import 'package:flutter_test/flutter_test.dart';

import 'package:auth_app/utils/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('required: validates empty and non-empty values', () {
      expect(FormValidators.required(null), isNotNull);
      expect(FormValidators.required(''), isNotNull);
      expect(FormValidators.required('   '), isNotNull);
      expect(FormValidators.required('hello'), isNull);
    });

    test('loginIdentifier: requires at least 5 characters', () {
      expect(FormValidators.loginIdentifier(null), isNotNull);
      expect(FormValidators.loginIdentifier(''), isNotNull);
      expect(FormValidators.loginIdentifier('1234'), isNotNull);
      expect(FormValidators.loginIdentifier('12345'), isNull);
      expect(FormValidators.loginIdentifier('202410101'), isNull);
      expect(FormValidators.loginIdentifier('student@univ.edu'), isNull);
    });

    test('loginPassword: requires at least 6 characters', () {
      expect(FormValidators.loginPassword(null), isNotNull);
      expect(FormValidators.loginPassword(''), isNotNull);
      expect(FormValidators.loginPassword('12345'), isNotNull);
      expect(FormValidators.loginPassword('123456'), isNull);
    });

    test('fullName: requires at least 3 characters after trimming', () {
      expect(FormValidators.fullName(null), isNotNull);
      expect(FormValidators.fullName(''), isNotNull);
      expect(FormValidators.fullName('  ab  '), isNotNull);
      expect(FormValidators.fullName('John'), isNull);
      expect(FormValidators.fullName('  Bob  '), isNull);
    });

    test('academicId: digits only, exactly 9 or 10 digits', () {
      expect(FormValidators.academicId(null), isNotNull);
      expect(FormValidators.academicId(''), isNotNull);
      expect(FormValidators.academicId('12345678'), isNotNull); // 8 digits
      expect(FormValidators.academicId('123456789'), isNull); // 9 digits
      expect(FormValidators.academicId('1234567890'), isNull); // 10 digits
      expect(FormValidators.academicId('12345678901'), isNotNull); // 11 digits
      expect(FormValidators.academicId('12345678a'), isNotNull); // Non-digit
    });

    test('universityEmail: validates standard email format', () {
      expect(FormValidators.universityEmail(null), isNotNull);
      expect(FormValidators.universityEmail(''), isNotNull);
      expect(FormValidators.universityEmail('notanemail'), isNotNull);
      expect(FormValidators.universityEmail('missing@domain'), isNotNull);
      expect(FormValidators.universityEmail('student@university.edu'), isNull);
      expect(FormValidators.universityEmail('john.doe@sub.domain.org'), isNull);
    });

    test('strongPassword: min 8 chars, 1 digit, 1 uppercase letter', () {
      expect(FormValidators.strongPassword(null), isNotNull);
      expect(FormValidators.strongPassword(''), isNotNull);
      expect(FormValidators.strongPassword('Pass1'), isNotNull); // too short
      expect(
        FormValidators.strongPassword('password123'),
        isNotNull,
      ); // no uppercase
      expect(
        FormValidators.strongPassword('PASSWORDABC'),
        isNotNull,
      ); // no digit
      expect(
        FormValidators.strongPassword('Password1'),
        isNull,
      ); // valid 9 chars, upper, digit
      expect(
        FormValidators.strongPassword('Secure99'),
        isNull,
      ); // valid 8 chars
    });

    test('confirmPassword: must match original password exactly', () {
      expect(FormValidators.confirmPassword(null, 'Password123'), isNotNull);
      expect(FormValidators.confirmPassword('', 'Password123'), isNotNull);
      expect(
        FormValidators.confirmPassword('Password124', 'Password123'),
        isNotNull,
      );
      expect(
        FormValidators.confirmPassword('Password123', 'Password123'),
        isNull,
      );
    });

    test('resetIdentifier: accepts 9-10 digit academic ID or valid email', () {
      expect(FormValidators.resetIdentifier(null), isNotNull);
      expect(FormValidators.resetIdentifier(''), isNotNull);
      expect(FormValidators.resetIdentifier('123'), isNotNull);
      expect(FormValidators.resetIdentifier('202410101'), isNull);
      expect(FormValidators.resetIdentifier('2024101019'), isNull);
      expect(FormValidators.resetIdentifier('student@university.edu'), isNull);
      expect(FormValidators.resetIdentifier('invalid_identifier'), isNotNull);
    });

    test('otp: exactly 6 digits, digits only', () {
      expect(FormValidators.otp(null), isNotNull);
      expect(FormValidators.otp(''), isNotNull);
      expect(FormValidators.otp('12345'), isNotNull); // 5 digits
      expect(FormValidators.otp('1234567'), isNotNull); // 7 digits
      expect(FormValidators.otp('12345a'), isNotNull); // non-digit
      expect(FormValidators.otp('123456'), isNull); // valid
    });
  });
}
