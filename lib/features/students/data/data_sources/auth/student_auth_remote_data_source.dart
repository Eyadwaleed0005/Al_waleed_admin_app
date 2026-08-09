abstract interface class StudentAuthRemoteDataSource {
  Future<String> createStudentAccount({
    required String email,
    required String password,
  });

  Future<void> updateStudentPassword({
    required String studentId,
    required String newPassword,
  });

  Future<void> updateStudentEmail({
    required String studentId,
    required String newEmail,
  });

  Future<void> updateStudentAccountStatus({
    required String studentId,
    required bool isActive,
  });

  Future<void> deleteStudentAccount({required String studentId});
}
