class StudyNoteEntity {
  const StudyNoteEntity({
    required this.noteId,
    required this.name,
    required this.description,
    required this.gradeId,
    required this.isPublished,
  });

  final String noteId;
  final String name;
  final String description;
  final String gradeId;
  final bool isPublished;
}