class StudentExamResultEntity {
  final String resultId;
  final String examId;
  final String examName;
  final double studentObtainedScore;
  final double examTotalScore;
  final DateTime examSubmittedAt;

  const StudentExamResultEntity({
    required this.resultId,
    required this.examId,
    required this.examName,
    required this.studentObtainedScore,
    required this.examTotalScore,
    required this.examSubmittedAt,
  });

  double get resultPercentage {
    if (examTotalScore <= 0) {
      return 0;
    }

    return (studentObtainedScore / examTotalScore) * 100;
  }
}