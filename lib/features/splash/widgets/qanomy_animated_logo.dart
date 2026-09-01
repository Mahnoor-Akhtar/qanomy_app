import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class QanomyAnimatedLogo extends StatelessWidget {
  final double? customSize;

  const QanomyAnimatedLogo({super.key, this.customSize});

  @override
  Widget build(BuildContext context) {
    final double size = customSize ?? (MediaQuery.sizeOf(context).width * 0.35).clamp(100.0, 180.0);
    final double halfSize = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left Half (Orange)
          Positioned(
            left: 0,
            child: Container(
              width: halfSize,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.princetonOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size),
                  bottomLeft: Radius.circular(size),
                ),
              ),
            ).animate().slideX(
                  begin: -1.0,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutCubic,
                ).fadeIn(duration: 600.ms),
          ),

          // Right Half (Light Blue)
          Positioned(
            right: 0,
            child: Container(
              width: halfSize,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size),
                  bottomRight: Radius.circular(size),
                ),
              ),
            ).animate().slideX(
                  begin: 1.0,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutCubic,
                ).fadeIn(duration: 600.ms),
          ),

          // Center Hole (Navy)
          Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
              shape: BoxShape.circle,
            ),
          ).animate(delay: 400.ms).scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}
