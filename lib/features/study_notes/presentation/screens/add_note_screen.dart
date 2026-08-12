import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/secondary_custom_header_bar.dart';
import 'package:alwaleed_admain/features/grades/domain/entities/grade_entity.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/add_note_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    this.grades = const [],
    this.onAddNotePressed,
  });

  final List<GradeEntity> grades;
  final VoidCallback? onAddNotePressed;

  @override
  State<AddNoteScreen> createState() {
    return _AddNoteScreenState();
  }
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String _selectedGradeId = '';
  bool _isPublished = false;

  PlatformFile? _selectedPdfFile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        body: ContentManagementBackground(
          child: SafeArea(
            child: AppNetworkAwareContent(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppAnimations.screenSection(
                      delay: 0,
                      child: const SecondaryCustomHeaderBar(
                        title: 'إضافة مذكرة',
                      ),
                    ),

                    verticalSpace(30),

                    Expanded(
                      child: AppAnimations.screenSection(
                        delay: 120,
                        child: AddNoteContent(
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                          grades: widget.grades,
                          selectedGradeId: _selectedGradeId,
                          isPublished: _isPublished,
                          isLoading: _isLoading,
                          isButtonEnabled: true,
                          onGradeSelected: _onGradeSelected,
                          onPublicationChanged: _onPublicationChanged,
                          onPdfSelected: _onPdfSelected,
                          onPdfRemoved: _onPdfRemoved,
                          onAddNotePressed: _onAddNotePressed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onGradeSelected(String gradeId) {
    setState(() {
      _selectedGradeId = gradeId;
    });

    debugPrint('Selected grade ID: $gradeId');
  }

  void _onPublicationChanged(bool isPublished) {
    setState(() {
      _isPublished = isPublished;
    });

    debugPrint('Is note published: $isPublished');
  }

  void _onPdfSelected(PlatformFile file) {
    setState(() {
      _selectedPdfFile = file;
    });

    debugPrint('Selected PDF name: ${file.name}');
    debugPrint('Selected PDF path: ${file.path}');
  }

  void _onPdfRemoved() {
    setState(() {
      _selectedPdfFile = null;
    });

    debugPrint('Selected PDF removed');
  }

  Future<void> _onAddNotePressed() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (widget.onAddNotePressed != null) {
      widget.onAddNotePressed!();
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    debugPrint('Note title: $title');
    debugPrint('Note description: $description');
    debugPrint('Note grade ID: $_selectedGradeId');
    debugPrint('Note published: $_isPublished');
    debugPrint('Note PDF: ${_selectedPdfFile?.name}');

    // مؤقتًا لعرض حالة تحميل الزرار فقط.
    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    // عند إنشاء AddNoteCubit هنستبدل الجزء السابق بـ:
    //
    // context.read<AddNoteCubit>().createNote();
  }
}
