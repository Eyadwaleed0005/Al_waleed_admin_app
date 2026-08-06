import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/widgets/custom_filter_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

class StudentSearchFilterSection extends StatelessWidget {
  const StudentSearchFilterSection({
    super.key,
    this.searchController,
    this.gradeText = 'كل الصفوف',
    this.statusText = 'كل الحالات',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchTap,
    required this.onGradeFilterTap,
    required this.onStatusFilterTap,
  });

  final TextEditingController? searchController;

  final String gradeText;
  final String statusText;

  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchTap;

  final VoidCallback onGradeFilterTap;
  final VoidCallback onStatusFilterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchBar(
          controller: searchController,
          hintText: 'البحث بالاسم أو رقم الهاتف',
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          onSearchTap: onSearchTap,
        ),
        verticalSpace(16),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: CustomFilterButton(
                text: gradeText,
                onTap: onGradeFilterTap,
              ),
            ),

            horizontalSpace(16),

            Expanded(
              child: CustomFilterButton(
                text: statusText,
                onTap: onStatusFilterTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
