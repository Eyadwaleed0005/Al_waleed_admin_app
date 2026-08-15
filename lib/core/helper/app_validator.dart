class AppValidator {
  AppValidator._();

  static const int maximumLessonPdfSizeInMegabytes = 15;

  static const int maximumLessonPdfSizeInBytes =
      maximumLessonPdfSizeInMegabytes * 1024 * 1024;

  static String? studentName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'من فضلك اكتب اسم الطالب';
    }

    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(name)) {
      return 'اسم الطالب يجب أن يحتوي على حروف فقط';
    }

    final words = name
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.length != 3) {
      return 'من فضلك اكتب اسم الطالب ثلاثيًا';
    }

    return null;
  }

  static String? studentAge(String? value) {
    final ageText = value?.trim() ?? '';

    if (ageText.isEmpty) {
      return 'من فضلك اكتب عمر الطالب';
    }

    final age = int.tryParse(ageText);

    if (age == null) {
      return 'من فضلك اكتب العمر بشكل صحيح';
    }

    if (age < 10) {
      return 'عمر الطالب يجب ألا يقل عن 10 سنوات';
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'من فضلك اكتب رقم الهاتف';
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
    }

    if (phone.length != 11) {
      return 'رقم الهاتف يجب أن يتكون من 11 رقمًا';
    }

    if (!phone.startsWith('01')) {
      return 'رقم الهاتف يجب أن يبدأ بـ 01';
    }

    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'من فضلك اكتب البريد الإلكتروني';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@'
      r'[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegExp.hasMatch(email)) {
      return 'من فضلك اكتب بريدًا إلكترونيًا صحيحًا';
    }

    return null;
  }

  static String? grade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك اختر الصف الدراسي';
    }

    return null;
  }

  static String? liveSessionUrl(String? value) {
    final url = value?.trim() ?? '';

    if (url.isEmpty) {
      return 'من فضلك اكتب رابط الحصة';
    }

    final uri = Uri.tryParse(url);

    if (!_isValidHttpUri(uri)) {
      return 'من فضلك اكتب رابطًا صحيحًا';
    }

    return null;
  }

  static String? strongPassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'من فضلك اكتب كلمة المرور';
    }

    if (password.length < 8) {
      return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    }

    if (password.contains(' ')) {
      return 'كلمة المرور لا يجب أن تحتوي على مسافات';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رقم';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص';
    }

    return null;
  }

  static String? confirmPassword({
    required String? value,
    required String password,
  }) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'من فضلك أعد كتابة كلمة المرور';
    }

    if (confirmPassword != password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  static String? lessonTitle(String? value) {
    final title = value?.trim() ?? '';

    if (title.isEmpty) {
      return 'من فضلك اكتب عنوان الدرس';
    }

    if (title.length > 120) {
      return 'عنوان الدرس يجب ألا يزيد عن 120 حرفًا';
    }

    return null;
  }

  static String? lessonSubtitle(String? value) {
    final subtitle = value?.trim() ?? '';

    if (subtitle.isEmpty) {
      return 'من فضلك اكتب وصف الدرس';
    }

    if (subtitle.length > 400) {
      return 'وصف الدرس يجب ألا يزيد عن 400 حرف';
    }

    return null;
  }

  static String? youtubeUrl(String? value) {
    final url = value?.trim() ?? '';

    if (url.isEmpty) {
      return 'من فضلك اكتب رابط فيديو YouTube';
    }

    final uri = Uri.tryParse(url);

    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'من فضلك اكتب رابطًا صحيحًا';
    }

    final scheme = uri.scheme.toLowerCase();

    if (scheme != 'http' && scheme != 'https') {
      return 'الرابط يجب أن يبدأ بـ http أو https';
    }

    final host = uri.host.toLowerCase();

    final isYoutubeHost =
        host == 'youtu.be' ||
        host == 'youtube.com' ||
        host.endsWith('.youtube.com');

    if (!isYoutubeHost) {
      return 'من فضلك اكتب رابط YouTube صحيحًا';
    }

    return null;
  }

  static String? lessonExamQuestionText(String? value) {
    final questionText = value?.trim() ?? '';

    if (questionText.isEmpty) {
      return 'من فضلك اكتب نص السؤال';
    }

    if (questionText.length < 5) {
      return 'نص السؤال يجب ألا يقل عن 5 أحرف';
    }

    if (questionText.length > 500) {
      return 'نص السؤال يجب ألا يزيد عن 500 حرف';
    }

    return null;
  }

  static String? lessonPdf(Object? value) {
    if (value == null) {
      return 'من فضلك اختر ملف PDF للدرس';
    }

    return null;
  }

  static String? lessonPdfFile({
    required String fileName,
    required String? extension,
    required int sizeInBytes,
    required String? path,
  }) {
    final normalizedName = fileName.trim().toLowerCase();

    final normalizedExtension = extension?.trim().toLowerCase();

    final isPdf =
        normalizedExtension == 'pdf' || normalizedName.endsWith('.pdf');

    if (!isPdf) {
      return 'يجب اختيار ملف PDF فقط';
    }

    if (sizeInBytes <= 0) {
      return 'ملف PDF المحدد فارغ';
    }

    if (sizeInBytes > maximumLessonPdfSizeInBytes) {
      return 'حجم الملف أكبر من الحد الأقصى '
          '${maximumLessonPdfSizeInMegabytes}MB';
    }

    final normalizedPath = path?.trim() ?? '';

    if (normalizedPath.isEmpty) {
      return 'تعذر الوصول إلى مسار الملف المحدد';
    }

    return null;
  }

  static String get lessonPdfPickingFailureMessage {
    return 'تعذر اختيار الملف، حاول مرة أخرى';
  }

  static String? subscriptionStartDate(DateTime? startDate) {
    if (startDate == null) {
      return 'من فضلك اختر تاريخ بداية الاشتراك';
    }

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final normalizedStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    if (normalizedStartDate.isBefore(today)) {
      return 'تاريخ بداية الاشتراك لا يمكن أن يسبق تاريخ اليوم';
    }

    return null;
  }

  static String? subscriptionEndDate({
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    if (startDate == null) {
      return 'اختر تاريخ بداية الاشتراك أولًا';
    }

    if (endDate == null) {
      return 'من فضلك اختر تاريخ انتهاء الاشتراك';
    }

    final normalizedStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final normalizedEndDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    if (!normalizedEndDate.isAfter(normalizedStartDate)) {
      return 'تاريخ انتهاء الاشتراك يجب أن يكون بعد تاريخ البداية';
    }

    return null;
  }

  static bool _isValidHttpUri(Uri? uri) {
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return false;
    }

    final scheme = uri.scheme.toLowerCase();

    return scheme == 'http' || scheme == 'https';
  }

  static String? lessonExamQuestionDegree(String? value) {
    final degreeText = value?.trim() ?? '';

    if (degreeText.isEmpty) {
      return 'من فضلك اكتب درجة السؤال';
    }

    if (!RegExp(r'^\d+$').hasMatch(degreeText)) {
      return 'درجة السؤال يجب أن تحتوي على أرقام فقط';
    }

    final degree = int.tryParse(degreeText);

    if (degree == null) {
      return 'من فضلك اكتب درجة صحيحة';
    }

    if (degree <= 0) {
      return 'درجة السؤال يجب أن تكون أكبر من صفر';
    }

    return null;
  }

  static String? lessonExamQuestionChoice(String? value) {
    final choice = value?.trim() ?? '';

    if (choice.isEmpty) {
      return 'من فضلك اكتب نص الاختيار';
    }

    if (choice.length > 200) {
      return 'نص الاختيار يجب ألا يزيد عن 200 حرف';
    }

    return null;
  }
}
