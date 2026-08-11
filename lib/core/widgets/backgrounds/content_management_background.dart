import 'package:alwaleed_admain/core/style/app_color.dart';
import 'package:flutter/material.dart';

class ContentManagementBackground extends StatelessWidget {
  const ContentManagementBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: ColorPalette.background),
            ColoredBox(color: ColorPalette.secondary.withValues(alpha: 0.055)),
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorPalette.paleSage.withValues(alpha: 0.55),
                      ColorPalette.primarySoftBackground.withValues(
                        alpha: 0.15,
                      ),
                      ColorPalette.background.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.42, 0.72],
                  ),
                ),
              ),
            ),

            Positioned(
              top: -height * 0.14,
              right: -width * 0.30,
              width: width * 1.15,
              height: height * 0.52,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.highlight.withValues(alpha: 0.16),
                        ColorPalette.accent.withValues(alpha: 0.30),
                        ColorPalette.accent.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.42, 1],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: -width * 0.48,
              bottom: height * 0.01,
              width: width * 1.25,
              height: height * 0.48,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.secondary.withValues(alpha: 0.20),
                        ColorPalette.secondary.withValues(alpha: 0),
                      ],
                      stops: const [0, 1],
                    ),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: _ScienceDecorations(width: width, height: height),
              ),
            ),

            child,
          ],
        );
      },
    );
  }
}

class _ScienceDecorations extends StatelessWidget {
  const _ScienceDecorations({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: width * 0.035,
          bottom: height * 0.10,
          child: Icon(
            Icons.hub_outlined,
            size: width * 0.15,
            color: ColorPalette.secondary.withValues(alpha: 0.25),
          ),
        ),
        Positioned(
          left: width * 0.095,
          bottom: height * 0.145,
          child: Icon(
            Icons.colorize_outlined,
            size: width * 0.052,
            color: ColorPalette.highlight.withValues(alpha: 0.45),
          ),
        ),
        Positioned(
          left: width * 0.385,
          bottom: height * 0.23,
          child: Icon(
            Icons.science_outlined,
            size: width * 0.04,
            color: ColorPalette.paleSage.withValues(alpha: 0.35),
          ),
        ),
        Positioned(
          right: width * 0.12,
          bottom: height * 0.205,
          child: Icon(
            Icons.science_outlined,
            size: width * 0.052,
            color: ColorPalette.accent.withValues(alpha: 0.42),
          ),
        ),
        Positioned(
          right: width * 0.16,
          bottom: height * 0.135,
          child: Transform.rotate(
            angle: 1.57,
            child: Icon(
              Icons.vaccines_outlined,
              size: width * 0.048,
              color: ColorPalette.secondary.withValues(alpha: 0.16),
            ),
          ),
        ),
      ],
    );
  }
}
