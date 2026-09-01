import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../cases/widgets/case_list_item.dart';
import '../screens/client_portal_main_layout.dart';

class ClientCasesScreen extends StatelessWidget {
  const ClientCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    final List<Map<String, dynamic>> cases = [
      {'title': 'Ali vs Ahmed', 'assignee': 'Haris Khan', 'isFavorite': false},
      {'title': 'Ejaz vs Adnan', 'assignee': 'Haris Khan', 'isFavorite': true},
      {'title': 'Alia vs Adnan', 'assignee': 'Fatima', 'isFavorite': true},
      {'title': 'Ali vs Babar', 'assignee': 'Fatima', 'isFavorite': false},
      {'title': 'Momina vs Muheeb', 'assignee': 'Unassigned', 'isFavorite': true},
      {'title': 'Ali vs Naveed', 'assignee': 'Unassigned', 'isFavorite': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header Bar
            Container(
              color: AppColors.sidebarNavy,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 16,
                16,
                20,
              ),
              child: Row(
                children: [
                  if (isMobile)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                      onPressed: () => ClientPortalMainLayout.scaffoldKey.currentState?.openDrawer(),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    'My Cases',
                    style: AppTypography.header.copyWith(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),

            // Only the Case List Items (Exact screenshot requested)
            Expanded(
              child: ListView.builder(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
