import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/daily_board_card.dart';
import '../widgets/weekly_calendar.dart';
import '../widgets/todays_hearings_section.dart';
import '../widgets/quick_actions_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Entire page is scrollable so header doesn't get hidden under content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    // Navy background for the top half
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 350,
                      child: Container(color: AppColors.sidebarNavy),
                    ),
                    
                    // Main Content Column
                    Column(
                      children: [
                        const DashboardHeader(),
                        
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Main Content Container overlapping the header
                            Container(
                              margin: const EdgeInsets.only(top: 60), // Push down so MetricsGrid can sit on top edge
                              decoration: const BoxDecoration(
                                color: AppColors.navBackground,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: ResponsiveConstraints.maxContentWidth),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 100), // Space for the positioned MetricsGrid
                                        
                                        const DailyBoardCard(),
                                        const SizedBox(height: AppSpacing.s32),
                                        
                                        const WeeklyCalendar(),
                                        const SizedBox(height: AppSpacing.s32),
                                        
                                        const TodaysHearingsSection(),
                                        const SizedBox(height: AppSpacing.s32),
                                        
                                        const QuickActionsGrid(),
                                        const SizedBox(height: AppSpacing.s64), // Extra bottom padding
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Overlapping Metrics Grid
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: ResponsiveConstraints.maxContentWidth),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                                  child: MetricsGrid(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
