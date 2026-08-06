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
  late final String bookOpen = '${baseIcons}book_open.png';
  late final String exams = '${baseIcons}exams.png';
  late final String home = '${baseIcons}home.png';
  late final String liveSession = '${baseIcons}live_session.png';
  late final String studyNotes = '${baseIcons}study_notes.png';
  late final String students = '${baseIcons}students.png';
  late final String search = '${baseIcons}search.png';

  // ===== animations =====
}
