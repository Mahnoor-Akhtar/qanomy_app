import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../dashboard/screens/dashboard_screen.dart';
import 'screens/more_menu_screen.dart';
import 'widgets/custom_bottom_app_bar.dart';
import 'widgets/qanomy_sidebar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const DashboardScreen(), // 0
    const Scaffold(body: Center(child: Text('Cases'))), // 1
    const Scaffold(body: Center(child: Text('Hearings & Calendar'))), // 2
    const Scaffold(body: Center(child: Text('Clients'))), // 3
    const Scaffold(body: Center(child: Text('Documents'))), // 4
    const Scaffold(body: Center(child: Text('Invoices & Billing'))), // 5
    const Scaffold(body: Center(child: Text('Team'))), // 6
    const Scaffold(body: Center(child: Text('Tasks'))), // 7
    const Scaffold(body: Center(child: Text('Reports'))), // 8
    const Scaffold(body: Center(child: Text('Notifications'))), // 9
    const Scaffold(body: Center(child: Text('Settings'))), // 10
  ];

  // Helper to map bottom nav index to main screen index
  int _mapBottomNavToMainIndex(int bottomIndex) {
    switch (bottomIndex) {
      case 0: return 0; // Dashboard
      case 1: return 1; // Cases
      case 2: return 2; // Calendar
      case 3: return 7; // Tasks
      case 4: return 9; // Notifications
      default: return 0;
    }
  }

  // Helper to figure out which bottom nav tab should be highlighted
  int _getBottomNavIndex(int mainIndex) {
    switch (mainIndex) {
      case 0: return 0;
      case 1: return 1;
      case 2: return 2;
      case 7: return 3;
      case 9: return 4;
      default: return -1; // No bottom nav item highlighted if deeply nested in drawer
    }
  }

  void _onBottomNavSelected(int bottomIndex) {
    if (bottomIndex == 5) {
      // Open Drawer
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() => _currentIndex = _mapBottomNavToMainIndex(bottomIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show Add action sheet or dialog
            showModalBottomSheet(
              context: context,
              builder: (context) => const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Add Menu Placeholder'),
                ),
              ),
            );
          },
          backgroundColor: AppColors.navOrange,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
