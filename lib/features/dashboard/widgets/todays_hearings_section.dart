import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qanomy_card.dart';

class TodaysHearingsSection extends StatelessWidget {
  const TodaysHearingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: AppTypography.titleMedium,
                children: [
                  const TextSpan(text: 'Today\'s hearings '),
                  TextSpan(
                    text: '• 0',
                    style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View all',
                style: AppTypography.labelMedium.copyWith(color: AppColors.skyBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        QanomyCard(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColors.pastelBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.gavel, color: AppColors.primaryNavy, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0 cases today',
                          style: AppTypography.bodyInterSemiBold.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          'Tap to view your full docket',
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
                child: Divider(color: AppColors.border, height: 1),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18, color: AppColors.skyBlue),
                label: Text(
                  'Add case',
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.skyBlue),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
