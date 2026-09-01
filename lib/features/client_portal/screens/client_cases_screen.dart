import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../cases/models/case_model.dart';
import '../../cases/services/case_service.dart';
import '../../cases/widgets/case_list_item.dart';
import '../screens/client_portal_main_layout.dart';

class ClientCasesScreen extends StatelessWidget {
  const ClientCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

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

            // Case List Items from CaseService
            Expanded(
              child: ValueListenableBuilder<List<CaseModel>>(
                valueListenable: CaseService.instance,
                builder: (context, cases, _) {
                  if (cases.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder_open_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            'No cases found',
                            style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.s24),
                    itemCount: cases.length,
                    itemBuilder: (context, index) {
                      final caseData = cases[index];
                      return CaseListItem(
                        caseItem: caseData,
                      );
                    },
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
