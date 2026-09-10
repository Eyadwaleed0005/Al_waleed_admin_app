import 'student_exam_result_entity.dart';

class StudentExamResultsOverviewEntity {
  final String studentId;
  final String studentFullName;
  final String studentGradeId;
  final String studentGradeName;
  final bool isStudentAccountActive;
  final List<StudentExamResultEntity> studentExamResults;

  const StudentExamResultsOverviewEntity({
    required this.studentId,
    required this.studentFullName,
    required this.studentGradeId,
    required this.studentGradeName,
    required this.isStudentAccountActive,
    required this.studentExamResults,
  });

  int get completedExamsCount => studentExamResults.length;

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
