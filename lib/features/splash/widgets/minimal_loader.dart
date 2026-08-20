import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class MinimalLoader extends StatelessWidget {
  const MinimalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // The design shows four horizontal dashes, one orange, rest navy/blue.
    // We'll animate them fading in at step 7.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDash(AppColors.princetonOrange),
        const SizedBox(width: 6),
        _buildDash(AppColors.textSecondary),
        const SizedBox(width: 6),
        _buildDash(AppColors.textSecondary),
        const SizedBox(width: 6),
        _buildDash(AppColors.textSecondary),
      ],
    ).animate(delay: 2400.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildDash(Color color) {
    return Container(
      width: 24,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
