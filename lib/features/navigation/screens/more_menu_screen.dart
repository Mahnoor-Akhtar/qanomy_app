import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class MoreMenuScreen extends StatelessWidget {
  final ValueChanged<int> onItemSelected;

  const MoreMenuScreen({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryNavy,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          _buildMenuTile('Documents', Icons.description_outlined, () => onItemSelected(4)), // Maps to Sidebar index 4
          _buildMenuTile('Invoices & Billing', Icons.receipt_long_outlined, () => onItemSelected(5)),
          _buildMenuTile('Team', Icons.group_outlined, () => onItemSelected(6)),
          _buildMenuTile('Reports', Icons.bar_chart_outlined, () => onItemSelected(8)),
          _buildMenuTile('Settings', Icons.settings_outlined, () => onItemSelected(10)),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.iconInactive),
      title: Text(
        title,
        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.iconInactive),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
    );
  }
}
