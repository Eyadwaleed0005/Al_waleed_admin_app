abstract final class FirestoreFields {
  // Identifiers

  static const String gradeId = 'gradeId';
  static const String studentId = 'studentId';
  static const String lessonId = 'lessonId';
  static const String examId = 'examId';
  static const String questionId = 'questionId';
  static const String resultId = 'resultId';
  static const String answerId = 'answerId';

  // Common fields

  static const String name = 'name';
  static const String title = 'title';
  static const String description = 'description';

  static const String isActive = 'isActive';
  static const String isPublished = 'isPublished';
  static const String isDeleting = 'isDeleting';

  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';

  static const String displayOrder = 'displayOrder';

  // Student fields

  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String age = 'age';

  static const String subscriptionStartAt =
      'subscriptionStartAt';

  static const String subscriptionEndAt =
      'subscriptionEndAt';

  static const String isLoggedIn = 'isLoggedIn';

  static const String studentName = 'studentName';
  static const String gradeName = 'gradeName';

  // Lesson fields

  static const String youtubeUrl = 'youtubeUrl';

  static const String pdfUrl = 'pdfUrl';
  static const String pdfStoragePath = 'pdfStoragePath';
  static const String pdfFileName = 'pdfFileName';
  static const String pdfFileSize = 'pdfFileSize';

  // Question fields

  static const String questionText = 'questionText';

  static const String questionImageUrl =
      'questionImageUrl';

  static const String questionImageStoragePath =
      'questionImageStoragePath';

  static const String choices = 'choices';

  static const String correctChoiceIndex =
      'correctChoiceIndex';

  static const String degree = 'degree';
  static const String questionOrder = 'questionOrder';


  static const String option1 = 'option1';
  static const String option2 = 'option2';
  static const String option3 = 'option3';
  static const String option4 = 'option4';

  static const String correctOption = 'correctOption';
  static const String questionScore = 'questionScore';

  // Exam fields

  static const String examName = 'examName';
  static const String questionCount = 'questionCount';
  static const String durationMinutes =
      'durationMinutes';

  static const String totalScore = 'totalScore';
  static const String examStatus = 'examStatus';

  static const String firstAttemptAt =
      'firstAttemptAt';

  static const String closedAt = 'closedAt';

  static const String participantsCount =
      'participantsCount';

  // Exam result fields

  static const String score = 'score';
  static const String resultStatus = 'status';

  static const String startedAt = 'startedAt';
  static const String expiresAt = 'expiresAt';
  static const String submittedAt = 'submittedAt';

  static const String correctAnswers =
      'correctAnswers';

  static const String wrongAnswers = 'wrongAnswers';

  static const String unansweredQuestions =
      'unansweredQuestions';

 
  static const String studentScore = score;

  static const String selectedChoiceIndex =
      'selectedChoiceIndex';

  static const String isCorrect = 'isCorrect';

  static const String awardedScore = 'awardedScore';

  static const String answeredAt = 'answeredAt';

  static const String answers = 'answers';

  // Live session fields

  static const String platformType = 'platformType';
  static const String meetingUrl = 'meetingUrl';
}