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