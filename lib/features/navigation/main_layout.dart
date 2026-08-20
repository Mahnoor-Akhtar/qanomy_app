import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../cases/screens/cases_screen.dart';
import '../clients/screens/clients_screen.dart';
import '../team/screens/team_members_screen.dart';
import '../invoices/screens/invoices_screen.dart';
import '../notifications/screens/notifications_screen.dart';
import '../activity/screens/activity_screen.dart';
import 'screens/more_menu_screen.dart';
import 'widgets/custom_bottom_app_bar.dart';
import 'widgets/qanomy_sidebar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static MainLayoutState? instance;

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    MainLayout.instance = this;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _screens => [
    const DashboardScreen(), // 0
    const CasesScreen(), // 1
    _buildPlaceholderScreen('Hearings & Calendar'), // 2
    const ClientsScreen(), // 3
    _buildPlaceholderScreen('Documents'), // 4
    const InvoicesScreen(), // 5
    const TeamMembersScreen(), // 6
    _buildPlaceholderScreen('Tasks'), // 7
    _buildPlaceholderScreen('Reports'), // 8
    const NotificationsScreen(), // 9
    _buildPlaceholderScreen('Settings'), // 10
    _buildPlaceholderScreen('Support'), // 11
    const ActivityScreen(), // 12
  ];

  Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            MainLayout.scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          title,
          style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Center(
        child: Text(
          '$title Screen\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: AppTypography.titleLarge.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
  // Helper to map bottom nav index to main screen index
  int _mapBottomNavToMainIndex(int bottomIndex) {
    switch (bottomIndex) {
      case 0: return 3; // Clients
      case 1: return 1; // Cases
      case 2: return 0; // Dashboard (Home)
      case 3: return 2; // Hearings & Calendar
      case 4: return 6; // Teams
      default: return 0;
    }
  }

  // Helper to figure out which bottom nav tab should be highlighted
  int _getBottomNavIndex(int mainIndex) {
    switch (mainIndex) {
      case 0: return 2; // Home
      case 1: return 1; // Cases
      case 3: return 0; // Clients
      case 2: return 3; // Hearings
      case 6: return 4; // Teams
      default: return -1; // No bottom nav item highlighted if deeply nested in drawer
    }
  }

  void _onBottomNavSelected(int bottomIndex) {
    setState(() => _currentIndex = _mapBottomNavToMainIndex(bottomIndex));
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Scaffold(
        key: MainLayout.scaffoldKey,
        drawer: Drawer(
          width: 280,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: QanomySidebar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              Navigator.of(context).pop(); // Close drawer
            },
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomAppBar(
          selectedIndex: _getBottomNavIndex(_currentIndex),
          onItemSelected: _onBottomNavSelected,
        ),
      );
    }

    // Tablet/Desktop Layout using Sidebar
    return Scaffold(
      body: Row(
        children: [
          QanomySidebar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
