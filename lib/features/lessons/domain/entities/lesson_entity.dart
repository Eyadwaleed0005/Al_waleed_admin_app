class LessonEntity {
  const LessonEntity({
    required this.lessonId,
    required this.gradeId,
    required this.title,
    required this.subtitle,
    required this.isPublished,
    this.youtubeUrl,
    this.pdfFileName,
    this.pdfFileSize,
    this.pdfStoragePath,
  });

  final String lessonId;
  final String gradeId;

  final String title;
  final String subtitle;

  final String? youtubeUrl;

  final String? pdfFileName;
  final int? pdfFileSize;
  final String? pdfStoragePath;

  final bool isPublished;

  bool get hasYoutubeVideo {
    return youtubeUrl?.trim().isNotEmpty ?? false;
  }

  bool get hasPdfFile {
    return pdfStoragePath?.trim().isNotEmpty ?? false;
  }

  LessonEntity copyWith({
    String? lessonId,
    String? gradeId,
    String? title,
    String? subtitle,
    String? youtubeUrl,
    String? pdfFileName,
    int? pdfFileSize,
    String? pdfStoragePath,
    bool? isPublished,
    bool clearYoutubeUrl = false,
    bool clearPdf = false,
  }) {
    return LessonEntity(
      lessonId: lessonId ?? this.lessonId,
      gradeId: gradeId ?? this.gradeId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      youtubeUrl: clearYoutubeUrl ? null : youtubeUrl ?? this.youtubeUrl,
      pdfFileName: clearPdf ? null : pdfFileName ?? this.pdfFileName,
      pdfFileSize: clearPdf ? null : pdfFileSize ?? this.pdfFileSize,
      pdfStoragePath: clearPdf ? null : pdfStoragePath ?? this.pdfStoragePath,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
