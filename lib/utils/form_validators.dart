/// Pure validation functions matching Flutter's `FormFieldValidator<String>` conventions.
/// All validation rules are centralized here.
class FormValidators {
  FormValidators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _academicIdRegExp = RegExp(r'^\d{9,10}$');
  static final RegExp _otpRegExp = RegExp(r'^\d{6}$');
  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _digitRegExp = RegExp(r'\d');

  /// Validates that a field is not empty after trimming.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Validates the login identifier (Academic ID or email, min 5 characters).
  static String? loginIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Academic ID or university email is required.';
    }
    final trimmed = value.trim();
    if (trimmed.length < 5) {
      return 'Identifier must be at least 5 characters.';
    }
    return null;
  }

  /// Validates login password (required, at least 6 characters).
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  /// Validates full name (required, at least 3 characters after trimming).
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }
    if (value.trim().length < 3) {
      return 'Full name must be at least 3 characters.';
    }
    return null;
  }

  /// Validates academic ID (digits only; exactly 9 or 10 digits).
  static String? academicId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Academic ID is required.';
    }
    final trimmed = value.trim();
    if (!_academicIdRegExp.hasMatch(trimmed)) {
      return 'Academic ID must contain exactly 9 or 10 digits.';
    }
    return null;
  }

  /// Validates university email format.
  static String? universityEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'University email is required.';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Enter a valid university email address.';
    }
    return null;
  }

  /// Validates strong password (at least 8 chars, 1 digit, 1 uppercase letter).
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!_uppercaseRegExp.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!_digitRegExp.hasMatch(value)) {
      return 'Password must contain at least one digit.';
    }
    return null;
  }

  /// Validates that confirmation password exactly matches the original password.
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Validates password reset identifier (must be valid 9-10 digit Academic ID or email).
  static String? resetIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Academic ID or university email is required.';
    }
    final trimmed = value.trim();
    final isAcademicId = _academicIdRegExp.hasMatch(trimmed);
    final isEmail = _emailRegExp.hasMatch(trimmed);
    if (!isAcademicId && !isEmail) {
      return 'Enter a valid 9-10 digit Academic ID or university email.';
    }
    return null;
  }

  /// Validates OTP code (exactly 6 digits, digits only).
  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required.';
    }
    final trimmed = value.trim();
    if (!_otpRegExp.hasMatch(trimmed)) {
      return 'Verification code must be exactly 6 digits.';
    }
    return null;
  }
}
