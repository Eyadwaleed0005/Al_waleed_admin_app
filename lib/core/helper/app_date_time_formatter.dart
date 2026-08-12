class AppFormattedDateTime {
  const AppFormattedDateTime({
    required this.date,
    required this.time,
  });

  final String date;
  final String time;
}

abstract final class AppDateTimeFormatter {
  const AppDateTimeFormatter._();

  static const List<String> _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const String _englishDigits = '0123456789';
  static const String _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

  static AppFormattedDateTime separate(
    DateTime dateTime,
  ) {
    return AppFormattedDateTime(
      date: formatDate(dateTime),
      time: formatTime(dateTime),
    );
  }

  static String formatDate(
    DateTime dateTime, {
    bool useArabicDigits = true,
  }) {
    final localDateTime = dateTime.toLocal();

    final day = localDateTime.day.toString();
    final month = _arabicMonths[localDateTime.month - 1];
    final year = localDateTime.year.toString();

    final formattedDate = '$day $month $year';

    if (!useArabicDigits) {
      return formattedDate;
    }

    return _convertToArabicDigits(formattedDate);
  }

  static String formatTime(
    DateTime dateTime, {
    bool useArabicDigits = true,
    bool use24HourFormat = false,
  }) {
    final localDateTime = dateTime.toLocal();

    if (use24HourFormat) {
      final hour = _twoDigits(localDateTime.hour);
      final minute = _twoDigits(localDateTime.minute);

      final formattedTime = '$hour:$minute';

      if (!useArabicDigits) {
        return formattedTime;
      }

      return _convertToArabicDigits(formattedTime);
    }

    final period = localDateTime.hour < 12 ? 'ص' : 'م';

    var hour = localDateTime.hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    final minute = _twoDigits(localDateTime.minute);

    final formattedTime = '$hour:$minute $period';

    if (!useArabicDigits) {
      return formattedTime;
    }

    return _convertToArabicDigits(formattedTime);
  }

  static String formatDateAndTime(
    DateTime dateTime, {
    bool useArabicDigits = true,
  }) {
    final date = formatDate(
      dateTime,
      useArabicDigits: useArabicDigits,
    );

    final time = formatTime(
      dateTime,
      useArabicDigits: useArabicDigits,
    );

    return '$date، الساعة $time';
  }

  static String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  static String _convertToArabicDigits(String value) {
    final buffer = StringBuffer();

    for (final character in value.split('')) {
      final digitIndex = _englishDigits.indexOf(character);

      if (digitIndex == -1) {
        buffer.write(character);
        continue;
      }

      buffer.write(_arabicDigits[digitIndex]);
    }

    return buffer.toString();
  }
}