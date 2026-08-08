class GradeEntity {
  final String gradeId;
  final String name;
  final int displayOrder;
  final bool isActive;

  const GradeEntity({
    required this.gradeId,
    required this.name,
    required this.displayOrder,
    required this.isActive,
  });
}