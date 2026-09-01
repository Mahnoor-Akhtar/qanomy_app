import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import 'super_admin_main_layout.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildMainContent(context, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      color: AppColors.sidebarNavy,
      padding: EdgeInsets.fromLTRB(isMobile ? 12 : AppSpacing.s24, AppSpacing.s48, AppSpacing.s24, AppSpacing.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                  onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
                ),
              if (isMobile) const SizedBox(width: 4),
              Expanded(
                child: Text('Good morning 👋',
                    style: AppTypography.header.copyWith(color: Colors.white, fontSize: isMobile ? 22 : 28)),
              ),
              IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 22), onPressed: () {}),
              Stack(
                children: [
                  IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                      onPressed: () {}),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: AppColors.princetonOrange, shape: BoxShape.circle)),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF1B2B3E),
                child: Text('SA', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 48 : 0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '3 tickets',
                    style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.princetonOrange, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' open today',
                    style: AppTypography.bodyInter.copyWith(color: const Color(0xFF8296A4), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.s8),
              _buildSixMetricsGrid(isMobile),
              const SizedBox(height: AppSpacing.s24),
              if (isMobile)
                Column(children: [
                  _buildRegistrationChart(),
                  const SizedBox(height: AppSpacing.s24),
                  _buildRecentChambers(),
                ])
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildRegistrationChart()),
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(flex: 5, child: _buildRecentChambers()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSixMetricsGrid(bool isMobile) {
    final metrics = [
      _MetricCardData(title: 'Total Firms', value: '0', icon: Icons.domain_outlined, iconBg: const Color(0xFFEEF2FF), iconColor: const Color(0xFF6366F1), trend: '+0% from last month', trendColor: const Color(0xFF10B981)),
      _MetricCardData(title: 'Active Subscriptions', value: '0', icon: Icons.description_outlined, iconBg: const Color(0xFFECFDF5), iconColor: const Color(0xFF10B981), trend: '+0% from last month', trendColor: const Color(0xFF10B981)),
      _MetricCardData(title: 'Monthly Revenue', value: 'PKR 0.00L', iconLabel: 'Rs', iconBg: const Color(0xFFF5F3FF), iconColor: const Color(0xFF8B5CF6), trend: '+0% from last month', trendColor: const Color(0xFF10B981)),
      _MetricCardData(title: 'New Signups', value: '0', icon: Icons.person_add_alt_1_outlined, iconBg: const Color(0xFFFFF7ED), iconColor: const Color(0xFFF97316), trend: '+0% from last month', trendColor: const Color(0xFF10B981)),
      _MetricCardData(title: 'Expiring Trials', value: '0', icon: Icons.hourglass_empty_outlined, iconBg: const Color(0xFFFFF1F2), iconColor: const Color(0xFFE11D48), trend: 'In next 7 days', trendColor: const Color(0xFFE11D48), trendIcon: false),
      _MetricCardData(title: 'Tickets Open', value: '0', icon: Icons.headset_mic_outlined, iconBg: const Color(0xFFF0F9FF), iconColor: const Color(0xFF0284C7), trend: 'View tickets →', trendColor: const Color(0xFF0284C7), trendIcon: false),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: isMobile ? 12 : 16,
        mainAxisSpacing: isMobile ? 12 : 16,
        childAspectRatio: isMobile ? 1.2 : 2.0,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => _MetricCard(data: metrics[index]),
    );
  }

  Widget _buildRegistrationChart() {
    final chartData = [
      {'month': 'Mar', 'value': 2, 'height': 24.0},
      {'month': 'Apr', 'value': 4, 'height': 48.0},
      {'month': 'May', 'value': 7, 'height': 90.0},
      {'month': 'Jun', 'value': 5, 'height': 60.0},
      {'month': 'Jul', 'value': 10, 'height': 130.0},
      {'month': 'Aug', 'value': 14, 'height': 180.0},
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Chambers Registrations',
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('LAST 6 MONTHS GROW RATE',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 32),
          SizedBox(
            height: 240,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((d) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${d['value']}',
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      width: 32,
                      height: d['height'] as double,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF219EBC), Color(0xFF023047)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(d['month'] as String,
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChambers() {
    final recentFirms = [
      {'name': 'Khan & Associates', 'owner': 'Ayesha Khan', 'lawyers': 8, 'tier': 'Premium'},
      {'name': 'Multan Legal Hub', 'owner': 'Ejaz Ahmed', 'lawyers': 3, 'tier': 'Standard'},
      {'name': 'DHA Law Chambers', 'owner': 'M. Haris', 'lawyers': 12, 'tier': 'Premium'},
      {'name': 'Karachi Cyber Desk', 'owner': 'Fatima Shah', 'lawyers': 5, 'tier': 'Standard'},
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recently Registered',
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentFirms.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final f = recentFirms[index];
              final isPremium = f['tier'] == 'Premium';
              return Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isPremium ? const Color(0xFFFFF0E6) : const Color(0xFFE8F0FE),
                    child: Icon(Icons.gavel_rounded,
                        color: isPremium ? AppColors.princetonOrange : AppColors.blueGreen, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f['name'] as String,
                            style: AppTypography.bodyInterMedium.copyWith(
                                color: AppColors.primaryNavy, fontSize: 13, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        Text('Owner: ${f['owner']} • ${f['lawyers']} lawyers',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPremium ? const Color(0xFFFFF0E6) : const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(f['tier'] as String,
                        style: AppTypography.labelSmall.copyWith(
                            color: isPremium ? AppColors.princetonOrange : AppColors.blueGreen,
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricCardData {
  final String title, value;
  final IconData? icon;
  final String? iconLabel;
  final Color iconBg, iconColor, trendColor;
  final String trend;
  final bool trendIcon;
  const _MetricCardData({required this.title, required this.value, this.icon, this.iconLabel, required this.iconBg, required this.iconColor, required this.trend, required this.trendColor, this.trendIcon = true});
}

class _MetricCard extends StatelessWidget {
  final _MetricCardData data;
  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: data.iconBg, borderRadius: BorderRadius.circular(10)),
            child: data.icon != null
                ? Icon(data.icon, color: data.iconColor, size: 20)
                : Center(child: Text(data.iconLabel ?? '',
                    style: TextStyle(color: data.iconColor, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 2),
              Text(data.value,
                  style: AppTypography.header.copyWith(color: AppColors.primaryNavy, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (data.trendIcon) ...[
                    Icon(Icons.arrow_upward_rounded, size: 11, color: data.trendColor),
                    const SizedBox(width: 2),
                  ],
                  Expanded(
                    child: Text(data.trend,
                        style: AppTypography.labelSmall.copyWith(color: data.trendColor, fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
