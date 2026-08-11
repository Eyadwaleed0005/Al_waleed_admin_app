import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/study_note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudyNotesList extends StatelessWidget {
  const StudyNotesList({
    super.key,
    required this.notes,
    required this.onNoteTap,
  });

  final List<StudyNoteEntity> notes;

  final ValueChanged<StudyNoteEntity>
      onNoteTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior
              .onDrag,
      padding: EdgeInsets.only(
        bottom: 20.h,
      ),
      itemCount: notes.length,
      separatorBuilder: (_, __) {
        return verticalSpace(12);
      },
      itemBuilder: (context, index) {
        final note = notes[index];

        return StudyNoteCard(
          name: note.name,
          description: note.description,
          isPublished: note.isPublished,
          onTap: () {
            onNoteTap(note);
          },
        );
      },
    );
  }
}