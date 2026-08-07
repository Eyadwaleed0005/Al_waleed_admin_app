class StudentEntity {
  final String studentId;
  final String gradeId;
  final String name;
  final int age;
  final String email;
  final String phoneNumber;
  final DateTime subscriptionStartAt;
  final DateTime subscriptionEndAt;
  final bool isActive;
  final bool isLoggedIn;

  const StudentEntity({
    required this.studentId,
    required this.gradeId,
    required this.name,
    required this.age,
    required this.email,
    required this.phoneNumber,
    required this.subscriptionStartAt,
    required this.subscriptionEndAt,
    required this.isActive,
    required this.isLoggedIn,
  });
}