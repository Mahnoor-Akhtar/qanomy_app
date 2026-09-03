import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../cases/services/case_service.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/daily_board_card.dart';
import '../widgets/weekly_calendar.dart';
import '../widgets/todays_hearings_section.dart';
import '../widgets/quick_actions_grid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await CaseService.instance.fetchCasesFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navBackground,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 350,
                        child: Container(color: AppColors.sidebarNavy),
                      ),
                      Column(
                        children: [
                          const DashboardHeader(),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 60),
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
                                          const SizedBox(height: 100),
                                          const DailyBoardCard(),
                                          const SizedBox(height: AppSpacing.s32),
                                          const WeeklyCalendar(),
                                          const SizedBox(height: AppSpacing.s32),
                                          const TodaysHearingsSection(),
                                          const SizedBox(height: AppSpacing.s32),
                                          const QuickActionsGrid(),
                                          const SizedBox(height: AppSpacing.s64),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
