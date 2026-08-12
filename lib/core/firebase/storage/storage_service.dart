import 'package:firebase_storage/firebase_storage.dart';

typedef StorageProgressCallback = void Function(double progress);

abstract class StorageService {
  Future<FullMetadata> uploadFile({
    required String localFilePath,
    required String storagePath,
    required String contentType,
    Map<String, String>? customMetadata,
    StorageProgressCallback? onProgress,
  });

  Future<FullMetadata> getFileMetadata({
    required String storagePath,
  });

  Future<void> deleteFile({
    required String storagePath,
  });
}