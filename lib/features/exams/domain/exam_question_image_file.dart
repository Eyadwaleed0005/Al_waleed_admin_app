import 'dart:typed_data';

class ExamQuestionImageFile {
  const ExamQuestionImageFile({
    required this.name,
    required this.sizeInBytes,
    required this.bytes,
    this.path,
  });

  final String name;
  final int sizeInBytes;
  final Uint8List bytes;
  final String? path;
}