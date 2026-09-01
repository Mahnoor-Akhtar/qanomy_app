import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return ColoredBox(
      color: AppColors.navBackground,
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Entire page is scrollable so header banner stays in sync
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    // Navy background for top header area
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
                        const _SuperAdminDashboardHeader(),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Main Content Container overlapping the navy header
                            Container(
                              margin: const EdgeInsets.only(top: 60), // Push down for overlapping metrics card
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
                                        SizedBox(height: isMobile ? 180 : 110), // Space for positioned MetricsGrid
                                        
                                        const _SuperAdminDailyControlCard(),
                                        const SizedBox(height: AppSpacing.s32),

                                        if (isMobile)
                                          Column(
                                            children: [
                                              const _SuperAdminRegistrationChart(),
                                              const SizedBox(height: AppSpacing.s24),
                                              const _SuperAdminRecentChambersCard(),
                                            ],
                                          )
                                        else
                                          const Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(flex: 7, child: _SuperAdminRegistrationChart()),
                                              SizedBox(width: AppSpacing.s24),
                                              Expanded(flex: 5, child: _SuperAdminRecentChambersCard()),
                                            ],
                                          ),
                                        
                                        const SizedBox(height: AppSpacing.s32),
                                        const _SuperAdminQuickActionsGrid(),
                                        const SizedBox(height: AppSpacing.s64),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Overlapping Metrics Grid (Lawyer Dashboard Style)
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: ResponsiveConstraints.maxContentWidth),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                                  child: _SuperAdminMetricsGrid(),
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

class _SuperAdminDashboardHeader extends StatelessWidget {
  const _SuperAdminDashboardHeader();

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
            padding: EdgeInsets.fromLTRB(
              isMobile ? AppSpacing.s16 : AppSpacing.s24,
              AppSpacing.s16,
              isMobile ? AppSpacing.s16 : AppSpacing.s24,
              AppSpacing.s64,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(Icons.menu, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 18),
                                  Positioned(
                                    right: -1,
                                    top: -1,
                                    child: Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: AppColors.princetonOrange,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.sidebarNavy, width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFB8500), Color(0xFFFFB703)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'H',
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  'Welcome back, Haris',
                  style: AppTypography.header.copyWith(
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuperAdminMetricsGrid extends StatelessWidget {
  const _SuperAdminMetricsGrid();

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return QanomyCard(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildMetricItem('TOTAL FIRMS', '7', Icons.domain_outlined, AppColors.skyBlue, AppColors.pastelBlue)),
                _buildVerticalDivider(),
                Expanded(child: _buildMetricItem('ACTIVE SUBS', '18', Icons.credit_card_outlined, Colors.green, AppColors.pastelGreen)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
              child: Divider(color: AppColors.border, height: 1),
            ),
            Row(
              children: [
                Expanded(child: _buildMetricItem('REVENUE', '4.2L', Icons.payments_outlined, AppColors.princetonOrange, AppColors.pastelOrange)),
                _buildVerticalDivider(),
                Expanded(child: _buildMetricItem('NEW SIGNUPS', '6', Icons.person_add_alt_1_outlined, Colors.purple, AppColors.pastelPurple)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
              child: Divider(color: AppColors.border, height: 1),
            ),
            Row(
              children: [
                Expanded(child: _buildMetricItem('EXPIRING', '3', Icons.hourglass_empty_outlined, Colors.amber, AppColors.pastelYellow)),
                _buildVerticalDivider(),
                Expanded(child: _buildMetricItem('TICKETS', '3', Icons.headset_mic_outlined, Colors.red, AppColors.pastelRed)),
              ],
            ),
          ],
        ),
      );
    }

    return QanomyCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24, horizontal: AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricItem('TOTAL FIRMS', '7', Icons.domain_outlined, AppColors.skyBlue, AppColors.pastelBlue)),
              _buildVerticalDivider(),
              Expanded(child: _buildMetricItem('ACTIVE SUBSCRIPTIONS', '18', Icons.credit_card_outlined, Colors.green, AppColors.pastelGreen)),
              _buildVerticalDivider(),
              Expanded(child: _buildMetricItem('MONTHLY REVENUE', 'PKR 4.2L', Icons.payments_outlined, AppColors.princetonOrange, AppColors.pastelOrange)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Divider(color: AppColors.border, height: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildMetricItem('NEW SIGNUPS', '6', Icons.person_add_alt_1_outlined, Colors.purple, AppColors.pastelPurple)),
              _buildVerticalDivider(),
              Expanded(child: _buildMetricItem('EXPIRING TRIALS', '3', Icons.hourglass_empty_outlined, Colors.amber, AppColors.pastelYellow)),
              _buildVerticalDivider(),
              Expanded(child: _buildMetricItem('TICKETS OPEN', '3', Icons.headset_mic_outlined, Colors.red, AppColors.pastelRed)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
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
            const SizedBox(width: AppSpacing.s12),
            Flexible(
              child: Text(
                value,
                style: AppTypography.header.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNavy,
                ),
                overflow: TextOverflow.ellipsis,
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
            letterSpacing: 0.8,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SuperAdminDailyControlCard extends StatelessWidget {
  const _SuperAdminDailyControlCard();

  @override
  Widget build(BuildContext context) {
    return QanomyCard(
      onTap: () {
        SuperAdminMainLayout.instance?.switchSidebar(1); // Navigate to Firms
      },
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Super Admin Control Desk',
                  style: AppTypography.bodyInterSemiBold.copyWith(fontSize: 15),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Manage law firm registrations & system compliance',
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
    );
  }
}

class _SuperAdminRegistrationChart extends StatelessWidget {
  const _SuperAdminRegistrationChart();

  @override
  Widget build(BuildContext context) {
    final rawChartData = [
      {'month': 'Mar', 'value': 2},
      {'month': 'Apr', 'value': 4},
      {'month': 'May', 'value': 7},
      {'month': 'Jun', 'value': 5},
      {'month': 'Jul', 'value': 10},
      {'month': 'Aug', 'value': 14},
    ];

    const double maxBarHeight = 80.0;
    const double maxVal = 14.0;

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Chambers Registrations',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'LAST 6 MONTHS GROWTH RATE',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.5),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: rawChartData.map((d) {
                final val = (d['value'] as num).toDouble();
                final barHeight = (val / maxVal) * maxBarHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${d['value']}',
                      style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF219EBC), Color(0xFF023047)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      d['month'] as String,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuperAdminRecentChambersCard extends StatelessWidget {
  const _SuperAdminRecentChambersCard();

  static const List<Map<String, dynamic>> _recentFirms = [
    {
      'name': 'Pwm',
      'owner': 'Muhammad Awais Iqbal',
      'lawyers': 1,
      'tier': 'Free',
      'avatarBg': Color(0xFFFFF4E5),
      'avatarColor': Color(0xFFFF8C00),
    },
    {
      'name': 'Awan Law Chamber',
      'owner': 'Zubair Ahmed',
      'lawyers': 1,
      'tier': 'Free',
      'avatarBg': Color(0xFFEBF5FF),
      'avatarColor': Color(0xFF0066FF),
    },
    {
      'name': 'NUMERIC COMMUNICATIONS',
      'owner': 'Waleed Awan',
      'lawyers': 2,
      'tier': 'Free',
      'avatarBg': Color(0xFFE6F8F6),
      'avatarColor': Color(0xFF00A896),
    },
    {
      'name': 'Khan\'s Firm',
      'owner': 'Haris khan',
      'lawyers': 7,
      'tier': 'Free',
      'avatarBg': Color(0xFFF3E8FF),
      'avatarColor': Color(0xFF7C3AED),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_rounded,
                  size: 18,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recently Registered',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Latest onboarded legal firms',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(1); // Firms screen
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all (7)',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.princetonOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.princetonOrange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentFirms.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final f = _recentFirms[index];
              final String name = f['name'] as String;
              final String owner = f['owner'] as String;
              final int lawyers = f['lawyers'] as int;
              final String tier = f['tier'] as String;
              final Color avatarBg = f['avatarBg'] as Color;
              final Color avatarColor = f['avatarColor'] as Color;

              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    SuperAdminMainLayout.instance?.switchSidebar(1);
                  },
                  borderRadius: BorderRadius.circular(10),
                  hoverColor: AppColors.primaryNavy.withValues(alpha: 0.03),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: avatarBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: avatarColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'F',
                            style: AppTypography.bodyInterSemiBold.copyWith(
                              color: avatarColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: AppTypography.bodyInterMedium.copyWith(
                                  color: AppColors.primaryNavy,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 12,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      '$owner • $lawyers ${lawyers == 1 ? "user" : "users"}',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFDCFCE7),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                tier,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFF15803D),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SuperAdminQuickActionsGrid extends StatelessWidget {
  const _SuperAdminQuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Super Admin modules',
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                SuperAdminMainLayout.instance?.switchSidebar(8); // Master Settings
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
                    'Master Settings ',
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
                _buildActionItem('Firms', Icons.domain_outlined, AppColors.skyBlue, AppColors.pastelBlue, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(1);
                }),
                _buildActionItem('Billing', Icons.credit_card_outlined, Colors.green, AppColors.pastelGreen, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(2);
                }),
                _buildActionItem('Support', Icons.support_agent_outlined, Colors.red, AppColors.pastelRed, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(3);
                }),
                _buildActionItem('Users', Icons.people_outline, Colors.purple, AppColors.pastelPurple, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(4);
                }),
                _buildActionItem('Alerts', Icons.notifications_none_outlined, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(5);
                }),
                _buildActionItem('Analytics', Icons.bar_chart_outlined, Colors.amber, AppColors.pastelYellow, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(6);
                }),
                _buildActionItem('Audit Logs', Icons.description_outlined, AppColors.skyBlue, AppColors.pastelBlue, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(7);
                }),
                _buildActionItem('Settings', Icons.shield_outlined, AppColors.princetonOrange, AppColors.pastelOrange, itemWidth, onTap: () {
                  SuperAdminMainLayout.instance?.switchSidebar(8);
                }),
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

