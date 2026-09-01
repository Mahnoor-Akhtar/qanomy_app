import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/screens/login_screen.dart';

const _kSidebarBg = Color(0xFF071E33);
const _kSidebarItemText = Color(0xFF90A4AE);
const _kSidebarActiveText = Colors.white;

class ClientSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const ClientSidebar({
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Row(
                children: [
                  _buildLogo(),
                  const SizedBox(width: 14),
                  Text(
                    'Qanomy',
                    style: AppTypography.header.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  // Notification bell with badge 28
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You have 28 unread notifications.')),
                          );
                        },
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 26),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Positioned(
                        right: -4,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _kSidebarBg, width: 1.5),
                          ),
                          child: const Text(
                            '28',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _SidebarItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.business_center_outlined,
                  label: 'My Cases',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Hearings',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.article_outlined,
                  label: 'Documents',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.request_quote_outlined,
                  label: 'Invoices & Payments',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemSelected(4),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.person_outline_rounded,
                  label: 'My Profile',
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemSelected(5),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.support_outlined,
                  label: 'Support',
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemSelected(6),
                ),
              ],
            ),
          ),
          // Profile area for Client Beerus
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D2840),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.princetonOrange.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.princetonOrange, AppColors.amber],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beerus (Client)',
                        style: AppTypography.bodyInterMedium.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'beerus@gmail.com',
                        style: AppTypography.bodyInter.copyWith(
                          color: _kSidebarItemText,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
      width: 36,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 18, height: 36,
              decoration: const BoxDecoration(
                color: AppColors.princetonOrange,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 18, height: 36,
              decoration: const BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.only(topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
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

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.princetonOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isSelected ? _kSidebarActiveText : _kSidebarItemText),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyInterMedium.copyWith(
                  color: isSelected ? _kSidebarActiveText : _kSidebarItemText,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
