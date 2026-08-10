import 'meeting_type.dart';

class LiveSessionEntity {
  const LiveSessionEntity({
    required this.gradeId,
    required this.platformType,
    required this.meetingUrl,
  });

  final String gradeId;
  final MeetingType platformType;
  final String meetingUrl;
}