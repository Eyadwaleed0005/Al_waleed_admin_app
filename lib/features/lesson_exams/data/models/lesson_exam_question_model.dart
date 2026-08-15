import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/lesson_exams/domain/entities/lesson_exam_question_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonExamQuestionModel extends LessonExamQuestionEntity {
  const LessonExamQuestionModel({
    required super.questionId,
    required super.lessonId,
    required super.questionText,
    required super.degree,
    required super.choices,
    super.correctChoiceIndex,
    super.imageUrl,
    super.imageStoragePath,
    super.createdAt,
    super.updatedAt,
  });

  factory LessonExamQuestionModel.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> document,
  }) {
    final data = document.data() ?? <String, dynamic>{};

    return LessonExamQuestionModel.fromMap(map: data, questionId: document.id);
  }

  factory LessonExamQuestionModel.fromMap({
    required Map<String, dynamic> map,
    required String questionId,
  }) {
    return LessonExamQuestionModel(
      questionId: questionId,
      lessonId: _readString(map[FirestoreFields.lessonId]),
      questionText: _readString(map[FirestoreFields.questionText]),
      degree: _readInt(map[FirestoreFields.questionScore]),
      choices: List<String>.unmodifiable([
        _readString(map[FirestoreFields.option1]),
        _readString(map[FirestoreFields.option2]),
        _readString(map[FirestoreFields.option3]),
        _readString(map[FirestoreFields.option4]),
      ]),
      correctChoiceIndex: _readNullableInt(map[FirestoreFields.correctOption]),
      imageUrl: _readNullableString(map[FirestoreFields.questionImageUrl]),
      imageStoragePath: _readNullableString(
        map[FirestoreFields.questionImageStoragePath],
      ),
      createdAt: _readDateTime(map[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(map[FirestoreFields.updatedAt]),
    );
  }

  factory LessonExamQuestionModel.fromEntity(LessonExamQuestionEntity entity) {
    return LessonExamQuestionModel(
      questionId: entity.questionId,
      lessonId: entity.lessonId,
      questionText: entity.questionText,
      degree: entity.degree,
      choices: List<String>.unmodifiable(entity.choices),
      correctChoiceIndex: entity.correctChoiceIndex,
      imageUrl: entity.imageUrl,
      imageStoragePath: entity.imageStoragePath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.lessonId: lessonId,
      FirestoreFields.questionText: questionText,
      FirestoreFields.questionScore: degree,
      FirestoreFields.option1: _choiceAt(0),
      FirestoreFields.option2: _choiceAt(1),
      FirestoreFields.option3: _choiceAt(2),
      FirestoreFields.option4: _choiceAt(3),
      FirestoreFields.correctOption: null,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      FirestoreFields.questionText: questionText,
      FirestoreFields.questionScore: degree,
      FirestoreFields.option1: _choiceAt(0),
      FirestoreFields.option2: _choiceAt(1),
      FirestoreFields.option3: _choiceAt(2),
      FirestoreFields.option4: _choiceAt(3),
    };
  }

  LessonExamQuestionEntity toEntity() {
    return LessonExamQuestionEntity(
      questionId: questionId,
      lessonId: lessonId,
      questionText: questionText,
      degree: degree,
      choices: List<String>.unmodifiable(choices),
      correctChoiceIndex: correctChoiceIndex,
      imageUrl: imageUrl,
      imageStoragePath: imageStoragePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String _choiceAt(int index) {
    if (index < 0 || index >= choices.length) {
      return '';
    }

    return choices[index];
  }

  static String _readString(Object? value) {
    if (value is! String) {
      return '';
    }

    return value.trim();
  }

  static String? _readNullableString(Object? value) {
    if (value is! String) {
      return null;
    }

    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
  }

  static int? _readNullableInt(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim());
    }

    return null;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
