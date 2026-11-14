class StudyNoteEntity {
  const StudyNoteEntity({
    required this.noteId,
    required this.name,
    required this.description,
    required this.gradeId,
    required this.isPublished,
    required this.pdfStoragePath,
    required this.pdfFileName,
    required this.pdfFileSize,
    this.isFree = true,
    this.createdAt,
    this.updatedAt,
  });

  final String noteId;
  final String name;
  final String description;
  final String gradeId;
  final bool isPublished;
  final bool isFree;

  final String pdfStoragePath;
  final String pdfFileName;
  final int pdfFileSize;

  final DateTime? createdAt;
  final DateTime? updatedAt;
}
