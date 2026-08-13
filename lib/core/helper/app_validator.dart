class AppValidator {
  AppValidator._();

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

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
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
}
