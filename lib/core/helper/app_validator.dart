class AppValidator {
  AppValidator._();

  static String? employeeName(String value) {
    final name = value.trim();

    if (name.isEmpty) {
      return 'من فضلك املأ الاسم';
    }

    final words = name.split(RegExp(r'\s+'));

    if (words.length > 3) {
      return 'الاسم يجب ألا يزيد عن ثلاث كلمات';
    }

    return null;
  }

  static String? employeeAge(String value) {
    final age = value.trim();

    if (age.isEmpty) {
      return 'من فضلك املأ السن';
    }

    if (!RegExp(r'^\d+$').hasMatch(age)) {
      return 'من فضلك أدخل السن بشكل صحيح';
    }

    if (age.length != 2) {
      return 'السن يجب أن يكون رقمين فقط';
    }

    return null;
  }

  static String? employeeSalary(String value) {
    final salary = value.trim();

    if (salary.isEmpty) {
      return 'من فضلك املأ الراتب';
    }

    if (double.tryParse(salary) == null) {
      return 'من فضلك أدخل الراتب بشكل صحيح';
    }

    return null;
  }
}