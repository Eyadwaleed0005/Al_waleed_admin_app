import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentExamResultsLoadingSkeleton extends StatelessWidget {
  const StudentExamResultsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        children: [
          _SkeletonBox(
            width: double.infinity,
            height: 78.h,
            borderRadius: 16.r,
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(height: 68.h, borderRadius: 14.r),
              ),
              horizontalSpace(8),
              Expanded(
                child: _SkeletonBox(height: 68.h, borderRadius: 14.r),
              ),
              horizontalSpace(8),
              Expanded(
                child: _SkeletonBox(height: 68.h, borderRadius: 14.r),
              ),
            ],
          ),
          verticalSpace(14),
          _SkeletonBox(
            width: double.infinity,
            height: 42.h,
            borderRadius: 10.r,
          ),
          verticalSpace(14),
          const _StudentExamResultCardSkeleton(),
          verticalSpace(12),
          const _StudentExamResultCardSkeleton(),
        ],
      ),
    );
  }
}

class _StudentExamResultCardSkeleton extends StatelessWidget {
  const _StudentExamResultCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorPalette.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorPalette.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _SkeletonBox(width: 58.w, height: 14.h, borderRadius: 6.r),
              const Spacer(),
              _SkeletonBox(width: 145.w, height: 16.h, borderRadius: 6.r),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              _SkeletonBox(width: 72.w, height: 10.h, borderRadius: 5.r),
              const Spacer(),
              _SkeletonBox(width: 96.w, height: 10.h, borderRadius: 5.r),
            ],
          ),
          verticalSpace(14),
          _SkeletonBox(width: double.infinity, height: 6.h, borderRadius: 10.r),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child:
          Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: ColorPalette.border,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              )
              .animate(
                onPlay: (animationController) {
                  animationController.repeat();
                },
              )
              .shimmer(
                duration: 1200.ms,
                color: ColorPalette.surface.withValues(alpha: 0.75),
              ),
    );
  }
}
