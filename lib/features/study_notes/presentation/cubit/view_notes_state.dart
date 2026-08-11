import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/study_notes/domain/entities/study_note_entity.dart';

enum NotePublicationFilter { all, published, unpublished }

sealed class ViewNotesState {
  const ViewNotesState();
}

final class ViewNotesInitial extends ViewNotesState {
  const ViewNotesInitial();
}

final class ViewNotesLoading extends ViewNotesState {
  const ViewNotesLoading();
}

final class ViewNotesFailure extends ViewNotesState {
  const ViewNotesFailure({
    required this.error,
    this.message =
        'تعذر تحميل بيانات المذكرات، تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
  });

  final AppErrorModel error;
  final String message;
}

final class ViewNotesDataSuccess extends ViewNotesState {
  const ViewNotesDataSuccess({
    required this.grades,
    required this.notes,
    this.searchQuery = '',
    this.selectedGradeId = '',
    this.selectedPublicationFilter = NotePublicationFilter.all,
  });

  final List<GradeEntity> grades;
  final List<StudyNoteEntity> notes;

  final String searchQuery;
  final String selectedGradeId;

  final NotePublicationFilter selectedPublicationFilter;

  bool get hasNoNotes => notes.isEmpty;

  bool get hasActiveFilters {
    return searchQuery.trim().isNotEmpty ||
        selectedGradeId.trim().isNotEmpty ||
        selectedPublicationFilter != NotePublicationFilter.all;
  }

  List<StudyNoteEntity> get filteredNotes {
    final normalizedSearchQuery = searchQuery.trim().toLowerCase();

    final normalizedGradeId = selectedGradeId.trim();

    return notes
        .where((note) {
          final matchesSearch =
              normalizedSearchQuery.isEmpty ||
              note.name.toLowerCase().contains(normalizedSearchQuery);

          final matchesGrade =
              normalizedGradeId.isEmpty || note.gradeId == normalizedGradeId;

          final matchesPublicationStatus = switch (selectedPublicationFilter) {
            NotePublicationFilter.all => true,
            NotePublicationFilter.published => note.isPublished,
            NotePublicationFilter.unpublished => !note.isPublished,
          };

          return matchesSearch && matchesGrade && matchesPublicationStatus;
        })
        .toList(growable: false);
  }

  bool get hasNoSearchResults {
    return notes.isNotEmpty && filteredNotes.isEmpty;
  }

  ViewNotesDataSuccess copyWith({
    List<GradeEntity>? grades,
    List<StudyNoteEntity>? notes,
    String? searchQuery,
    String? selectedGradeId,
    NotePublicationFilter? selectedPublicationFilter,
  }) {
    return ViewNotesDataSuccess(
      grades: grades ?? this.grades,
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGradeId: selectedGradeId ?? this.selectedGradeId,
      selectedPublicationFilter:
          selectedPublicationFilter ?? this.selectedPublicationFilter,
    );
  }
}
