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
}