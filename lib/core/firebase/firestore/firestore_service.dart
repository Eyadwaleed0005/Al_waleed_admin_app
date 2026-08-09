import 'package:cloud_firestore/cloud_firestore.dart';

typedef FirestoreQueryBuilder = Query<Map<String, dynamic>> Function(
  CollectionReference<Map<String, dynamic>> collection,
);

abstract class FirestoreService {
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String documentId,
  });

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    FirestoreQueryBuilder? queryBuilder,
  });

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String documentId,
    bool includeMetadataChanges = false,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
    FirestoreQueryBuilder? queryBuilder,
    bool includeMetadataChanges = false,
  });

  Future<String> postData({
    required String collectionPath,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<void> patchData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({
    required String collectionPath,
    required String documentId,
  });

  
}