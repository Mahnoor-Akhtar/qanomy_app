import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class QanomySidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const QanomySidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.sidebarNavy,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s24, AppSpacing.s48, AppSpacing.s24, AppSpacing.s32),
            child: Row(
              children: [
                _buildStaticLogo(),
                const SizedBox(width: AppSpacing.s12),
                Text(
                  'QANOMY',
                  style: AppTypography.header.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _SidebarItem(
                  icon: Icons.work_outline,
                  label: 'Cases',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Hearings & Calendar',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                _SidebarItem(
                  icon: Icons.people_outline,
                  label: 'Clients',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),
                _SidebarItem(
                  icon: Icons.description_outlined,
                  label: 'Documents',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemSelected(4),
                ),
                _SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Invoices & Billing',
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemSelected(5),
                ),
                _SidebarItem(
                  icon: Icons.group_outlined, // Team
                  label: 'Team',
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemSelected(6),
                ),
                _SidebarItem(
                  icon: Icons.check_box_outlined,
                  label: 'Tasks',
                  isSelected: selectedIndex == 7,
                  onTap: () => onItemSelected(7),
                ),
                _SidebarItem(
                  icon: Icons.bar_chart_outlined,
                  label: 'Reports',
                  isSelected: selectedIndex == 8,
                  onTap: () => onItemSelected(8),
                ),
                _SidebarItem(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  isSelected: selectedIndex == 9,
                  onTap: () => onItemSelected(9),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: selectedIndex == 10,
                  onTap: () => onItemSelected(10),
                ),
                _SidebarItem(
                  icon: Icons.support,
                  label: 'Support',
                  isSelected: selectedIndex == 11,
                  onTap: () => onItemSelected(11),
                ),
              ],
            ),
          ),

          // Profile Area
          Container(
            padding: const EdgeInsets.all(AppSpacing.s24),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.iconInactive, width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.navBackground,
                  child: Icon(Icons.person, color: AppColors.primaryNavy),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haris Khan',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Admin',
                        style: AppTypography.bodyInter.copyWith(
                          color: AppColors.navHighlight.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.expand_more, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticLogo() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.princetonOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 16,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.sidebarNavy,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isSelected ? Colors.white : Colors.white.withOpacity(0.7);
    final Color iconColor = isSelected ? Colors.white : Colors.white.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s16, bottom: AppSpacing.s4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s32, AppSpacing.s12, AppSpacing.s16, AppSpacing.s12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.princetonOrange : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyInterMedium.copyWith(
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
