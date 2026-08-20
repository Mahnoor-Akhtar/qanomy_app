import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qanomy_card.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return QanomyCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24, horizontal: AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricItem('TODAY', '0', Icons.inventory_2_outlined, AppColors.princetonOrange, AppColors.pastelOrange)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('TOMORROW', '0', Icons.calendar_today_outlined, AppColors.skyBlue, AppColors.pastelBlue)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('RUNNING', '0', Icons.play_arrow_outlined, Colors.green, AppColors.pastelGreen)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildMetricItem('AWAITED', '0', Icons.access_time, Colors.purple, AppColors.pastelPurple)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('DECIDED', '0', Icons.gavel, Colors.amber, AppColors.pastelYellow)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('ABANDONED', '0', Icons.cancel_outlined, Colors.red, AppColors.pastelRed)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color iconColor, Color bgColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.s12),
            Text(
              value,
              style: AppTypography.header.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
