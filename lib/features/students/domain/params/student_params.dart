class CreateStudentParams {
  final String gradeId;
  final String name;
  final int age;
  final String email;
  final String password;
  final String phoneNumber;
  final DateTime subscriptionStartAt;
  final DateTime subscriptionEndAt;

  const CreateStudentParams({
    required this.gradeId,
    required this.name,
    required this.age,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
  });
}

enum StudentSubscriptionFilter {
  all,
  active,
  expired,
}

class StudentsFilterParams {
  final String gradeId;
  final String searchQuery;
  final StudentSubscriptionFilter subscriptionFilter;

  const StudentsFilterParams({
    this.gradeId = '',
    this.searchQuery = '',
    this.subscriptionFilter = StudentSubscriptionFilter.all,
  });
}

class UpdateStudentProfileParams {
  const UpdateStudentProfileParams({
    required this.studentId,
    required this.gradeId,
    required this.name,
    required this.age,
    required this.phoneNumber,
  });

  final String studentId;
  final String gradeId;
  final String name;
  final int age;
  final String phoneNumber;
}

class UpdateStudentEmailParams {
  const UpdateStudentEmailParams({
    required this.studentId,
    required this.newEmail,
  });

  final String studentId;
  final String newEmail;
}

class UpdateStudentPasswordParams {
  const UpdateStudentPasswordParams({
    required this.studentId,
    required this.newPassword,
  });

  final String studentId;
  final String newPassword;
}

class UpdateStudentSubscriptionParams {
  const UpdateStudentSubscriptionParams({
    required this.studentId,
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
  });

  final String studentId;
  final DateTime subscriptionStartAt;
  final DateTime subscriptionEndAt;
}