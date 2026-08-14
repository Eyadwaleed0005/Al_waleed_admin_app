import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLessonLoadingSkeleton extends StatefulWidget {
  const EditLessonLoadingSkeleton({super.key});

  @override
  State<EditLessonLoadingSkeleton> createState() {
    return _EditLessonLoadingSkeletonState();
  }
}

class _EditLessonLoadingSkeletonState extends State<EditLessonLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabelSkeleton(width: 90.w),

                    verticalSpace(8),

                    _buildSkeletonBox(
                      height: 56.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(18),

                    _buildLabelSkeleton(width: 82.w),

                    verticalSpace(8),

                    _buildSkeletonBox(
                      height: 116.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(20),

                    _buildOptionsSkeleton(),

                    verticalSpace(20),

                    _buildLabelSkeleton(width: 145.w),

                    verticalSpace(8),

                    _buildSkeletonBox(
                      height: 56.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    verticalSpace(20),

                    _buildSkeletonBox(
                      height: 116.h,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ],
                ),
              ),
            ),

            verticalSpace(16),

            SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSkeletonBox(
                    height: 56.h,
                    borderRadius: BorderRadius.circular(16.r),
                  ),

                  verticalSpace(12),

                  _buildDeleteButtonSkeleton(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabelSkeleton({required double width}) {
    return Align(
      alignment: Alignment.centerRight,
      child: _buildSkeletonBox(
        width: width,
        height: 14.h,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _buildOptionsSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300.w) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),

              verticalSpace(12),

              _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ],
          );
        }

        return Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              flex: 3,
              child: _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),

            horizontalSpace(16),

            Expanded(
              flex: 5,
              child: _buildSkeletonBox(
                height: 56.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteButtonSkeleton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorPalette.error.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorPalette.error.withValues(alpha: 0.16),
          width: 1.2.w,
        ),
      ),
      alignment: Alignment.center,
      child: _buildSkeletonBox(
        width: 120.w,
        height: 16.h,
        borderRadius: BorderRadius.circular(7.r),
      ),
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    final movement = _animationController.value * 3;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        gradient: LinearGradient(
          begin: Alignment(-1.5 + movement, 0),
          end: Alignment(-0.5 + movement, 0),
          colors: const [
            Color(0xFFE0E7E2),
            Color(0xFFF4F7F5),
            Color(0xFFE0E7E2),
          ],
          stops: [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}
