import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import 'super_admin_support_screen.dart';
import 'super_admin_firms_screen.dart';
import 'super_admin_dashboard_screen.dart';
import '../widgets/super_admin_sidebar.dart';
import '../widgets/super_admin_bottom_app_bar.dart';

class SuperAdminMainLayout extends StatefulWidget {
  const SuperAdminMainLayout({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static SuperAdminMainLayoutState? instance;

  @override
  State<SuperAdminMainLayout> createState() => SuperAdminMainLayoutState();
}

class SuperAdminMainLayoutState extends State<SuperAdminMainLayout> {
  // Sidebar indices:
  // 0=Platform Dashboard, 1=Firms, 2=Subscriptions & Billing,
  // 3=Support Tickets, 4=Global Users, 5=Notifications,
  // 6=Analytics, 7=Audit Logs, 8=Master Settings
  int _sidebarIndex = 0;

  // Bottom nav indices (mobile): 0=Firms, 1=Users, 2=Home, 3=Subscriptions, 4=Audit Log
  int _bottomIndex = 2;

  @override
  void initState() {
    super.initState();
    SuperAdminMainLayout.instance = this;
  }

  void switchTab(int bottomIndex) {
    setState(() {
      _bottomIndex = bottomIndex;
      switch (bottomIndex) {
        case 0: _sidebarIndex = 1; break; // Firms
        case 1: _sidebarIndex = 4; break; // Global Users
        case 2: _sidebarIndex = 0; break; // Dashboard
        case 3: _sidebarIndex = 2; break; // Subscriptions
        case 4: _sidebarIndex = 7; break; // Audit Logs
        default: _sidebarIndex = 0;
      }
    });
  }

  void switchSidebar(int sidebarIndex) {
    setState(() {
      _sidebarIndex = sidebarIndex;
      switch (sidebarIndex) {
        case 0: _bottomIndex = 2; break; // Dashboard -> Home
        case 1: _bottomIndex = 0; break; // Firms
        case 2: _bottomIndex = 3; break; // Subscriptions
        case 4: _bottomIndex = 1; break; // Global Users
        case 7: _bottomIndex = 4; break; // Audit Logs
        default: _bottomIndex = 2;
      }
    });
  }

  Widget get _currentScreen {
    switch (_sidebarIndex) {
      case 0: return const SuperAdminDashboardScreen();
      case 1: return const SuperAdminFirmsScreen();
      case 3: return const SuperAdminSupportScreen();
      case 2: return _buildPlaceholder('Subscriptions & Billing', Icons.credit_card_outlined);
      case 4: return _buildPlaceholder('Global Users', Icons.people_outline);
      case 5: return _buildPlaceholder('Notifications', Icons.notifications_none_outlined);
      case 6: return _buildPlaceholder('Analytics', Icons.bar_chart_outlined);
      case 7: return _buildPlaceholder('Audit Logs', Icons.description_outlined);
      case 8: return _buildPlaceholder('Master Settings', Icons.shield_outlined);
      default: return const SuperAdminDashboardScreen();
    }
  }

  Widget _buildPlaceholder(String title, IconData icon) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              color: AppColors.sidebarNavy,
              padding: const EdgeInsets.fromLTRB(12, 52, 16, 24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                    onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: AppTypography.header.copyWith(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 64, color: AppColors.textMuted.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coming Soon',
                      style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Scaffold(
        key: SuperAdminMainLayout.scaffoldKey,
        drawer: Drawer(
          width: 280,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SuperAdminSidebar(
            selectedIndex: _sidebarIndex,
            onItemSelected: (index) {
              switchSidebar(index);
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _currentScreen,
        bottomNavigationBar: SuperAdminBottomAppBar(
          selectedIndex: _bottomIndex,
          onItemSelected: switchTab,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SuperAdminSidebar(
            selectedIndex: _sidebarIndex,
            onItemSelected: switchSidebar,
          ),
          Expanded(child: _currentScreen),
        ],
      ),
    );
  }
}
