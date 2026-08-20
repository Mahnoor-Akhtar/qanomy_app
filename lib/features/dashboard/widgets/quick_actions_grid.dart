import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../navigation/main_layout.dart';

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
              onPressed: () {
                // Settings tab has "More" options or open settings directly
                MainLayout.instance?.switchTab(10);
              },
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
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: AppColors.primaryNavy),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = (constraints.maxWidth - (3 * AppSpacing.s12)) / 4;
            
            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s16,
              children: [
                _buildActionItem('Dashboard', Icons.dashboard_outlined, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(0);
                }),
                _buildActionItem('Cases', Icons.work_outline, AppColors.skyBlue, AppColors.pastelBlue, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(1);
                }),
                _buildActionItem('Hearings', Icons.calendar_today_outlined, Colors.green, AppColors.pastelGreen, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(2);
                }),
                _buildActionItem('Clients', Icons.people_outline, Colors.purple, AppColors.pastelPurple, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(3);
                }),
                _buildActionItem('Documents', Icons.description_outlined, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(4);
                }),
                _buildActionItem('Invoices', Icons.receipt_long_outlined, Colors.amber, AppColors.pastelYellow, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(5);
                }),
                _buildActionItem('Team', Icons.group_outlined, Colors.red, AppColors.pastelRed, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(6);
                }),
                _buildActionItem('Tasks', Icons.check_box_outlined, AppColors.skyBlue, AppColors.pastelBlue, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(7);
                }),
                _buildActionItem('Reports', Icons.bar_chart_outlined, Colors.green, AppColors.pastelGreen, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(8);
                }),
                _buildActionItem('Notifications', Icons.notifications_none, Colors.purple, AppColors.pastelPurple, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(9);
                }),
                _buildActionItem('Settings', Icons.settings_outlined, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth, onTap: () {
                  MainLayout.instance?.switchTab(10);
                }),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, IconData icon, Color iconColor, Color bgColor, double width, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
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
      ),
    );
  }
}
