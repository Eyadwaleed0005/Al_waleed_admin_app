import 'package:alwaleed_admain/app/routes/app_images_routes.dart';
import 'package:alwaleed_admain/app/routes/route_names.dart';
import 'package:alwaleed_admain/core/helper/app_system_ui.dart';
import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_animations.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:alwaleed_admain/core/widgets/app_network_aware_content.dart';
import 'package:alwaleed_admain/core/widgets/backgrounds/content_management_background.dart';
import 'package:alwaleed_admain/core/widgets/custom_header_bar.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/content_management_welcome_card.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/content_section_card.dart';
import 'package:alwaleed_admain/features/study_notes/presentation/widgets/content_sections_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentManagementScreen extends StatelessWidget {
  const ContentManagementScreen({super.key});

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
                      child: CustomHeaderBar(
                        title: 'محتوى الكيمياء',
                        iconPath: AppImage().profileIcon,
                      ),
                    ),
                    verticalSpace(30),
                    AppAnimations.screenSection(
                      delay: 100,
                      child: const ContentManagementWelcomeCard(),
                    ),
                    verticalSpace(28),
                    AppAnimations.screenSection(
                      delay: 220,
                      child: const ContentSectionsTitle(),
                    ),
                    verticalSpace(14),
                    AppAnimations.screenSection(
                      delay: 320,
                      child: ContentSectionCard(
                        title: 'الدروس',
                        subtitle: 'إضافة الدروس وتنظيم المحتوى التعليمي',
                        icon: Icons.menu_rounded,
                        backgroundColor: ColorPalette.primarySoftBackground,
                        iconBackgroundColor: ColorPalette.primary,
                        iconColor: ColorPalette.surface,
                        titleColor: ColorPalette.deepSurface,
                        subtitleColor: ColorPalette.textSecondary,
                        onTap: () {},
                      ),
                    ),
                    verticalSpace(14),
                    AppAnimations.screenSection(
                      delay: 420,
                      child: ContentSectionCard(
                        title: 'المذكرات',
                        subtitle: 'إضافة المذكرات وإدارة ملفات PDF',
                        icon: Icons.article_outlined,
                        backgroundColor: ColorPalette.secondary.withValues(
                          alpha: 0.08,
                        ),
                        iconBackgroundColor: ColorPalette.secondary,
                        iconColor: ColorPalette.surface,
                        titleColor: ColorPalette.deepSurface,
                        subtitleColor: ColorPalette.textSecondary,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RouteNames.viewNotesScreen);
                        },
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
