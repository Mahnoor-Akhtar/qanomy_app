import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminAnalyticsScreen extends StatefulWidget {
  const SuperAdminAnalyticsScreen({super.key});

  @override
  State<SuperAdminAnalyticsScreen> createState() => _SuperAdminAnalyticsScreenState();
}

class _SuperAdminAnalyticsScreenState extends State<SuperAdminAnalyticsScreen> {
  String _selectedRange = '30 Days';

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildTimeFilterBar(isMobile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetricsRow(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildRevenueAndPlanRow(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildTrendsRow(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildTablesRow(isMobile),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 24),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Analytics Overview',
              style: AppTypography.header.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 22 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterBar(bool isMobile) {
    final ranges = ['7 Days', '30 Days', '90 Days', 'Year To Date', 'Custom Range'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...ranges.map((r) {
              final isSelected = _selectedRange == r;
              return GestureDetector(
                onTap: () => setState(() => _selectedRange = r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    r,
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, size: 14, color: AppColors.primaryNavy),
              label: Text(
                'Export Report',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow(bool isMobile) {
    final metrics = [
      {'title': 'Total Firms', 'val': '7', 'change': '+14.3% vs previous 30 days', 'isPos': true, 'icon': Icons.domain_outlined, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFF0F9FF)},
      {'title': 'Active Subscriptions', 'val': '7', 'change': '+14.3% vs previous 30 days', 'isPos': true, 'icon': Icons.card_membership_outlined, 'color': const Color(0xFF8B5CF6), 'bg': const Color(0xFFF5F3FF)},
      {'title': 'Monthly Recurring Revenue', 'val': 'PKR 0', 'change': '+0.0% vs previous 30 days', 'isPos': true, 'icon': Icons.payments_outlined, 'color': const Color(0xFF10B981), 'bg': const Color(0xFFECFDF5)},
      {'title': 'Total Users', 'val': '10', 'change': '+25.0% vs previous 30 days', 'isPos': true, 'icon': Icons.people_outline, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFF0F9FF)},
      {'title': 'Churn Rate', 'val': '0%', 'change': '-0.0% vs previous 30 days', 'isPos': true, 'icon': Icons.trending_down_outlined, 'color': const Color(0xFFE53935), 'bg': const Color(0xFFFFEBEE)},
      {'title': 'Growth Rate', 'val': '14.3%', 'change': '+14.3% vs previous 30 days', 'isPos': true, 'icon': Icons.trending_up_outlined, 'color': AppColors.princetonOrange, 'bg': const Color(0xFFFFF7ED)},
    ];

    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, idx) => _buildMetricCard(metrics[idx]),
      );
    }

    return Row(
      children: metrics.map((m) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: _buildMetricCard(m),
      ))).toList(),
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> m) {
    final Color color = m['color'] as Color;
    final Color bg = m['bg'] as Color;

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  m['title'] as String,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(m['icon'] as IconData, size: 14, color: color),
              ),
            ],
          ),
          Text(
            m['val'] as String,
            style: AppTypography.header.copyWith(
              color: AppColors.primaryNavy,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            m['change'] as String,
            style: AppTypography.labelSmall.copyWith(color: const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueAndPlanRow(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildRevenueGrowthCard(),
          const SizedBox(height: 16),
          _buildFirmsByPlanCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: _buildRevenueGrowthCard()),
        const SizedBox(width: 16),
        Expanded(flex: 4, child: _buildFirmsByPlanCard()),
      ],
    );
  }

  Widget _buildRevenueGrowthCard() {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Growth (PKR)',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.navBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Monthly',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _LineChartPainter(
                lineColor: const Color(0xFF0284C7),
                fillColor: const Color(0xFF0284C7).withValues(alpha: 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirmsByPlanCard() {
    final plans = [
      {'name': 'Basic', 'pct': '0%', 'count': '0 firms', 'color': const Color(0xFF0284C7)},
      {'name': 'Professional', 'pct': '0%', 'count': '0 firms', 'color': const Color(0xFF8B5CF6)},
      {'name': 'Pro', 'pct': '0%', 'count': '0 firms', 'color': AppColors.princetonOrange},
      {'name': 'Enterprise', 'pct': '0%', 'count': '0 firms', 'color': const Color(0xFFE53935)},
      {'name': 'Free', 'pct': '100%', 'count': '7 firms', 'color': const Color(0xFF10B981)},
    ];

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Firms by Plan',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: plans.map((p) {
              final Color c = p['color'] as Color;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p['name'] as String,
                        style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${p['count']} (${p['pct']})',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsRow(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildMiniChartCard('Shortcode Trend (%)', const Color(0xFFE53935)),
          const SizedBox(height: 16),
          _buildMiniChartCard('New Signups Trend', const Color(0xFF10B981)),
          const SizedBox(height: 16),
          _buildMiniChartCard('MRR vs New Signups', const Color(0xFF8B5CF6)),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _buildMiniChartCard('Shortcode Trend (%)', const Color(0xFFE53935))),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniChartCard('New Signups Trend', const Color(0xFF10B981))),
        const SizedBox(width: 16),
        Expanded(child: _buildMiniChartCard('MRR vs New Signups', const Color(0xFF8B5CF6))),
      ],
    );
  }

  Widget _buildMiniChartCard(String title, Color color) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13),
              ),
              Text(
                'Monthly',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: CustomPaint(
              size: const Size(double.infinity, 90),
              painter: _LineChartPainter(
                lineColor: color,
                fillColor: color.withValues(alpha: 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablesRow(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildMostActiveFirmsCard(),
          const SizedBox(height: 16),
          _buildFeatureUsageCard(),
          const SizedBox(height: 16),
          _buildFirmsAtRiskCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMostActiveFirmsCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildFeatureUsageCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildFirmsAtRiskCard()),
      ],
    );
  }

  Widget _buildMostActiveFirmsCard() {
    final activeFirms = [
      {'rank': '1', 'name': 'Khan\'s Firm', 'cases': '402', 'users': '7', 'plan': 'Free'},
      {'rank': '2', 'name': 'Asi', 'cases': '120', 'users': '1', 'plan': 'Free'},
      {'rank': '3', 'name': 'Awan Law Chamber', 'cases': '85', 'users': '1', 'plan': 'Free'},
      {'rank': '4', 'name': 'Pwm', 'cases': '64', 'users': '1', 'plan': 'Free'},
      {'rank': '5', 'name': 'Hgg', 'cases': '45', 'users': '1', 'plan': 'Free'},
    ];

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Active Firms (by Total Logins)',
            style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Column(
            children: activeFirms.map((f) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text('#${f['rank']}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f['name'] as String,
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('${f['cases']} cases', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
                      child: Text(f['plan'] as String, style: AppTypography.labelSmall.copyWith(color: const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureUsageCard() {
    final features = [
      {'name': 'Hearings & Reminders', 'pct': 0.84, 'val': '84%'},
      {'name': 'Documents', 'pct': 0.65, 'val': '65%'},
      {'name': 'Invoicing & Billing', 'pct': 0.42, 'val': '42%'},
      {'name': 'Cause List Automation', 'pct': 0.28, 'val': '28%'},
    ];

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Usage (Platform-wide)',
            style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Column(
            children: features.map((f) {
              final double pct = f['pct'] as double;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(f['name'] as String, style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
                        Text(f['val'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFirmsAtRiskCard() {
    final riskFirms = [
      {'name': 'Pwm', 'risk': 'Medium', 'date': '29/08/2026'},
      {'name': 'Khan\'s Firm', 'risk': 'Medium', 'date': '14/08/2026'},
      {'name': 'NUMERIC COMMUNICATIONS', 'risk': 'Medium', 'date': '17/08/2026'},
      {'name': 'Khan\'s Firm', 'risk': 'Medium', 'date': '07/08/2026'},
      {'name': 'Hgg', 'risk': 'Medium', 'date': '19/08/2026'},
    ];

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Firms at Risk (High Priority)',
            style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Column(
            children: riskFirms.map((f) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        f['name'] as String,
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(4)),
                      child: Text(f['risk'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.princetonOrange, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(f['date'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  _LineChartPainter({required this.lineColor, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.cubicTo(
      size.width * 0.35, size.height * 0.85,
      size.width * 0.45, size.height * 0.1,
      size.width * 0.65, size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.9, size.height * 0.75,
      size.width, size.height * 0.9,
    );

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
