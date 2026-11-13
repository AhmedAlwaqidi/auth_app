class UserModel {
  final String fullName;
  final String academicId;
  final String universityEmail;
  final String password;

  const UserModel({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });

  UserModel copyWith({
    String? fullName,
    String? academicId,
    String? universityEmail,
    String? password,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      academicId: academicId ?? this.academicId,
      universityEmail: universityEmail ?? this.universityEmail,
      password: password ?? this.password,
    );
  }

  @override
  String toString() =>
      'UserModel(fullName: $fullName, academicId: $academicId, universityEmail: $universityEmail)';
}
