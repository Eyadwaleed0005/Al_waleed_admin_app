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

  StudentEntity copyWith({
    String? studentId,
    String? gradeId,
    String? name,
    int? age,
    String? email,
    String? phoneNumber,
    DateTime? subscriptionStartAt,
    DateTime? subscriptionEndAt,
    bool? isActive,
    bool? isLoggedIn,
  }) {
    return StudentEntity(
      studentId: studentId ?? this.studentId,
      gradeId: gradeId ?? this.gradeId,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subscriptionStartAt:
          subscriptionStartAt ?? this.subscriptionStartAt,
      subscriptionEndAt:
          subscriptionEndAt ?? this.subscriptionEndAt,
      isActive: isActive ?? this.isActive,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}