class ExamQuestionEntity {
  const ExamQuestionEntity({
    required this.questionId,
    required this.examId,
    required this.questionText,
    required this.degree,
    required this.choices,
    this.correctChoiceIndex,
    this.imageUrl,
    this.imageStoragePath,
    this.createdAt,
    this.updatedAt,
  });

  final String questionId;
  final String examId;
  final String questionText;

  final int degree;

  final List<String> choices;

  final int? correctChoiceIndex;

  final String? imageUrl;
  final String? imageStoragePath;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasImage {
    return imageUrl?.trim().isNotEmpty ?? false;
  }

  bool get hasCorrectChoice {
    final int? index = correctChoiceIndex;

    if (index == null) {
      return false;
    }

    return index >= 0 && index < choices.length;
  }

  String? get correctChoice {
    if (!hasCorrectChoice) {
      return null;
    }

    return choices[correctChoiceIndex!];
  }

  ExamQuestionEntity copyWith({
    String? questionId,
    String? examId,
    String? questionText,
    int? degree,
    List<String>? choices,
    int? correctChoiceIndex,
    bool clearCorrectChoiceIndex = false,
    String? imageUrl,
    String? imageStoragePath,
    bool clearImage = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExamQuestionEntity(
      questionId: questionId ?? this.questionId,
      examId: examId ?? this.examId,
      questionText: questionText ?? this.questionText,
      degree: degree ?? this.degree,
      choices: choices ?? this.choices,
      correctChoiceIndex: clearCorrectChoiceIndex
          ? null
          : correctChoiceIndex ?? this.correctChoiceIndex,
      imageUrl: clearImage
          ? null
          : imageUrl ?? this.imageUrl,
      imageStoragePath: clearImage
          ? null
          : imageStoragePath ?? this.imageStoragePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}