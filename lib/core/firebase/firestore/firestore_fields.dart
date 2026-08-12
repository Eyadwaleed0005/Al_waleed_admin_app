abstract final class FirestoreFields {
  // Relations

  static const String gradeId = 'gradeId';
  static const String studentId = 'studentId';
  static const String lessonId = 'lessonId';
  static const String examId = 'examId';

  // Common

  static const String name = 'name';
  static const String title = 'title';
  static const String description = 'description';
  static const String isActive = 'isActive';
  static const String isPublished = 'isPublished';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  // Grades

  static const String displayOrder = 'displayOrder';

  // Students

  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String age = 'age';
  static const String subscriptionStartAt = 'subscriptionStartAt';
  static const String subscriptionEndAt = 'subscriptionEndAt';
  static const String isLoggedIn = 'isLoggedIn';

  // Lessons

  static const String youtubeUrl = 'youtubeUrl';

  static const String pdfUrl = 'pdfUrl';

  // Study notes PDF

  static const String pdfStoragePath = 'pdfStoragePath';
  static const String pdfFileName = 'pdfFileName';
  static const String pdfFileSize = 'pdfFileSize';

  // Questions

  static const String questionText = 'questionText';
  static const String questionImageUrl = 'questionImageUrl';
  static const String option1 = 'option1';
  static const String option2 = 'option2';
  static const String option3 = 'option3';
  static const String option4 = 'option4';
  static const String correctOption = 'correctOption';
  static const String questionScore = 'questionScore';

  // Exams

  static const String examName = 'examName';
  static const String questionCount = 'questionCount';
  static const String durationMinutes = 'durationMinutes';
  static const String totalScore = 'totalScore';
  static const String startAt = 'startAt';
  static const String endAt = 'endAt';
  static const String examStatus = 'examStatus';

  // Exam results

  static const String studentScore = 'studentScore';
  static const String submittedAt = 'submittedAt';

  // Live sessions

  static const String platformType = 'platformType';
  static const String meetingUrl = 'meetingUrl';
}