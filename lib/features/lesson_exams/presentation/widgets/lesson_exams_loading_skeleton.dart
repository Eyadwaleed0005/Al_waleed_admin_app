import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonExamsLoadingSkeleton extends StatefulWidget {
  const LessonExamsLoadingSkeleton({super.key});

  @override
  State<LessonExamsLoadingSkeleton> createState() {
    return _LessonExamsLoadingSkeletonState();
  }
}

class _LessonExamsLoadingSkeletonState extends State<LessonExamsLoadingSkeleton>
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
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalDegreesCardSkeleton(),

            verticalSpace(20),

            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: 2,
                separatorBuilder: (context, index) {
                  return verticalSpace(16);
                },
                itemBuilder: (context, index) {
                  return _buildQuestionCardSkeleton(hasImage: index == 0);
                },
              ),
            ),

            verticalSpace(16),

            _buildActionsSkeleton(),
          ],
        );
      },
    );
  }

  Widget _buildTotalDegreesCardSkeleton() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 84.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.infoSoftBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorPalette.secondary.withValues(alpha: 0.06),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.58,
                alignment: Alignment.centerRight,
                child: _buildSkeletonBox(
                  height: 16.h,
                  borderRadius: BorderRadius.circular(7.r),
                ),
              ),
            ),
          ),

          horizontalSpace(18),

          _buildSkeletonBox(width: 10.w, height: 10.w, shape: BoxShape.circle),
        ],
      ),
    );
  }

  Widget _buildQuestionCardSkeleton({required bool hasImage}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildQuestionHeaderSkeleton(),

          verticalSpace(18),

          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.78,
              child: _buildSkeletonBox(
                height: 15.h,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
          ),

          verticalSpace(9),

          Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.52,
              child: _buildSkeletonBox(
                height: 13.h,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
          ),

          if (hasImage) ...[
            verticalSpace(16),

            _buildSkeletonBox(
              height: 120.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ],

          verticalSpace(16),

          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == 3 ? 0 : 8.h),
              child: _buildChoiceSkeleton(
                widthFactor: _choiceWidthFactor(index),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionHeaderSkeleton() {
    return SizedBox(
      height: 34.h,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildSkeletonBox(
                width: 82.w,
                height: 19.h,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: _buildSkeletonBox(
                width: 66.w,
                height: 30.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSkeletonBox(
                    width: 32.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),

                  horizontalSpace(10),

                  _buildSkeletonBox(
                    width: 32.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceSkeleton({required double widthFactor}) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 46.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorPalette.primary.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: widthFactor,
                alignment: Alignment.centerRight,
                child: _buildSkeletonBox(
                  height: 13.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),

          horizontalSpace(12),

          _buildSkeletonBox(width: 16.w, height: 16.w, shape: BoxShape.circle),
        ],
      ),
    );
  }

  Widget _buildActionsSkeleton() {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 4.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: _buildSkeletonBox(
              height: 56.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),

          horizontalSpace(12),

          Expanded(
            child: _buildSkeletonBox(
              height: 56.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }

  double _choiceWidthFactor(int index) {
    switch (index) {
      case 0:
        return 0.45;

      case 1:
        return 0.60;

      case 2:
        return 0.38;

      case 3:
        return 0.52;

      default:
        return 0.50;
    }
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    final movement = _animationController.value * 3;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? borderRadius ?? BorderRadius.circular(8.r)
            : null,
        gradient: LinearGradient(
          begin: Alignment(-1.5 + movement, 0),
          end: Alignment(-0.5 + movement, 0),
          colors: const [
            Color(0xFFE0E7E2),
            Color(0xFFF4F7F5),
            Color(0xFFE0E7E2),
          ],
          stops: const [0.2, 0.5, 0.8],
        ),
      ),
    );
  }
}
