import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qanomy_card.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'This week',
              style: AppTypography.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.skyBlue),
              label: Text(
                'View calendar',
                style: AppTypography.labelMedium.copyWith(color: AppColors.skyBlue),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDayCard('MON', '17', false),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('TUE', '18', false),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('WED', '19', false),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('THU', '20', true),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('FRI', '21', false),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('SAT', '22', false),
              const SizedBox(width: AppSpacing.s8),
              _buildDayCard('SUN', '23', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(String day, String date, bool isSelected) {
    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryNavy : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? Colors.white70 : AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            date,
            style: AppTypography.bodyInterSemiBold.copyWith(
              color: isSelected ? Colors.white : AppColors.primaryNavy,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Container(
            width: 8,
            height: 2,
            color: isSelected ? AppColors.skyBlue : AppColors.border,
          ),
        ],
      ),
    );
  }
}
