import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import '../screens/client_portal_main_layout.dart';
import '../../dashboard/widgets/daily_board_card.dart';
import '../../dashboard/widgets/weekly_calendar.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navBackground,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    // Navy background for top half (Lawyer Portal style)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 350,
                      child: Container(color: AppColors.sidebarNavy),
                    ),

                    Column(
                      children: [
                        // Dashboard Header
                        const _ClientDashboardHeader(),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Main Content Container overlapping the header
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.s16,
                                      vertical: AppSpacing.s24,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Space for positioned metrics grid overlap
                                        const SizedBox(height: 100),

                                        // 1. Generate Daily Board Card (from user screenshot 4)
                                        const DailyBoardCard(),
                                        const SizedBox(height: AppSpacing.s32),

                                        // 2. Weekly Calendar ("This week")
                                        const WeeklyCalendar(),
                                        const SizedBox(height: AppSpacing.s32),

                                        // 3. Today's Hearings Section ("Today's hearings • 0")
                                        const _ClientTodaysHearingsSection(),
                                        const SizedBox(height: AppSpacing.s32),

                                        // 4. Quick Actions Grid (Exact Lawyer Portal circular-icon style & colors)
                                        const _ClientQuickActionsGrid(),
                                        const SizedBox(height: AppSpacing.s64),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Overlapping Metrics Grid (Client portal statistics)
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: ResponsiveConstraints.maxContentWidth),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                                  child: _ClientMetricsGrid(),
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

// -----------------------------------------------------------------------------
// Header matching Lawyer Dashboard Header
// -----------------------------------------------------------------------------
class _ClientDashboardHeader extends StatelessWidget {
  const _ClientDashboardHeader();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: AppColors.sidebarNavy,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.s24, AppSpacing.s16, AppSpacing.s24, AppSpacing.s64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side: Menu + Greeting + Subtitle
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMobile)
                        GestureDetector(
                          onTap: () => ClientPortalMainLayout.scaffoldKey.currentState?.openDrawer(),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 16.0, top: 4.0),
                            child: Icon(Icons.menu, color: Colors.white, size: 28),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning, Lord Beerus',
                              style: AppTypography.header.copyWith(
                                color: Colors.white,
                                fontSize: isMobile ? 22 : 28,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: AppTypography.bodyInter.copyWith(color: Colors.white70, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: '0 hearings',
                                    style: AppTypography.bodyInterMedium.copyWith(color: AppColors.princetonOrange, fontSize: 13),
                                  ),
                                  const TextSpan(text: ' listed today'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Right Side: Action Icons + Avatar
                Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 24),
                    const SizedBox(width: AppSpacing.s12),
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.princetonOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Container(
                      width: 40,
                      height: 40,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Overlapping Metrics Grid Card
// -----------------------------------------------------------------------------
class _ClientMetricsGrid extends StatelessWidget {
  const _ClientMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return QanomyCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24, horizontal: AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricItem('TOTAL CASES', '3', Icons.business_center_outlined, Colors.green, AppColors.pastelGreen)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('UPCOMING HEARINGS', '0', Icons.calendar_today_outlined, AppColors.skyBlue, AppColors.pastelBlue)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('PENDING INVOICES', '1', Icons.request_quote_outlined, AppColors.princetonOrange, AppColors.pastelOrange)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildMetricItem('PAID INVOICES', '0', Icons.check_circle_outline, Colors.purple, AppColors.pastelPurple)),
              _buildDivider(),
              Expanded(child: _buildMetricItem('SHARED DOCS', '8', Icons.article_outlined, Colors.deepPurple, AppColors.pastelPurple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color iconColor, Color bgColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(
              value,
              style: AppTypography.header.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Today's Hearings Section ("Today's hearings • 0")
// -----------------------------------------------------------------------------
class _ClientTodaysHearingsSection extends StatelessWidget {
  const _ClientTodaysHearingsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: AppTypography.titleMedium,
                children: [
                  const TextSpan(text: 'Today\'s hearings '),
                  TextSpan(
                    text: '• 0',
                    style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ClientPortalMainLayout.instance?.switchTab(2); // Go to Hearings
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View all',
                style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        QanomyCard(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  ClientPortalMainLayout.instance?.switchTab(2); // Go to Hearings
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      decoration: BoxDecoration(
                        color: AppColors.pastelBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.gavel, color: AppColors.primaryNavy, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '0 cases today',
                            style: AppTypography.bodyInterSemiBold.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            'Tap to view your full docket',
                            style: AppTypography.bodyInter.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Quick Actions Grid (Identical to Lawyer Portal style, circular icons & colors)
// -----------------------------------------------------------------------------
class _ClientQuickActionsGrid extends StatelessWidget {
  const _ClientQuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick actions',
              style: AppTypography.titleMedium,
            ),
            TextButton(
              onPressed: () {
                ClientPortalMainLayout.instance?.switchTab(5); // Profile / Settings
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View all modules ',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: AppColors.primaryNavy),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = (constraints.maxWidth - (3 * AppSpacing.s12)) / 4;

            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s16,
              children: [
                _buildActionItem(
                  'Dashboard',
                  Icons.dashboard_outlined,
                  AppColors.princetonOrange,
                  AppColors.pastelOrange,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(0),
                ),
                _buildActionItem(
                  'My Cases',
                  Icons.work_outline,
                  AppColors.skyBlue,
                  AppColors.pastelBlue,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(1),
                ),
                _buildActionItem(
                  'Hearings',
                  Icons.calendar_today_outlined,
                  Colors.green,
                  AppColors.pastelGreen,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(2),
                ),
                _buildActionItem(
                  'Documents',
                  Icons.description_outlined,
                  AppColors.princetonOrange,
                  AppColors.pastelOrange,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(3),
                ),
                _buildActionItem(
                  'Invoices',
                  Icons.receipt_long_outlined,
                  Colors.amber,
                  AppColors.pastelYellow,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(4),
                ),
                _buildActionItem(
                  'My Profile',
                  Icons.person_outline,
                  Colors.redAccent,
                  AppColors.pastelRed,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(5),
                ),
                _buildActionItem(
                  'Support',
                  Icons.headset_mic_outlined,
                  Colors.purple,
                  AppColors.pastelPurple,
                  itemWidth,
                  onTap: () => ClientPortalMainLayout.instance?.switchTab(6),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionItem(String label, IconData icon, Color iconColor, Color bgColor, double width, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primaryNavy,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
