import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/case_list_item.dart';
import 'add_case_screen.dart';
import 'case_history_screen.dart';
import '../../navigation/main_layout.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: AppBar(
          backgroundColor: AppColors.sidebarNavy,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          toolbarHeight: 90,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              MainLayout.scaffoldKey.currentState?.openDrawer();
            },
          ),
          titleSpacing: 0,
          title: Text(
            'Cases',
            style: AppTypography.header.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CaseHistoryScreen()),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                'History',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s24),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCaseScreen()),
            );
          },
          backgroundColor: const Color(0xFFFF8A00),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        body: Column(
          children: [
            const SizedBox(height: AppSpacing.s16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppSpacing.s16),
                          Icon(
                            Icons.search,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by case title...',
                                hintStyle: AppTypography.bodyInter.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: AppTypography.bodyInter.copyWith(
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // Tabs
            TabBar(
              indicatorColor: AppColors.princetonOrange,
              indicatorWeight: 3,
              labelColor: AppColors.primaryNavy,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: AppTypography.labelSmall,
              dividerColor: AppColors.border.withOpacity(0.3),
              tabs: const [
                Tab(text: 'All Cases'),
                Tab(text: 'My Cases'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  _buildCasesList(),
                  _buildCasesList(), // Placeholder for My Cases
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCasesList() {
    // Hardcoded list from mockup
    final List<Map<String, dynamic>> cases = [
      {'title': 'Ali vs Ahmed', 'assignee': 'Haris Khan', 'isFavorite': false},
      {'title': 'Ejaz vs Adnan', 'assignee': 'Haris Khan', 'isFavorite': true},
      {'title': 'Alia vs Adnan', 'assignee': 'Fatima', 'isFavorite': true},
      {'title': 'Ali vs Babar', 'assignee': 'Fatima', 'isFavorite': false},
      {
        'title': 'Momina vs Muheeb',
        'assignee': 'Unassigned',
        'isFavorite': true,
      },
      {'title': 'Ali vs Naveed', 'assignee': 'Unassigned', 'isFavorite': false},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s24),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final caseData = cases[index];
        return CaseListItem(
          title: caseData['title'] as String,
          assignee: caseData['assignee'] as String,
          isFavorite: caseData['isFavorite'] as bool,
        );
      },
    );
  }
}
