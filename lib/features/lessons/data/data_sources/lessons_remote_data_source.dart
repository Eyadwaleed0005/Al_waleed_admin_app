import 'package:alwaleed_admain/features/lessons/data/models/lesson_model.dart';

abstract class LessonsRemoteDataSource {
  Future<List<LessonModel>> getLessons({String? gradeId, bool? isPublished});

  Future<LessonModel> getLessonById({required String lessonId});

  Stream<List<LessonModel>> streamLessons({String? gradeId, bool? isPublished});

  Future<void> createLesson({
    required LessonModel lesson,
    required String localPdfFilePath,
  });

  Future<void> updateLesson({
    required LessonModel lesson,
    String? replacementPdfFilePath,
  });

  Future<void> deleteLesson({required String lessonId});
}
