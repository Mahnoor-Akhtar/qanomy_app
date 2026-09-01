import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/screens/login_screen.dart';

// Sidebar background
const _kSidebarBg = Color(0xFF0D1B2A);
const _kSidebarItemText = Color(0xFF8BA0B5);
const _kSidebarActiveText = Colors.white;

class SuperAdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SuperAdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      color: _kSidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Row(
                children: [
                  _buildLogo(),
                  const SizedBox(width: 12),
                  Text(
                    'Qanomy',
                    style: AppTypography.header.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: _kSidebarItemText, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _SidebarItem(icon: Icons.dashboard_rounded, label: 'Platform Dashboard', isSelected: selectedIndex == 0, onTap: () => onItemSelected(0)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.domain_outlined, label: 'Firms', isSelected: selectedIndex == 1, onTap: () => onItemSelected(1)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.credit_card_outlined, label: 'Subscriptions & Billing', isSelected: selectedIndex == 2, onTap: () => onItemSelected(2)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.support_agent_outlined, label: 'Support Tickets', isSelected: selectedIndex == 3, onTap: () => onItemSelected(3)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.people_outline, label: 'Global Users', isSelected: selectedIndex == 4, onTap: () => onItemSelected(4)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.notifications_none_outlined, label: 'Notifications', isSelected: selectedIndex == 5, onTap: () => onItemSelected(5)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.bar_chart_outlined, label: 'Analytics', isSelected: selectedIndex == 6, onTap: () => onItemSelected(6)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.description_outlined, label: 'Audit Logs', isSelected: selectedIndex == 7, onTap: () => onItemSelected(7)),
                const SizedBox(height: 4),
                _SidebarItem(icon: Icons.shield_outlined, label: 'Master Settings', isSelected: selectedIndex == 8, onTap: () => onItemSelected(8)),
              ],
            ),
          ),
          // Profile area
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF162231),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF223344),
                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Platform Admin',
                          style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                      Text('haris@gmail.com',
                          style: AppTypography.bodyInter.copyWith(color: _kSidebarItemText, fontSize: 11),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, a, b) => const LoginScreen(),
                        transitionsBuilder: (ctx, a, b, child) => FadeTransition(opacity: a, child: child),
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.logout_rounded, color: _kSidebarItemText, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 34,
      height: 34,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 17, height: 34,
              decoration: const BoxDecoration(
                color: AppColors.princetonOrange,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(17), bottomLeft: Radius.circular(17)),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 17, height: 34,
              decoration: const BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.only(topRight: Radius.circular(17), bottomRight: Radius.circular(17)),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 14, height: 14,
              decoration: const BoxDecoration(color: _kSidebarBg, shape: BoxShape.circle),
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

  const _SidebarItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.princetonOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? _kSidebarActiveText : _kSidebarItemText),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyInterMedium.copyWith(
                  color: isSelected ? _kSidebarActiveText : _kSidebarItemText,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
