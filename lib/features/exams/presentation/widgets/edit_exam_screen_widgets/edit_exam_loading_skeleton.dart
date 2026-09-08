import 'package:alwaleed_admain/core/helper/spacer.dart';
import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditExamLoadingSkeleton extends StatefulWidget {
  const EditExamLoadingSkeleton({super.key});

  @override
  State<EditExamLoadingSkeleton> createState() {
    return _EditExamLoadingSkeletonState();
  }
}

class _EditExamLoadingSkeletonState extends State<EditExamLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _opacityAnimation = Tween<double>(begin: 0.42, end: 0.90).animate(
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
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _FormFieldSkeleton(labelWidth: 90),
            verticalSpace(24),
            const _FormFieldSkeleton(labelWidth: 75),
            verticalSpace(24),
            const _FormFieldSkeleton(labelWidth: 135),
            verticalSpace(24),
            const _PublicationSwitchSkeleton(),
            verticalSpace(24),
            const _ButtonSkeleton(),
            verticalSpace(28),
            const _ButtonSkeleton(isPrimary: true),
            verticalSpace(12),
            const _ButtonSkeleton(),
            verticalSpace(12),
            const _ButtonSkeleton(isDelete: true),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}

class _FormFieldSkeleton extends StatelessWidget {
  const _FormFieldSkeleton({required this.labelWidth});

  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SkeletonBox(width: labelWidth.w, height: 18.h, borderRadius: 7),
        verticalSpace(10),
        const _SkeletonBox(
          width: double.infinity,
          height: 58,
          borderRadius: 15,
        ),
      ],
    );
  }
}

class _PublicationSwitchSkeleton extends StatelessWidget {
  const _PublicationSwitchSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SkeletonBox(width: 100.w, height: 18.h, borderRadius: 7),
        verticalSpace(10),
        Container(
          width: double.infinity,
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorPalette.surface,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: ColorPalette.border, width: 1.w),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _SkeletonBox(width: 72.w, height: 16.h, borderRadius: 7),
              const Spacer(),
              _SkeletonBox(width: 48.w, height: 27.h, borderRadius: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _ButtonSkeleton extends StatelessWidget {
  const _ButtonSkeleton({this.isPrimary = false, this.isDelete = false});

  final bool isPrimary;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDelete
        ? ColorPalette.error.withValues(alpha: 0.10)
        : isPrimary
        ? ColorPalette.primary.withValues(alpha: 0.15)
        : ColorPalette.primary.withValues(alpha: 0.08);

    final Color borderColor = isDelete
        ? ColorPalette.error.withValues(alpha: 0.16)
        : ColorPalette.primary.withValues(alpha: 0.14);

    return Container(
      width: double.infinity,
      height: 54.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: _SkeletonBox(
        width: isDelete ? 105.w : 130.w,
        height: 16.h,
        borderRadius: 7,
        color: isDelete
            ? ColorPalette.error.withValues(alpha: 0.16)
            : ColorPalette.primary.withValues(alpha: 0.16),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    this.color,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height.h,
      decoration: BoxDecoration(
        color: color ?? ColorPalette.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
    );
  }
}
