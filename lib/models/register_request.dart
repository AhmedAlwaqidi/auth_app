class RegisterRequest {
  final String fullName;
  final String academicId;
  final String universityEmail;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });
}

