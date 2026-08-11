import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewNotesLoadingSkeleton extends StatelessWidget {
  const ViewNotesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SkeletonBox(height: 56.h, borderRadius: BorderRadius.circular(16.r)),
        verticalSpace(16),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: _SkeletonBox(
                height: 52.h,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: _SkeletonBox(
                height: 52.h,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ],
        ),
        verticalSpace(24),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) {
              return verticalSpace(12);
            },
            itemBuilder: (_, __) {
              return const _NoteCardSkeleton();
            },
          ),
        ),
        verticalSpace(16),
        _SkeletonBox(height: 56.h, borderRadius: BorderRadius.circular(16.r)),
      ],
    );
  }
}

class _NoteCardSkeleton extends StatelessWidget {
  const _NoteCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 116.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: ColorPalette.border, width: 1.w),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.62,
                  alignment: Alignment.centerRight,
                  child: _SkeletonBox(
                    height: 18.h,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                verticalSpace(12),
                FractionallySizedBox(
                  widthFactor: 0.92,
                  alignment: Alignment.centerRight,
                  child: _SkeletonBox(
                    height: 12.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                verticalSpace(8),
                FractionallySizedBox(
                  widthFactor: 0.72,
                  alignment: Alignment.centerRight,
                  child: _SkeletonBox(
                    height: 12.h,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          _SkeletonBox(
            width: 78.w,
            height: 34.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.borderRadius,
    this.width,
  });

  final double? width;
  final double height;

  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorPalette.border.withValues(alpha: 0.65),
        borderRadius: borderRadius,
      ),
    );
  }
}
