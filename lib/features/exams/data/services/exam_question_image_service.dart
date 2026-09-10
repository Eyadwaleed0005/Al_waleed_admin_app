import 'package:alwaleed_admin/core/errors/exceptions/firebase_remote_exception.dart';
import 'package:alwaleed_admin/core/firebase/firestore/firestore_collections.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_content_types.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_folders.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_metadata_fields.dart';
import 'package:alwaleed_admin/core/firebase/storage/storage_service.dart';
import 'package:alwaleed_admin/features/exams/domain/exam_question_image_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ExamQuestionImageUploadResult {
  const ExamQuestionImageUploadResult({
    required this.downloadUrl,
    required this.storagePath,
  });

  final String downloadUrl;
  final String storagePath;
}

class ExamQuestionImageService {
  const ExamQuestionImageService({
    required this._storageService,
    required this._firebaseFirestore,
  });

  final StorageService _storageService;
  final FirebaseFirestore _firebaseFirestore;

  Future<ExamQuestionImageUploadResult> uploadImage({
    required ExamQuestionImageFile image,
    required String examId,
    required String questionId,
  }) async {
    final String storagePath = createImageStoragePath(
      examId: examId,
      questionId: questionId,
      imageName: image.name,
    );

    try {
      await _storageService.uploadData(
        data: image.bytes,
        storagePath: storagePath,
        contentType: getImageContentType(image.name),
        customMetadata: <String, String>{
          StorageMetadataFields.examId: examId,
          StorageMetadataFields.questionId: questionId,
          StorageMetadataFields.originalFileName: image.name,
        },
      );

      final String downloadUrl = await _storageService.getDownloadUrl(
        storagePath: storagePath,
      );

      return ExamQuestionImageUploadResult(
        downloadUrl: downloadUrl,
        storagePath: storagePath,
      );
    } catch (_) {
      await deleteImageSilently(storagePath: storagePath);
      rethrow;
    }
  }

  Future<void> deleteImage({required String? storagePath}) async {
    final String normalizedPath = storagePath?.trim() ?? '';

    if (normalizedPath.isEmpty) {
      return;
    }

    try {
      await _storageService.deleteFile(storagePath: normalizedPath);
    } catch (error) {
      if (_isObjectNotFound(error)) {
        return;
      }

      rethrow;
    }
  }

  Future<void> deleteImages({required Iterable<String?> storagePaths}) async {
    final Set<String> normalizedPaths = storagePaths
        .map((String? path) => path?.trim() ?? '')
        .where((String path) => path.isNotEmpty)
        .toSet();

    for (final String storagePath in normalizedPaths) {
      await deleteImage(storagePath: storagePath);
    }
  }

  Future<void> deleteImageSilently({required String? storagePath}) async {
    try {
      await deleteImage(storagePath: storagePath);
    } catch (_) {}
  }

  Future<void> deleteImagesSilently({
    required Iterable<String?> storagePaths,
  }) async {
    final Set<String> normalizedPaths = storagePaths
        .map((String? path) => path?.trim() ?? '')
        .where((String path) => path.isNotEmpty)
        .toSet();

    for (final String storagePath in normalizedPaths) {
      await deleteImageSilently(storagePath: storagePath);
    }
  }

  String createImageStoragePath({
    required String examId,
    required String questionId,
    required String imageName,
  }) {
    final String extension = getFileExtension(imageName);

    final String version = _firebaseFirestore
        .collection(FirestoreCollections.examQuestions)
        .doc()
        .id;

    return '${StorageFolders.examQuestionImages}/'
        '${examId.trim()}/'
        '${questionId.trim()}/'
        '$version.$extension';
  }

  String getFileExtension(String fileName) {
    final String normalizedName = fileName.trim().toLowerCase();

    final int dotIndex = normalizedName.lastIndexOf('.');

    if (dotIndex < 0 || dotIndex == normalizedName.length - 1) {
      throw ArgumentError.value(fileName, 'fileName');
    }

    final String extension = normalizedName.substring(dotIndex + 1);

    return switch (extension) {
      'jpeg' => 'jpg',
      'jpg' || 'png' || 'webp' => extension,
      _ => throw ArgumentError.value(fileName, 'fileName'),
    };
  }

  String getImageContentType(String fileName) {
    return switch (getFileExtension(fileName)) {
      'png' => StorageContentTypes.png,
      'webp' => StorageContentTypes.webp,
      _ => StorageContentTypes.jpeg,
    };
  }

  bool _isObjectNotFound(Object error) {
    if (error is FirebaseRemoteException) {
      return _isObjectNotFoundCode(error.errorModel.code);
    }

    if (error is FirebaseException) {
      return _isObjectNotFoundCode(error.code);
    }

    return false;
  }

  bool _isObjectNotFoundCode(String code) {
    final String normalizedCode = code.trim().toLowerCase();

    return normalizedCode == 'object-not-found' ||
        normalizedCode == 'storage/object-not-found';
  }
}
