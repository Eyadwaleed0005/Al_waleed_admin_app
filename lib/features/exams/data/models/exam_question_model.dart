import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/exams/domain/entities/exam_question_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamQuestionModel extends ExamQuestionEntity {
  const ExamQuestionModel({
    required super.questionId,
    required super.examId,
    required super.questionText,
    required super.degree,
    required super.choices,
    super.correctChoiceIndex,
    super.imageUrl,
    super.imageStoragePath,
    super.createdAt,
    super.updatedAt,
  });

  factory ExamQuestionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? {};

    return ExamQuestionModel.fromMap(questionId: document.id, data: data);
  }

  factory ExamQuestionModel.fromMap({
    required String questionId,
    required Map<String, dynamic> data,
  }) {
    return ExamQuestionModel(
      questionId: questionId,
      examId: _readString(data[FirestoreFields.examId]),
      questionText: _readString(data[FirestoreFields.questionText]),
      degree: _readInt(data[FirestoreFields.questionScore]),
      choices: List<String>.unmodifiable([
        _readString(data[FirestoreFields.option1]),
        _readString(data[FirestoreFields.option2]),
        _readString(data[FirestoreFields.option3]),
        _readString(data[FirestoreFields.option4]),
      ]),
      correctChoiceIndex: _readNullableInt(data[FirestoreFields.correctOption]),
      imageUrl: _readNullableString(data[FirestoreFields.questionImageUrl]),
      imageStoragePath: _readNullableString(
        data[FirestoreFields.questionImageStoragePath],
      ),
      createdAt: _readDateTime(data[FirestoreFields.createdAt]),
      updatedAt: _readDateTime(data[FirestoreFields.updatedAt]),
    );
  }

  factory ExamQuestionModel.fromEntity(ExamQuestionEntity question) {
    return ExamQuestionModel(
      questionId: question.questionId,
      examId: question.examId,
      questionText: question.questionText,
      degree: question.degree,
      choices: List<String>.unmodifiable(question.choices),
      correctChoiceIndex: question.correctChoiceIndex,
      imageUrl: question.imageUrl,
      imageStoragePath: question.imageStoragePath,
      createdAt: question.createdAt,
      updatedAt: question.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreFields.examId: examId,
      FirestoreFields.questionText: questionText,
      FirestoreFields.questionScore: degree,
      FirestoreFields.option1: _choiceAt(0),
      FirestoreFields.option2: _choiceAt(1),
      FirestoreFields.option3: _choiceAt(2),
      FirestoreFields.option4: _choiceAt(3),
      FirestoreFields.correctOption: correctChoiceIndex,
      FirestoreFields.questionImageUrl: imageUrl,
      FirestoreFields.questionImageStoragePath: imageStoragePath,
      FirestoreFields.createdAt: createdAt == null
          ? null
          : Timestamp.fromDate(createdAt!),
      FirestoreFields.updatedAt: updatedAt == null
          ? null
          : Timestamp.fromDate(updatedAt!),
    };
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.examId: examId,
      FirestoreFields.questionText: questionText,
      FirestoreFields.questionScore: degree,
      FirestoreFields.option1: _choiceAt(0),
      FirestoreFields.option2: _choiceAt(1),
      FirestoreFields.option3: _choiceAt(2),
      FirestoreFields.option4: _choiceAt(3),
      FirestoreFields.correctOption: correctChoiceIndex,
      FirestoreFields.questionImageUrl: imageUrl,
      FirestoreFields.questionImageStoragePath: imageStoragePath,
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  ExamQuestionEntity toEntity() {
    return ExamQuestionEntity(
      questionId: questionId,
      examId: examId,
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

    return choices[index].trim();
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _readNullableString(dynamic value) {
    final String normalizedValue = value?.toString().trim() ?? '';

    if (normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  static int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static DateTime? _readDateTime(dynamic value) {
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
