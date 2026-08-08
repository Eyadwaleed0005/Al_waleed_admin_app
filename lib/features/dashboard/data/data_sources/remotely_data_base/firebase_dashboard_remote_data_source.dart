import 'package:alwaleed_admain/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admain/core/errors/handlers/firebase_error_handler.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admain/core/firebase/firestore/firestore_fields.dart';
import 'package:alwaleed_admain/features/dashboard/data/data_sources/remotely_data_base/dashboard_remote_data_source.dart';
import 'package:alwaleed_admain/features/dashboard/data/models/dashboard_students_summary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDashboardRemoteDataSource implements DashboardRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;

  const FirebaseDashboardRemoteDataSource({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  @override
  Future<DashboardStudentsSummaryModel> getStudentsSummary() {
    return _execute(() async {
      final studentsCollection = _firebaseFirestore.collection(
        FirestoreCollections.students,
      );

      final currentTimestamp = Timestamp.fromDate(DateTime.now());

      final results = await Future.wait([
        studentsCollection.count().get(),
        studentsCollection
            .where(
              FirestoreFields.subscriptionEndAt,
              isLessThanOrEqualTo: currentTimestamp,
            )
            .count()
            .get(),
      ]);

      final totalStudents = results[0].count ?? 0;

      final expiredSubscriptions = results[1].count ?? 0;

      return DashboardStudentsSummaryModel(
        totalStudents: totalStudents,
        expiredSubscriptions: expiredSubscriptions,
      );
    });
  }

  Future<T> _execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      if (error is FirebaseRemoteException) {
        Error.throwWithStackTrace(error, stackTrace);
      }

      final remoteException = FirebaseRemoteException(
        errorModel: FirebaseErrorHandler.handle(error),
      );

      Error.throwWithStackTrace(remoteException, stackTrace);
    }
  }
}
