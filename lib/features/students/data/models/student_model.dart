import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/students/domain/entities/student_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel extends StudentEntity {
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StudentModel({
    required super.studentId,
    required super.gradeId,
    required super.name,
    required super.age,
    required super.email,
    required super.phoneNumber,
    required super.subscriptionStartAt,
    required super.subscriptionEndAt,
    required super.isActive,
    required super.isLoggedIn,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromMap({
    required String documentId,
    required Map<String, dynamic> map,
  }) {
    return StudentModel(
      studentId: map[FirestoreFields.studentId] as String? ?? documentId,
      gradeId: map[FirestoreFields.gradeId] as String,
      name: map[FirestoreFields.name] as String,
      age: (map[FirestoreFields.age] as num).toInt(),
      email: map[FirestoreFields.email] as String,
      phoneNumber: map[FirestoreFields.phoneNumber] as String,
      subscriptionStartAt: _requiredDateTime(
        map[FirestoreFields.subscriptionStartAt],
        FirestoreFields.subscriptionStartAt,
      ),
      subscriptionEndAt: _requiredDateTime(
        map[FirestoreFields.subscriptionEndAt],
        FirestoreFields.subscriptionEndAt,
      ),
      isActive: map[FirestoreFields.isActive] as bool? ?? true,
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
      age: entity.age,
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
      FirestoreFields.age: age,
      FirestoreFields.email: email,
      FirestoreFields.phoneNumber: phoneNumber,
      FirestoreFields.subscriptionStartAt: Timestamp.fromDate(
        subscriptionStartAt,
      ),
      FirestoreFields.subscriptionEndAt: Timestamp.fromDate(subscriptionEndAt),
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
      FirestoreFields.age: age,
      FirestoreFields.email: email,
      FirestoreFields.phoneNumber: phoneNumber,
      FirestoreFields.subscriptionStartAt: Timestamp.fromDate(
        subscriptionStartAt,
      ),
      FirestoreFields.subscriptionEndAt: Timestamp.fromDate(subscriptionEndAt),
      FirestoreFields.isActive: isActive,
      FirestoreFields.isLoggedIn: isLoggedIn,
      FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static DateTime _requiredDateTime(dynamic value, String fieldName) {
    final dateTime = _nullableDateTime(value);

    if (dateTime == null) {
      throw FormatException('Required date field is missing: $fieldName');
    }

    return dateTime;
  }

  static DateTime? _nullableDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

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
