import 'package:alwaleed_admin/core/helper/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamResultsLoadingSkeleton extends StatefulWidget {
  const ExamResultsLoadingSkeleton({super.key});

  @override
  State<ExamResultsLoadingSkeleton> createState() =>
      _ExamResultsLoadingSkeletonState();
}

class _ExamResultsLoadingSkeletonState extends State<ExamResultsLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacityAnimation = Tween<double>(begin: 0.45, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _SkeletonBox(height: 86.h, borderRadius: 20.r),
          verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(height: 74.h, borderRadius: 16.r),
              ),
              horizontalSpace(16),
              Expanded(
                child: _SkeletonBox(height: 74.h, borderRadius: 16.r),
              ),
            ],
          ),
          verticalSpace(24),
          ...List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: _StudentResultCardSkeleton(isLastItem: index == 3),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentResultCardSkeleton extends StatelessWidget {
  const _StudentResultCardSkeleton({required this.isLastItem});

  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isLastItem
            ? const Color(0xFFF4E3E1)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE1E5E3)),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 66.w, height: 34.h, borderRadius: 10.r),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SkeletonBox(width: 92.w, height: 13.h, borderRadius: 6.r),
              verticalSpace(9),
              _SkeletonBox(width: 70.w, height: 10.h, borderRadius: 5.r),
            ],
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
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE5DF),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
