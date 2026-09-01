import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../widgets/client_sidebar.dart';
import '../widgets/client_bottom_app_bar.dart';
import 'client_dashboard_screen.dart';
import 'client_cases_screen.dart';
import 'client_invoices_screen.dart';
import 'client_documents_screen.dart';
import 'client_support_screen.dart';
import 'client_profile_screen.dart';
import '../../cases/screens/hearings_calendar_screen.dart';

class ClientPortalMainLayout extends StatefulWidget {
  const ClientPortalMainLayout({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static ClientPortalMainLayoutState? instance;

  @override
  State<ClientPortalMainLayout> createState() => ClientPortalMainLayoutState();
}

class ClientPortalMainLayoutState extends State<ClientPortalMainLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ClientPortalMainLayout.instance = this;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _mapBottomNavToMainIndex(int bottomIndex) {
    switch (bottomIndex) {
      case 0: return 1; // My Cases
      case 1: return 2; // Hearings
      case 2: return 0; // Dashboard (Home)
      case 3: return 3; // Documents
      case 4: return 5; // Profile
      default: return 0;
    }
  }

  int _getBottomNavIndex(int mainIndex) {
    switch (mainIndex) {
      case 0: return 2; // Dashboard -> Home center button
      case 1: return 0; // My Cases
      case 2: return 1; // Hearings
      case 3: return 3; // Documents
      case 5: return 4; // Profile
      default: return -1;
    }
  }

  void _onBottomNavSelected(int bottomIndex) {
    setState(() {
      _currentIndex = _mapBottomNavToMainIndex(bottomIndex);
    });
  }

  final List<Widget> _screens = const [
    ClientDashboardScreen(),      // 0: Dashboard
    ClientCasesScreen(),          // 1: My Cases
    HearingsCalendarScreen(),     // 2: Hearings
    ClientDocumentsScreen(),      // 3: Documents
    ClientInvoicesScreen(),       // 4: Invoices & Payments
    ClientProfileScreen(),        // 5: My Profile
    ClientSupportScreen(),        // 6: Support
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Scaffold(
        key: ClientPortalMainLayout.scaffoldKey,
        drawer: Drawer(
          width: 280,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClientSidebar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: ClientBottomAppBar(
          selectedIndex: _getBottomNavIndex(_currentIndex),
          onItemSelected: _onBottomNavSelected,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          ClientSidebar(
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
