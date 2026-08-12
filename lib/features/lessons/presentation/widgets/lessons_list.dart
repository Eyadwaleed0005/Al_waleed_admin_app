import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';
import 'package:alwaleed_admain/features/lessons/presentation/widgets/lesson_card.dart';
import 'package:flutter/material.dart';

class LessonsList extends StatelessWidget {
  const LessonsList({
    super.key,
    required this.lessons,
    required this.onLessonTap,
  });

  final List<LessonEntity> lessons;
  final ValueChanged<LessonEntity> onLessonTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: lessons.length,
      separatorBuilder: (_, _) {
        return verticalSpace(12);
      },
      itemBuilder: (context, index) {
        final lesson = lessons[index];

        return LessonCard(
          title: lesson.title,
          subtitle: lesson.subtitle,
          isPublished: lesson.isPublished,
          onTap: () {
            onLessonTap(lesson);
          },
        );
      },
    );
  }
}