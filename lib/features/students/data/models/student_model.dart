import 'package:alwaleed_admin/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admin/features/students/domain/entities/student_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.studentId,
    required super.gradeId,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.isActive,
    required super.isLoggedIn,
    super.subscriptionStartAt,
    super.subscriptionEndAt,
    this.createdAt,
    this.updatedAt,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory StudentModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return StudentModel(
      studentId: map[FirestoreFields.studentId] as String? ?? documentId,
      gradeId: map[FirestoreFields.gradeId] as String,
      name: map[FirestoreFields.name] as String,
      email: map[FirestoreFields.email] as String,
      phoneNumber: map[FirestoreFields.phoneNumber] as String,
      subscriptionStartAt: _nullableDateTime(
        map[FirestoreFields.subscriptionStartAt],
      ),
      subscriptionEndAt: _nullableDateTime(
        map[FirestoreFields.subscriptionEndAt],
      ),
      isActive: map[FirestoreFields.isActive] as bool? ?? false,
      isLoggedIn: map[FirestoreFields.isLoggedIn] as bool? ?? false,
      createdAt: _nullableDateTime(map[FirestoreFields.createdAt]),
      updatedAt: _nullableDateTime(map[FirestoreFields.updatedAt]),
    );
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      studentId: entity.studentId,
      gradeId: entity.gradeId,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      subscriptionStartAt: entity.subscriptionStartAt,
      subscriptionEndAt: entity.subscriptionEndAt,
      isActive: entity.isActive,
      isLoggedIn: entity.isLoggedIn,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      FirestoreFields.studentId: studentId,
      FirestoreFields.gradeId: gradeId,
      FirestoreFields.name: name,
      FirestoreFields.email: email,
      FirestoreFields.phoneNumber: phoneNumber,
      FirestoreFields.subscriptionStartAt: _toTimestamp(subscriptionStartAt),
      FirestoreFields.subscriptionEndAt: _toTimestamp(subscriptionEndAt),
      FirestoreFields.isActive: isActive,
      FirestoreFields.isLoggedIn: isLoggedIn,
      FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      FirestoreFields.gradeId: gradeId,
      FirestoreFields.name: name,
      FirestoreFields.email: email,
      FirestoreFields.phoneNumber: phoneNumber,
      FirestoreFields.subscriptionStartAt: _toTimestamp(subscriptionStartAt),
      FirestoreFields.subscriptionEndAt: _toTimestamp(subscriptionEndAt),
      FirestoreFields.isActive: isActive,
      FirestoreFields.isLoggedIn: isLoggedIn,
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static Timestamp? _toTimestamp(DateTime? value) {
    if (value == null) {
      return null;
    }

    return Timestamp.fromDate(value);
  }

  static DateTime? _nullableDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
