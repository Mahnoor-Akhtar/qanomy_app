import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick actions',
              style: AppTypography.titleMedium,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all modules ',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.skyBlue),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: AppColors.skyBlue),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate width for 4 items per row
            final double itemWidth = (constraints.maxWidth - (3 * AppSpacing.s12)) / 4;
            
            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s16,
              children: [
                _buildActionItem('Add Case', Icons.work_outline, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth),
                _buildActionItem('Search', Icons.search, AppColors.skyBlue, AppColors.pastelBlue, itemWidth),
                _buildActionItem('Calendar', Icons.calendar_today_outlined, AppColors.skyBlue, AppColors.pastelBlue, itemWidth),
                _buildActionItem('Clients', Icons.people_outline, Colors.green, AppColors.pastelGreen, itemWidth),
                _buildActionItem('Advocates', Icons.person_outline, Colors.purple, AppColors.pastelPurple, itemWidth),
                _buildActionItem('Tasks', Icons.format_list_bulleted, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth),
                _buildActionItem('Reminders', Icons.notifications_none, Colors.amber, AppColors.pastelYellow, itemWidth),
                _buildActionItem('Appointments', Icons.event, Colors.red, AppColors.pastelRed, itemWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, IconData icon, Color iconColor, Color bgColor, double width) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s8),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
