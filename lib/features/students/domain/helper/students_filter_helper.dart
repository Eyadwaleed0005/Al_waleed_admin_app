import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:alwaleed_admain/features/students/domain/params/student_params.dart';

abstract final class StudentsFilterHelper {
  static List<StudentEntity> apply({
    required List<StudentEntity> students,
    required StudentsFilterParams params,
  }) {
    final now = DateTime.now();

    return students.where((student) {
      final matchesGrade = _matchesGrade(
        student: student,
        gradeId: params.gradeId,
      );

      final matchesSearch = _matchesSearch(
        student: student,
        searchQuery: params.searchQuery,
      );

      final matchesSubscription =
          _matchesSubscription(
        student: student,
        filter: params.subscriptionFilter,
        now: now,
      );

      return matchesGrade &&
          matchesSearch &&
          matchesSubscription;
    }).toList();
  }

  static bool _matchesGrade({
    required StudentEntity student,
    required String gradeId,
  }) {
    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      return true;
    }

    return student.gradeId == normalizedGradeId;
  }

  static bool _matchesSearch({
    required StudentEntity student,
    required String searchQuery,
  }) {
    final normalizedQuery =
        searchQuery.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return true;
    }

    final normalizedName =
        student.name.trim().toLowerCase();

    final normalizedPhone =
        student.phoneNumber.replaceAll(
      RegExp(r'\s+'),
      '',
    );

    final normalizedPhoneQuery =
        normalizedQuery.replaceAll(
      RegExp(r'\s+'),
      '',
    );

    return normalizedName.contains(normalizedQuery) ||
        normalizedPhone.contains(normalizedPhoneQuery);
  }

  static bool _matchesSubscription({
    required StudentEntity student,
    required StudentSubscriptionFilter filter,
    required DateTime now,
  }) {
    final isSubscriptionActive =
        student.isActive &&
        student.subscriptionEndAt.isAfter(now);

    switch (filter) {
      case StudentSubscriptionFilter.all:
        return true;

      case StudentSubscriptionFilter.active:
        return isSubscriptionActive;

      case StudentSubscriptionFilter.expired:
        return !isSubscriptionActive;
    }
  }
}