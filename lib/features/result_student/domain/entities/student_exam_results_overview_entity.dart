import 'student_exam_result_entity.dart';

class StudentExamResultsOverviewEntity {
  final String studentId;
  final String studentFullName;
  final String studentGradeId;
  final String studentGradeName;
  final bool isStudentAccountActive;
  final int completedExamsCount;
  final int totalExamsCount;
  final List<StudentExamResultEntity> studentExamResults;

  const StudentExamResultsOverviewEntity({
    required this.studentId,
    required this.studentFullName,
    required this.studentGradeId,
    required this.studentGradeName,
    required this.isStudentAccountActive,
    required this.completedExamsCount,
    required this.totalExamsCount,
    required this.studentExamResults,
  });

  double get highestResultPercentage {
    if (studentExamResults.isEmpty) {
      return 0;
    }

    return studentExamResults
        .map((examResult) => examResult.resultPercentage)
        .reduce(
          (currentHighestPercentage, nextPercentage) =>
              currentHighestPercentage > nextPercentage
              ? currentHighestPercentage
              : nextPercentage,
        );
  }

  double get averageResultPercentage {
    if (studentExamResults.isEmpty) {
      return 0;
    }

    final double totalResultPercentages = studentExamResults.fold<double>(
      0,
      (totalPercentage, examResult) =>
          totalPercentage + examResult.resultPercentage,
    );

    return totalResultPercentages / studentExamResults.length;
  }
}
