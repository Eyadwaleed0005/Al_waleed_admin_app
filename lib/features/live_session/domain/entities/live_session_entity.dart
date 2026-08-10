class LiveSessionEntity {
  const LiveSessionEntity({
    required this.gradeId,
    required this.platformType,
    required this.meetingUrl,
  });

  final String gradeId;
  final String platformType;
  final String meetingUrl;
}