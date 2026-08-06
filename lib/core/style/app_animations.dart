import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

abstract final class AppAnimations {
  const AppAnimations._();

  static Widget logoEntrance({required Widget child}) {
    return child
        .animate(delay: 100.ms)
        .fadeIn(duration: 700.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.25,
          end: 0,
          duration: 750.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.88, 0.88),
          end: const Offset(1, 1),
          duration: 850.ms,
          curve: Curves.easeOutBack,
        );
  }

  static Widget logoFloating({required Widget child}) {
    return child
        .animate(
          onPlay: (controller) {
            controller.repeat(reverse: true);
          },
        )
        .slideY(
          begin: 0,
          end: -0.018,
          duration: 1600.ms,
          curve: Curves.easeInOut,
        );
  }

  static Widget shadowEntrance({required Widget child}) {
    return child
        .animate(delay: 450.ms)
        .fadeIn(duration: 650.ms, curve: Curves.easeOut)
        .scaleX(
          begin: 0.65,
          end: 1,
          duration: 750.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget shadowPulse({required Widget child}) {
    return child
        .animate(
          onPlay: (controller) {
            controller.repeat(reverse: true);
          },
        )
        .scaleX(
          begin: 0.92,
          end: 1.04,
          duration: 1600.ms,
          curve: Curves.easeInOut,
        )
        .fade(begin: 0.70, end: 1, duration: 1600.ms, curve: Curves.easeInOut);
  }

  static Widget primaryTitle({required Widget child}) {
    return child
        .animate(delay: 550.ms)
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.45,
          end: 0,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget secondaryTitle({required Widget child}) {
    return child
        .animate(delay: 800.ms)
        .fadeIn(duration: 650.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.35,
          end: 0,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget loadingBar({required Widget child}) {
    return child
        .animate(delay: 1000.ms)
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.50,
          end: 0,
          duration: 550.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget loadingText({required Widget child}) {
    return child
        .animate(delay: 1150.ms)
        .fadeIn(duration: 550.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.35,
          end: 0,
          duration: 550.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget screenSection({required Widget child, int delay = 0}) {
    return child
        .animate(delay: delay.ms)
        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget bottomNavItem({
    required Widget child,
    required bool isSelected,
  }) {
    return child
        .animate(target: isSelected ? 1 : 0)
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          duration: 260.ms,
          curve: Curves.easeOutBack,
        )
        .slideY(
          begin: 0.06,
          end: 0,
          duration: 240.ms,
          curve: Curves.easeOutCubic,
        );
  }

  static Widget bottomNavBarEntrance({required Widget child}) {
    return child
        .animate(delay: 600.ms)
        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
        .moveY(begin: 120, end: 0, duration: 900.ms, curve: Curves.easeOutBack)
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 900.ms,
          curve: Curves.easeOutBack,
        );
  }
}
