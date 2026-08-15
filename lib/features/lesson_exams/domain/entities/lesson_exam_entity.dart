import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';

class LessonExamEntity {
  const LessonExamEntity({
    required this.lessonId,
    required this.questions,
  });

  final String lessonId;
  final List<LessonExamQuestionEntity> questions;

  bool get hasQuestions {
    return questions.isNotEmpty;
  }

  int get questionsCount {
    return questions.length;
  }

  int get totalDegrees {
    return questions.fold<int>(
      0,
      (total, question) => total + question.degree,
    );
  }

  bool get hasQuestionsWithoutCorrectAnswer {
    return questions.any(
      (question) => !question.hasCorrectChoice,
    );
  }

  bool get allQuestionsHaveCorrectAnswers {
    return questions.isNotEmpty &&
        questions.every(
          (question) => question.hasCorrectChoice,
        );
  }

  LessonExamEntity copyWith({
    String? lessonId,
    List<LessonExamQuestionEntity>? questions,
  }) {
    return LessonExamEntity(
      lessonId: lessonId ?? this.lessonId,
      questions: questions ?? this.questions,
    );
  }

  factory LessonExamEntity.empty({
    required String lessonId,
  }) {
    return LessonExamEntity(
      lessonId: lessonId,
      questions: const [],
    );
  }
}