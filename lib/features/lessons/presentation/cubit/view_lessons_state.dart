import 'package:alwaleed_admain/core/errors/error_model/app_error_model.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/lessons/domain/entities/lesson_entity.dart';

enum LessonPublicationFilter { all, published, unpublished }

sealed class ViewLessonsState {
  const ViewLessonsState();
}

final class ViewLessonsInitial extends ViewLessonsState {
  const ViewLessonsInitial();
}

final class ViewLessonsLoading extends ViewLessonsState {
  const ViewLessonsLoading();
}

final class ViewLessonsFailure extends ViewLessonsState {
  const ViewLessonsFailure({required this.error});

  final AppErrorModel error;
}

final class ViewLessonsDataSuccess extends ViewLessonsState {
  const ViewLessonsDataSuccess({
    required this.grades,
    required this.lessons,
    this.searchQuery = '',
    this.selectedGradeId = '',
    this.selectedPublicationFilter = LessonPublicationFilter.all,
  });

  final List<GradeEntity> grades;
  final List<LessonEntity> lessons;

  final String searchQuery;
  final String selectedGradeId;

  final LessonPublicationFilter selectedPublicationFilter;

  bool get hasNoLessons {
    return lessons.isEmpty;
  }

  bool get hasActiveFilters {
    return searchQuery.trim().isNotEmpty ||
        selectedGradeId.trim().isNotEmpty ||
        selectedPublicationFilter != LessonPublicationFilter.all;
  }

  List<LessonEntity> get filteredLessons {
    final normalizedSearchQuery = searchQuery.trim().toLowerCase();

    final normalizedGradeId = selectedGradeId.trim();

    return lessons
        .where((lesson) {
          final normalizedTitle = lesson.title.trim().toLowerCase();

          final normalizedSubtitle = lesson.subtitle.trim().toLowerCase();

          final matchesSearch =
              normalizedSearchQuery.isEmpty ||
              normalizedTitle.contains(normalizedSearchQuery) ||
              normalizedSubtitle.contains(normalizedSearchQuery);

          final matchesGrade =
              normalizedGradeId.isEmpty ||
              lesson.gradeId.trim() == normalizedGradeId;

          final matchesPublicationStatus = switch (selectedPublicationFilter) {
            LessonPublicationFilter.all => true,
            LessonPublicationFilter.published => lesson.isPublished,
            LessonPublicationFilter.unpublished => !lesson.isPublished,
          };

          return matchesSearch && matchesGrade && matchesPublicationStatus;
        })
        .toList(growable: false);
  }

  bool get hasNoSearchResults {
    return lessons.isNotEmpty && filteredLessons.isEmpty;
  }

  GradeEntity? findGradeById(String gradeId) {
    final normalizedGradeId = gradeId.trim();

    if (normalizedGradeId.isEmpty) {
      return null;
    }

    for (final grade in grades) {
      if (grade.gradeId.trim() == normalizedGradeId) {
        return grade;
      }
    }

    return null;
  }

  ViewLessonsDataSuccess copyWith({
    List<GradeEntity>? grades,
    List<LessonEntity>? lessons,
    String? searchQuery,
    String? selectedGradeId,
    LessonPublicationFilter? selectedPublicationFilter,
  }) {
    return ViewLessonsDataSuccess(
      grades: grades ?? this.grades,
      lessons: lessons ?? this.lessons,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGradeId: selectedGradeId ?? this.selectedGradeId,
      selectedPublicationFilter:
          selectedPublicationFilter ?? this.selectedPublicationFilter,
    );
  }
}
