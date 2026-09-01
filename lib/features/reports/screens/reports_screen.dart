import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _touchedDonutIndex = -1;
  int _touchedRevDonutIndex = -1;

  final _stats = [
    {'label': 'TOTAL ACTIVE CASES', 'value': '7', 'sub': 'All time', 'icon': Icons.work_outline, 'color': Color(0xFF3B82F6)},
    {'label': 'CASES DISPOSED', 'value': '1', 'sub': 'Fully closed', 'icon': Icons.check_circle_outline, 'color': Color(0xFF10B981)},
    {'label': 'ADJOURNED CASES', 'value': '0', 'sub': 'Currently', 'icon': Icons.access_time_outlined, 'color': Color(0xFFF59E0B)},
    {'label': 'TOTAL CLIENTS', 'value': '3', 'sub': 'Registered', 'icon': Icons.people_outline, 'color': Color(0xFF8B5CF6)},
    {'label': 'TOTAL BILLED (PKR)', 'value': 'PKR 350k', 'sub': 'All invoices', 'icon': Icons.currency_rupee, 'color': Color(0xFF10B981)},
    {'label': 'OUTSTANDING (PKR)', 'value': 'PKR 300k', 'sub': 'Unpaid', 'icon': Icons.receipt_outlined, 'color': Color(0xFFEF4444)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: QanomyAppBar(
        title: isMobile ? 'Reports' : 'Reports & Analytics',
        actions: isMobile
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, color: AppColors.primaryNavy),
                          const SizedBox(width: 8),
                          Text('Refresh', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'filters',
                      child: Row(
                        children: [
                          Icon(Icons.filter_list_rounded, color: AppColors.primaryNavy),
                          const SizedBox(width: 8),
                          Text('Filters', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.download_rounded, color: AppColors.primaryNavy),
                          const SizedBox(width: 8),
                          Text('Export', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'custom',
                      child: Row(
                        children: [
                          const Icon(Icons.bar_chart_rounded, color: Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          Text('Custom Report', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF10B981))),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ]
            : [
                _AppBarIconButton(icon: Icons.refresh_rounded, onTap: () {}),
                QanomyAppBarButton(label: 'Filters', icon: Icons.filter_list_rounded, onPressed: () {}),
                QanomyAppBarButton(label: 'Export', icon: Icons.download_rounded, onPressed: () {}),
                QanomyAppBarButton(
                  label: 'Custom Report',
                  icon: Icons.bar_chart_rounded,
                  onPressed: () {},
                  color: const Color(0xFF10B981),
                ),
              ],
      ),
      body: Column(
        children: [
          // Stats Row (Minimalistic)
          _buildStatsRow(isMobile),
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: isMobile,
              labelColor: const Color(0xFF10B981),
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: const Color(0xFF10B981),
              indicatorWeight: 3,
              labelStyle: AppTypography.bodyInterMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.bodyInter.copyWith(fontSize: 14),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Cases'),
                Tab(text: 'Revenue'),
                Tab(text: 'Team Performance'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(isMobile),
                _buildCasesTab(isMobile),
                _buildRevenueTab(isMobile),
                _buildTeamTab(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: isMobile
          ? SizedBox(
              height: 74,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _stats.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 145,
                    margin: const EdgeInsets.only(right: 10),
                    child: _StatCard(data: _stats[index], index: index),
                  );
                },
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _stats.asMap().entries.map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: e.key < _stats.length - 1 ? 8 : 0),
                    child: _StatCard(data: e.value, index: e.key),
                  ),
                )).toList(),
              ),
            ),
    );
  }

  Widget _buildOverviewTab(bool isMobile) {
    // Highly minimalistic Overview tab: Shows only 3 clean charts instead of 6 duplicating widgets!
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        children: [
          isMobile
              ? Column(children: [
                  _buildRevenueLineChart(),
                  const SizedBox(height: 16),
                  _buildCasesByStatusChart(),
                  const SizedBox(height: 16),
                  _buildQuickReports(),
                ])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 5, child: _buildRevenueLineChart()),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: _buildCasesByStatusChart()),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: _buildQuickReports()),
                ]),
        ],
      ),
    );
  }

  Widget _buildCasesTab(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        children: [
          isMobile
              ? Column(children: [
                  _buildCaseStatusTable(),
                  const SizedBox(height: 16),
                  _buildCasesByTypeHorizBar(),
                ])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _buildCaseStatusTable()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCasesByTypeHorizBar()),
                ]),
          const SizedBox(height: 16),
          _buildCasesByCourtChart(tall: true),
        ],
      ),
    );
  }

  Widget _buildRevenueTab(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        children: [
          isMobile
              ? Column(children: [
                  _buildRevDonutSummaryCard('Total Billed', 'PKR 350,000', const Color(0xFF3B82F6)),
                  const SizedBox(height: 12),
                  _buildRevDonutSummaryCard('Paid / Received', 'PKR 50,000', const Color(0xFF10B981)),
                  const SizedBox(height: 12),
                  _buildRevDonutSummaryCard('Outstanding', 'PKR 300,000', const Color(0xFFEF4444)),
                ])
              : Row(children: [
                  Expanded(child: _buildRevDonutSummaryCard('Total Billed', 'PKR 350,000', const Color(0xFF3B82F6))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildRevDonutSummaryCard('Paid / Received', 'PKR 50,000', const Color(0xFF10B981))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildRevDonutSummaryCard('Outstanding', 'PKR 300,000', const Color(0xFFEF4444))),
                ]),
          const SizedBox(height: 16),
          _buildRevenueLineChart(tall: true),
          const SizedBox(height: 16),
          _buildRevByTypeChart(tall: true),
        ],
      ),
    );
  }

  Widget _buildTeamTab(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: _buildTeamFullTable(),
    );
  }

  Widget _buildCasesByStatusChart() {
    const sections = [
      {'label': 'REOPEN', 'value': 4.0, 'pct': '57.1%', 'color': Color(0xFF3B82F6)},
      {'label': 'OPEN', 'value': 2.0, 'pct': '28.6%', 'color': Color(0xFFF59E0B)},
      {'label': 'CLOSED', 'value': 1.0, 'pct': '14.3%', 'color': Color(0xFF10B981)},
    ];
    return _ChartCard(
      title: 'Cases by Status',
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, resp) {
                    setState(() {
                      _touchedDonutIndex = resp?.touchedSection?.touchedSectionIndex ?? -1;
                    });
                  },
                ),
                centerSpaceRadius: 52,
                sectionsSpace: 2,
                sections: sections.asMap().entries.map((e) {
                  final touched = e.key == _touchedDonutIndex;
                  return PieChartSectionData(
                    value: e.value['value'] as double,
                    color: e.value['color'] as Color,
                    radius: touched ? 52 : 44,
                    title: touched ? e.value['pct'] as String : '',
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ),
              swapAnimationDuration: 300.ms,
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          ),
          const SizedBox(height: 4),
          Text('Total\n7', textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...sections.map((s) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: s['color'] as Color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(s['label'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 12))),
                Text('${(s['value'] as double).toInt()} (${s['pct']})', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCasesByCourtChart({bool tall = false}) {
    final courts = ['Banking Court,\nKarachi', 'Family Court,\nLahore', 'Sindh High\nCourt'];
    return _ChartCard(
      title: 'Cases by Court',
      child: SizedBox(
        height: tall ? 250 : 220,
        child: BarChart(
          BarChartData(
            maxY: 1.5,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border.withValues(alpha: 0.5), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 0.5,
                  getTitlesWidget: (v, _) => Text(v.toStringAsFixed(1), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  reservedSize: 30,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final idx = v.toInt();
                    if (idx < 0 || idx >= courts.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(courts[idx], textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(courts.length, (i) => BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: 1, width: 30, color: const Color(0xFF93C5FD), borderRadius: BorderRadius.circular(4))],
            )),
          ),
          swapAnimationDuration: 600.ms,
          swapAnimationCurve: Curves.easeOutCubic,
        ).animate().slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _buildRevenueLineChart({bool tall = false}) {
    return _ChartCard(
      title: 'Revenue Overview (PKR) - Last 6 Months',
      child: SizedBox(
        height: tall ? 300 : 220,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border.withValues(alpha: 0.4), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: 100000,
                  getTitlesWidget: (v, _) {
                    final label = v >= 1000000 ? '${(v / 1000000).toStringAsFixed(1)}M' : v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}k' : v.toStringAsFixed(0);
                    return Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (v, _) {
                    const labels = ['Mar 26', 'Apr 26', 'May 26', 'Jun 26', 'Jul 26', 'Aug 26'];
                    final idx = v.toInt();
                    if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                    return Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[idx], style: const TextStyle(fontSize: 9, color: AppColors.textMuted)));
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 20000), FlSpot(3, 30000), FlSpot(4, 70000), FlSpot(5, 350000)],
                isCurved: true, color: const Color(0xFF10B981), barWidth: 2,
                dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 3, color: const Color(0xFF10B981), strokeWidth: 0, strokeColor: Colors.white)),
                belowBarData: BarAreaData(show: true, color: const Color(0xFF10B981).withValues(alpha: 0.06)),
              ),
              LineChartBarData(
                spots: const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0), FlSpot(4, 0), FlSpot(5, 50000)],
                isCurved: true, color: const Color(0xFF3B82F6), barWidth: 2,
                dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 3, color: const Color(0xFF3B82F6), strokeWidth: 0, strokeColor: Colors.white)),
              ),
              LineChartBarData(
                spots: const [FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 20000), FlSpot(3, 30000), FlSpot(4, 70000), FlSpot(5, 300000)],
                isCurved: true, color: const Color(0xFFEF4444), barWidth: 2,
                dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 3, color: const Color(0xFFEF4444), strokeWidth: 0, strokeColor: Colors.white)),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, duration: 600.ms),
      ),
    );
  }

  Widget _buildRevByTypeChart({bool tall = false}) {
    const sections = [
      {'label': 'NAB / Cybercrime', 'value': 290000.0, 'pct': '82.9%', 'color': Color(0xFF3B82F6)},
      {'label': 'Family', 'value': 60000.0, 'pct': '17.1%', 'color': Color(0xFFF59E0B)},
    ];
    return _ChartCard(
      title: 'Revenue by Case Type (PKR)',
      child: SizedBox(
        height: tall ? 260 : 200,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (_, resp) => setState(() => _touchedRevDonutIndex = resp?.touchedSection?.touchedSectionIndex ?? -1)),
                  centerSpaceRadius: 45,
                  sectionsSpace: 2,
                  sections: sections.asMap().entries.map((e) {
                    final touched = e.key == _touchedRevDonutIndex;
                    return PieChartSectionData(
                      value: e.value['value'] as double,
                      color: e.value['color'] as Color,
                      radius: touched ? 52 : 44,
                      title: '',
                    );
                  }).toList(),
                ),
              ).animate().scale(duration: 700.ms, curve: Curves.easeOutBack),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total\nPKR 350k', textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...sections.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: s['color'] as Color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['label'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11)),
                          Text('PKR ${((s['value'] as double) / 1000).toStringAsFixed(0)}k  ${s['pct']}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseStatusTable() {
    const rows = [
      {'status': 'REOPEN', 'count': 4, 'pct': '57.1%', 'color': Color(0xFF3B82F6)},
      {'status': 'OPEN', 'count': 2, 'pct': '28.6%', 'color': Color(0xFFF59E0B)},
      {'status': 'CLOSED', 'count': 1, 'pct': '14.3%', 'color': Color(0xFF10B981)},
    ];
    return _ChartCard(
      title: 'Cases by Status',
      child: Column(
        children: [
          _tableHeader(['Status', 'Count', '%']),
          const Divider(height: 1),
          ...rows.asMap().entries.map((e) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: e.value['color'] as Color, shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value['status'] as String, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                    SizedBox(width: 50, child: Text('${e.value['count']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                    SizedBox(width: 50, child: Text(e.value['pct'] as String, textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary, fontSize: 13))),
                  ],
                ),
              ),
              if (e.key < rows.length - 1) const Divider(height: 1),
            ],
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCasesByTypeHorizBar() {
    final types = [
      {'label': 'NAB / Cybercrime', 'value': 6.0, 'color': const Color(0xFF3B82F6)},
      {'label': 'Family', 'value': 1.0, 'color': const Color(0xFFF59E0B)},
    ];
    return _ChartCard(
      title: 'Cases by Case Type',
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: 6.5,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border.withValues(alpha: 0.4), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    final idx = v.toInt();
                    if (idx < 0 || idx >= types.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(types[idx]['label'] as String, textAlign: TextAlign.right, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: types.asMap().entries.map((e) => BarChartGroupData(
              x: e.key,
              barRods: [BarChartRodData(toY: e.value['value'] as double, width: 20, color: e.value['color'] as Color, borderRadius: BorderRadius.circular(4))],
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamPerformanceMini() {
    final isMobile = Responsive.isMobile(context);
    final members = [
      {'name': 'Haris khan', 'role': 'Lawyer', 'active': 2, 'disposed': 0, 'total': 2},
      {'name': 'Fatima', 'role': 'Lawyer', 'active': 2, 'disposed': 0, 'total': 2},
      {'name': 'Ejaz', 'role': 'Lawyer', 'active': 0, 'disposed': 1, 'total': 1},
    ];

    if (isMobile) {
      return _ChartCard(
        title: 'Team Performance (By Cases)',
        child: Column(
          children: members.asMap().entries.map((e) {
            final m = e.value;
            final load = (m['total'] as int) / 2.0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['name'] as String, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(m['role'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active: ${m['active']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text('Disposed: ${m['disposed']}', style: const TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                      Text('Total: ${m['total']}', style: const TextStyle(fontSize: 11, color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: load,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return _ChartCard(
      title: 'Team Performance (By Cases)',
      child: Column(
        children: [
          _tableHeader(['#', 'Team Member', 'Active', 'Disposed', 'Total']),
          const Divider(height: 1),
          ...members.asMap().entries.map((e) {
            final m = e.value;
            final load = (m['total'] as int) / 2.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(width: 20, child: Text('${e.key + 1}', style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m['name'] as String, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                      Text(m['role'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                    ]),
                  ),
                  SizedBox(width: 40, child: Text('${m['active']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                  SizedBox(width: 50, child: Text('${m['disposed']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: m['disposed'] == 0 ? const Color(0xFF10B981) : AppColors.textSecondary, fontSize: 13))),
                  SizedBox(width: 36, child: Text('${m['total']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: load,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        minHeight: 6,
                      ),
                    ).animate().scaleX(begin: 0, duration: 800.ms, alignment: Alignment.centerLeft, curve: Curves.easeOutCubic),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTeamFullTable() {
    final isMobile = Responsive.isMobile(context);
    final members = [
      {'name': 'Haris khan', 'role': 'Lawyer', 'active': 2, 'disposed': 0, 'total': 2},
      {'name': 'Fatima', 'role': 'Lawyer', 'active': 2, 'disposed': 0, 'total': 2},
      {'name': 'Ejaz', 'role': 'Lawyer', 'active': 0, 'disposed': 1, 'total': 1},
    ];

    if (isMobile) {
      return _ChartCard(
        title: 'Team Performance Overview',
        child: Column(
          children: members.asMap().entries.map((e) {
            final m = e.value;
            final load = (m['total'] as int) / 2.0;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primaryNavy.withValues(alpha: 0.1),
                            child: Text('${e.key + 1}', style: const TextStyle(fontSize: 11, color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text(m['name'] as String, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border.withValues(alpha: 0.4))),
                        child: Text(m['role'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniField('Active', '${m['active']}'),
                      _buildMiniField('Disposed', '${m['disposed']}'),
                      _buildMiniField('Total', '${m['total']}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Load', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: load,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return _ChartCard(
      title: 'Team Performance Overview',
      child: Column(
        children: [
          _tableHeader(['#', 'Team Member', 'Role', 'Active Cases', 'Disposed', 'Total', 'Load']),
          const Divider(height: 1),
          ...members.asMap().entries.map((e) {
            final m = e.value;
            final load = (m['total'] as int) / 2.0;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(width: 24, child: Text('${e.key + 1}', style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13))),
                      Expanded(
                        flex: 3,
                        child: Text(m['name'] as String, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.pageBackground, borderRadius: BorderRadius.circular(6)),
                          child: Text(m['role'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        ),
                      ),
                      Expanded(flex: 2, child: Text('${m['active']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                      Expanded(flex: 2, child: Text('${m['disposed']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: m['disposed'] == 0 ? const Color(0xFF10B981) : AppColors.textSecondary, fontSize: 13))),
                      Expanded(flex: 1, child: Text('${m['total']}', textAlign: TextAlign.center, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: load,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                            minHeight: 8,
                          ),
                        ).animate().scaleX(begin: 0, duration: 900.ms, alignment: Alignment.centerLeft, curve: Curves.easeOutCubic),
                      ),
                    ],
                  ),
                ),
                if (e.key < members.length - 1) const Divider(height: 1),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMiniField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9, letterSpacing: 0.3)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuickReports() {
    final items = [
      {'label': 'Cases\nStatus', 'icon': Icons.access_time_outlined, 'color': const Color(0xFF3B82F6)},
      {'label': 'Cases by\nCourt', 'icon': Icons.account_balance_outlined, 'color': const Color(0xFF10B981)},
      {'label': 'Revenue\nReport', 'icon': Icons.currency_rupee, 'color': const Color(0xFFF59E0B)},
      {'label': 'Team\nPerformance', 'icon': Icons.people_outline, 'color': const Color(0xFF8B5CF6)},
      {'label': 'Client\nReport', 'icon': Icons.person_outline, 'color': const Color(0xFF3B82F6)},
      {'label': 'Aging\nOutstanding', 'icon': Icons.access_time_outlined, 'color': const Color(0xFFEF4444)},
    ];
    return _ChartCard(
      title: 'Quick Reports',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
        children: items.asMap().entries.map((e) => InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: (e.value['color'] as Color).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: (e.value['color'] as Color).withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(e.value['icon'] as IconData, color: e.value['color'] as Color, size: 22),
                const SizedBox(height: 6),
                Text(e.value['label'] as String, textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11)),
              ],
            ),
          ).animate(delay: (e.key * 80).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        )).toList(),
      ),
    );
  }

  Widget _buildRevDonutSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(width: 4, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.8)),
              const SizedBox(height: 6),
              Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 400.ms);
  }

  Widget _tableHeader(List<String> cols) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: cols.asMap().entries.map((e) {
          final isFirst = e.key == 0;
          final isExpanded = e.key == 1 || (cols.length > 3 && e.key == 1);
          return isFirst
              ? SizedBox(width: 24, child: _headerCell(e.value))
              : isExpanded
                  ? Expanded(child: _headerCell(e.value))
                  : Expanded(child: _headerCell(e.value, align: TextAlign.center));
        }).toList(),
      ),
    );
  }

  Widget _headerCell(String text, {TextAlign align = TextAlign.start}) {
    return Text(text, textAlign: align, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11, letterSpacing: 0.5));
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.025), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, duration: 400.ms);
  }
}

class _StatCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;

  const _StatCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = data['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(data['icon'] as IconData, color: color, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  data['label'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 8, letterSpacing: 0.3),
                ),
              ),
            ],
          ),
          Text(
            data['value'] as String,
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            data['sub'] as String,
            style: AppTypography.labelSmall.copyWith(color: color, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withValues(alpha: 0.15))),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
