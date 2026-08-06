import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:flutter/material.dart';

class RouteNavBottom {
  RouteNavBottom._();

  static List<String> get icons => [
    AppImage().home,
    AppImage().students,
    AppImage().bookOpen,
    AppImage().exams,
    AppImage().liveSession,
  ];

  static const List<String> titles = [
    'الرئيسية',
    'الطلاب',
    'المحتوى',
    'الامتحانات',
    'الحصة',
  ];

  static List<Widget> screens({
    required Widget homeScreen,
    required Widget contentScreen,
    required Widget examsScreen,
    required Widget studyNotesScreen,
    required Widget liveSessionScreen,
  }) {
    return [
      homeScreen,
      contentScreen,
      examsScreen,
      studyNotesScreen,
      liveSessionScreen,
    ];
  }
}
