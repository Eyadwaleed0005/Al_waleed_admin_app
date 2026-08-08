import 'package:alwaleed_admain/core/widgets/app_empty_widget.dart';
import 'package:flutter/material.dart';

class AppNoSearchResultsWidget
    extends StatelessWidget {
  const AppNoSearchResultsWidget({
    super.key,
    this.title = 'لا توجد نتائج مطابقة',
    this.message =
        'لم نتمكن من العثور على نتائج مطابقة لبحثك.',
    this.icon = Icons.search_off_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppEmptyWidget(
      title: title,
      message: message,
      icon: icon,
    );
  }
}