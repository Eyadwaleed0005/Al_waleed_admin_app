import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';

import '../../domain/entities/live_session_entity.dart';
import '../../domain/entities/meeting_type.dart';

class LiveSessionModel {
  const LiveSessionModel({
    required this.gradeId,
    required this.platformType,
    required this.meetingUrl,
  });

  final String gradeId;
  final String platformType;
  final String meetingUrl;

  factory LiveSessionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return LiveSessionModel(
      gradeId:
          map[FirestoreFields.gradeId] as String,
      platformType:
          map[FirestoreFields.platformType] as String,
      meetingUrl:
          map[FirestoreFields.meetingUrl] as String,
    );
  }

  factory LiveSessionModel.fromEntity(
    LiveSessionEntity entity,
  ) {
    return LiveSessionModel(
      gradeId: entity.gradeId,
      platformType: entity.platformType.value,
      meetingUrl: entity.meetingUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreFields.gradeId: gradeId,
      FirestoreFields.platformType: platformType,
      FirestoreFields.meetingUrl: meetingUrl,
    };
  }

  LiveSessionEntity toEntity() {
    return LiveSessionEntity(
      gradeId: gradeId,
      platformType:
          MeetingType.fromValue(platformType),
      meetingUrl: meetingUrl,
    );
  }
}
