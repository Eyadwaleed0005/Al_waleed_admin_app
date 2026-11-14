class StudentEntity {
  const StudentEntity({
    required this.studentId,
    required this.gradeId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.isLoggedIn,
    this.subscriptionStartAt,
    this.subscriptionEndAt,
  });

  final String studentId;
  final String gradeId;
  final String name;
  final String email;
  final String phoneNumber;

  final DateTime? subscriptionStartAt;
  final DateTime? subscriptionEndAt;

  final bool isActive;
  final bool isLoggedIn;

  StudentEntity copyWith({
    String? studentId,
    String? gradeId,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? subscriptionStartAt,
    DateTime? subscriptionEndAt,
    bool clearSubscriptionDates = false,
    bool? isActive,
    bool? isLoggedIn,
  }) {
    return StudentEntity(
      studentId: studentId ?? this.studentId,
      gradeId: gradeId ?? this.gradeId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subscriptionStartAt: clearSubscriptionDates
          ? null
          : subscriptionStartAt ?? this.subscriptionStartAt,
      subscriptionEndAt: clearSubscriptionDates
          ? null
          : subscriptionEndAt ?? this.subscriptionEndAt,
      isActive: isActive ?? this.isActive,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
