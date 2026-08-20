import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qanomy_card.dart';

class DailyBoardCard extends StatelessWidget {
  const DailyBoardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QanomyCard(
      onTap: () {},
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.download_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generate Daily Board',
                  style: AppTypography.bodyInterSemiBold.copyWith(fontSize: 15),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Get your today\'s overview',
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
