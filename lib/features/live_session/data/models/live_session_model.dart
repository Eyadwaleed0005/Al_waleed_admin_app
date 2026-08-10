import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/live_session/domain/entities/live_session_entity.dart';

class LiveSessionModel {
  const LiveSessionModel({
    required this.gradeId,
    required this.platformType,
    required this.meetingUrl,
  });

  final String gradeId;
  final String platformType;
  final String meetingUrl;

  factory LiveSessionModel.fromMap(Map<String, dynamic> map) {
    return LiveSessionModel(
      gradeId: map[FirestoreFields.gradeId] as String,
      platformType: map[FirestoreFields.platformType] as String,
      meetingUrl: map[FirestoreFields.meetingUrl] as String,
    );
  }

  factory LiveSessionModel.fromEntity(
    LiveSessionEntity entity,
  ) {
    return LiveSessionModel(
      gradeId: entity.gradeId,
      platformType: entity.platformType,
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
      platformType: platformType,
      meetingUrl: meetingUrl,
    );
  }
}