import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/style/textstyles.dart';
import 'package:alwaleed_admain/core/widgets/custom_button.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/core/widgets/custom_popup_menu_field.dart';
import 'package:alwaleed_admain/core/widgets/custom_text_form_field.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/live_session_welcome.dart';
import 'package:alwaleed_admain/features/live_session/presentation/widgets/meeting_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _sessionLinkController = TextEditingController();

  String? _selectedGradeId;
  MeetingType? _selectedMeetingType;

  final List<PopupSelectionItem<String>> _gradeItems = const [
    PopupSelectionItem<String>(
      value: 'first_secondary',
      label: 'الصف الأول الثانوي',
    ),
    PopupSelectionItem<String>(
      value: 'second_secondary',
      label: 'الصف الثاني الثانوي',
    ),
    PopupSelectionItem<String>(
      value: 'third_secondary',
      label: 'الصف الثالث الثانوي',
    ),
  ];

  String get _selectedGradeText {
    if (_selectedGradeId == null) {
      return 'حدد الصف الدراسي';
    }

    return _gradeItems
        .firstWhere((item) => item.value == _selectedGradeId)
        .label;
  }

  String get _sessionLinkHint {
    switch (_selectedMeetingType) {
      case MeetingType.zoom:
        return 'https://zoom.us/j/chem-2026';

      case MeetingType.googleMeet:
        return 'https://meet.google.com/abc-defg-hij';

      case null:
        return 'أدخل رابط الحصة المباشرة';
    }
  }

  void _selectGrade(String gradeId) {
    setState(() {
      _selectedGradeId = gradeId;
    });
  }

  void _selectMeetingType(MeetingType meetingType) {
    setState(() {
      _selectedMeetingType = meetingType;
    });
  }

  void _onLinkChanged(String value) {
    setState(() {});
  }

  String? _validateSessionLink(String? value) {
    final link = value?.trim() ?? '';

    if (link.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(link);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      return 'يرجى إدخال رابط صحيح';
    }

    return null;
  }

  void _saveLiveSession() {
    FocusScope.of(context).unfocus();

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final gradeId = _selectedGradeId;
    final meetingType = _selectedMeetingType;
    _sessionLinkController.text.trim();

    if (gradeId == null || meetingType == null) {
      return;
    }
  }

  @override
  void dispose() {
    _sessionLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: Scaffold(
        backgroundColor: ColorPalette.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeaderBar(
                  title: 'رابط الحصة المباشرة',
                  iconPath: AppImage().profileIcon,
                ),
                verticalSpace(35),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LiveSessionWelcome(),
                          verticalSpace(24),
                          Text(
                            'اختر الصف',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style:
                                AppTextStyle.font15TextPrimaryMediumTajawal(),
                          ),
                          verticalSpace(10),
                          CustomPopupMenuField<String>(
                            items: _gradeItems,
                            value: _selectedGradeId,
                            selectedText: _selectedGradeText,
                            filterValue: _selectedGradeId,
                            tooltip: 'اختر الصف الدراسي',
                            emptyTooltip: 'لا توجد صفوف متاحة',
                            onSelected: _selectGrade,
                          ),
                          verticalSpace(24),
                          Text(
                            'منصة البث',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style:
                                AppTextStyle.font15TextPrimaryMediumTajawal(),
                          ),
                          verticalSpace(10),
                          MeetingTypeSelector(
                            selectedType: _selectedMeetingType,
                            onChanged: _selectMeetingType,
                          ),
                          verticalSpace(24),
                          CustomTextFormField(
                            controller: _sessionLinkController,
                            labelText: 'رابط الحصة',
                            hintText: _sessionLinkHint,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            textDirection: TextDirection.ltr,
                            isRequired: true,
                            validator: _validateSessionLink,
                            onChanged: _onLinkChanged,
                          ),
                          verticalSpace(24),
                          CustomButton(
                            text: 'حفظ رابط الحصة',
                            onPressed: _saveLiveSession,
                          ),
                          verticalSpace(24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
