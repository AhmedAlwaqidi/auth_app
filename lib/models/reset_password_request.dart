class ResetPasswordRequest {
  final String identifier;
  final String otp;
  final String newPassword;

  const ResetPasswordRequest({
    required this.identifier,
    required this.otp,
    required this.newPassword,
  });
}
