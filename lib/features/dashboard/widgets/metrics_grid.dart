import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/qanomy_card.dart';
import '../../cases/models/case_model.dart';
import '../../cases/services/case_service.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return ValueListenableBuilder<List<CaseModel>>(
      valueListenable: CaseService.instance,
      builder: (context, cases, _) {
        final int todayCount = cases.where((c) => _isSameDay(c.hearingDate, today)).length;
        final int tomorrowCount = cases.where((c) => _isSameDay(c.hearingDate, tomorrow)).length;
        final int runningCount = cases.where((c) => c.status.toLowerCase() == 'running' || c.status.toLowerCase() == 'open').length;
        final int awaitedCount = cases.where((c) => c.status.toLowerCase() == 'awaited').length;
        final int decidedCount = cases.where((c) => c.status.toLowerCase() == 'decided' || c.status.toLowerCase() == 'disposed').length;
        final int abandonedCount = cases.where((c) => c.status.toLowerCase() == 'abandoned' || c.status.toLowerCase() == 'dismissed').length;

        return QanomyCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24, horizontal: AppSpacing.s16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildMetricItem('TODAY', '$todayCount', Icons.inventory_2_outlined, AppColors.princetonOrange, AppColors.pastelOrange)),
                  _buildDivider(),
                  Expanded(child: _buildMetricItem('TOMORROW', '$tomorrowCount', Icons.calendar_today_outlined, AppColors.skyBlue, AppColors.pastelBlue)),
                  _buildDivider(),
                  Expanded(child: _buildMetricItem('RUNNING', '$runningCount', Icons.play_arrow_outlined, Colors.green, AppColors.pastelGreen)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
                child: Divider(color: AppColors.border, height: 1),
              ),
              Row(
                children: [
                  Expanded(child: _buildMetricItem('AWAITED', '$awaitedCount', Icons.access_time, Colors.purple, AppColors.pastelPurple)),
                  _buildDivider(),
                  Expanded(child: _buildMetricItem('DECIDED', '$decidedCount', Icons.gavel, Colors.amber, AppColors.pastelYellow)),
                  _buildDivider(),
                  Expanded(child: _buildMetricItem('ABANDONED', '$abandonedCount', Icons.cancel_outlined, Colors.red, AppColors.pastelRed)),
                ],
              ),
            ],
          ),
        );
      },
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
      mainAxisSize: minAxis,
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

  MainAxisSize get minAxis => MainAxisSize.min;
}
