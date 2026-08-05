class AppImage {
  static AppImage? _instance;

  factory AppImage() {
    _instance ??= AppImage._internal();
    return _instance!;
  }

  AppImage._internal();

  // Base paths
  final String baseImages = 'assets/images/';
  final String baseAnimation = 'assets/animation/';
  final String baseIcons = 'assets/icons/';

  // ===== images =====
  late final String alwaleedImg = '${baseImages}alwaleed_img.png';
  // ===== icons =====
  late final String profileIcon = '${baseIcons}profile.png';
  // ===== animations =====
}
