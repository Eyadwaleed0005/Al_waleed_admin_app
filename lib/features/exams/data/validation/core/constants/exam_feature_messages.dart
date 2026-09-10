abstract final class ExamFeatureMessages {
  const ExamFeatureMessages._();

  static const String editingLocked =
      'بدأ طالب واحد على الأقل هذا الاختبار، لذلك لا يمكنك تعديل '
      'إعدادات الاختبار أو أسئلته أو إلغاء نشره.';

  static const String settingsEditingLocked =
      'لا يمكنك تعديل إعدادات الاختبار بعد بدء أول طالب.';

  static const String questionsEditingLocked =
      'لا يمكنك تعديل أسئلة الاختبار بعد بدء أول طالب.';

  static const String unpublishingLocked =
      'لا يمكنك إلغاء نشر الاختبار بعد بدء أول طالب.';

  static const String endedExamEditingLocked =
      'لا يمكن تعديل اختبار منتهٍ.';

  static const String closeExamOnly =
      'يمكنك إغلاق الاختبار فقط بعد بدء الطلاب.';

  static const String deletionLocked =
      'لا يمكن حذف الاختبار قبل إغلاقه لأن طالبًا واحدًا على الأقل '
      'بدأ الاختبار وقد يكون ما زال يؤديه.';

  static const String deletionInProgress =
      'جاري حذف الاختبار حاليًا، لا يمكن تنفيذ هذه العملية.';

  static const String questionsLimitReached =
      'وصل الاختبار إلى الحد الأقصى المسموح به من الأسئلة.';

  static const String publishingRequiresQuestions =
      'لا يمكن نشر الاختبار قبل إضافة سؤال واحد على الأقل.';

  static const String resultsAvailableAfterClosing =
      'تظهر نتائج الطلاب بعد إغلاق الاختبار.';
}