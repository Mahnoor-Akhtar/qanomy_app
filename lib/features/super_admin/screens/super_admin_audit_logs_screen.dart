import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminAuditLogsScreen extends StatefulWidget {
  const SuperAdminAuditLogsScreen({super.key});

  @override
  State<SuperAdminAuditLogsScreen> createState() => _SuperAdminAuditLogsScreenState();
}

class _SuperAdminAuditLogsScreenState extends State<SuperAdminAuditLogsScreen> {
  String _searchQuery = '';
  final String _selectedFirm = 'All Firms';
  final String _selectedAction = 'All Actions';
  final String _selectedStatus = 'All Status';
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _expandedLogIndices = {};

  final List<Map<String, dynamic>> _logs = [
    {
      'id': 1,
      'code': 'QA',
      'user': 'Qanomy Admin (MA)',
      'email': 'mahnoor01999@gmail.com',
      'firm': 'Platform',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '1 Sept 2026, 09:28 am',
      'ip': '172.70.142.155',
      'status': 'Success',
    },
    {
      'id': 2,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '1 Sept 2026, 09:28 am',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 3,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '1 Sept 2026, 08:48 am',
      'ip': '172.71.124.208',
      'status': 'Success',
    },
    {
      'id': 4,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '1 Sept 2026, 08:47 am',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 5,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '1 Sept 2026, 07:34 am',
      'ip': '104.23.175.80',
      'status': 'Success',
    },
    {
      'id': 6,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '1 Sept 2026, 07:34 am',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 7,
      'code': 'HC',
      'user': 'Hamad Client',
      'email': 'lioness99999999@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '1 Sept 2026, 07:31 am',
      'ip': '172.71.81.187',
      'status': 'Success',
    },
    {
      'id': 8,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '1 Sept 2026, 07:31 am',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 9,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '1 Sept 2026, 07:30 am',
      'ip': '172.71.81.90',
      'status': 'Success',
    },
    {
      'id': 10,
      'code': 'QA',
      'user': 'Qanomy Admin (MA)',
      'email': 'mahnoor01999@gmail.com',
      'firm': 'Platform',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '31 Aug 2026, 04:23 pm',
      'ip': '172.68.164.58',
      'status': 'Success',
    },
    {
      'id': 11,
      'code': 'SA',
      'user': 'Super Admin',
      'email': 'info@qanomy.com',
      'firm': 'Platform',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '31 Aug 2026, 03:49 pm',
      'ip': '172.70.208.95',
      'status': 'Success',
    },
    {
      'id': 12,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '31 Aug 2026, 03:48 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 13,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '31 Aug 2026, 03:48 pm',
      'ip': '104.23.175.104',
      'status': 'Success',
    },
    {
      'id': 14,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '30 Aug 2026, 06:29 pm',
      'ip': '172.68.164.59',
      'status': 'Success',
    },
    {
      'id': 15,
      'code': 'MA',
      'user': 'Muhammad Awais Iqbal',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'firm': 'Pwm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '29 Aug 2026, 12:21 pm',
      'ip': '104.22.175.143',
      'status': 'Success',
    },
    {
      'id': 16,
      'code': 'MA',
      'user': 'Muhammad Awais Iqbal',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'firm': 'Pwm',
      'action': 'Email Verified',
      'details': 'Email verified successfully for Muhammad Awais Iqbal (awaisiqbalalamgirian@gmail.com) - Firm: "Pwm"',
      'time': '29 Aug 2026, 12:20 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 17,
      'code': 'MA',
      'user': 'Muhammad Awais Iqbal',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'firm': 'Pwm',
      'action': 'Created Firm',
      'details': 'Firm "Pwm" registered',
      'time': '29 Aug 2026, 12:20 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 18,
      'code': 'MA',
      'user': 'Muhammad Awais Iqbal',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'firm': 'Pwm',
      'action': 'Signup Pending Verification',
      'details': 'Signup initiated (email verification pending) for Muhammad Awais Iqbal (awaisiqbalalamgirian@gmail.com) - Firm: "Pwm"',
      'time': '29 Aug 2026, 12:19 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 19,
      'code': 'ZA',
      'user': 'Zubair Ahmed',
      'email': 'zbhutta5@gmail.com',
      'firm': 'Awan Law Chamber',
      'action': 'Email Verified',
      'details': 'Email verified successfully for Zubair Ahmed (zbhutta5@gmail.com) - Firm: "Awan Law Chamber"',
      'time': '29 Aug 2026, 12:18 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 20,
      'code': 'ZA',
      'user': 'Zubair Ahmed',
      'email': 'zbhutta5@gmail.com',
      'firm': 'Awan Law Chamber',
      'action': 'Created Firm',
      'details': 'Firm "Awan Law Chamber" registered',
      'time': '29 Aug 2026, 12:18 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 21,
      'code': 'ZA',
      'user': 'Zubair Ahmed',
      'email': 'zbhutta5@gmail.com',
      'firm': 'Awan Law Chamber',
      'action': 'Signup Pending Verification',
      'details': 'Signup initiated (email verification pending) for Zubair Ahmed (zbhutta5@gmail.com) - Firm: "Awan Law Chamber"',
      'time': '29 Aug 2026, 12:18 pm',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 22,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Platform',
      'action': 'Logout',
      'details': '{}',
      'time': '26 Aug 2026, 02:17 am',
      'ip': '—',
      'status': 'Success',
    },
    {
      'id': 23,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login',
      'details': 'User logged in successfully',
      'time': '26 Aug 2026, 02:16 am',
      'ip': '172.70.201.143',
      'status': 'Success',
    },
    {
      'id': 24,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Login Failed',
      'details': 'Invalid password',
      'time': '26 Aug 2026, 02:16 am',
      'ip': '172.70.201.143',
      'status': 'Failed',
    },
    {
      'id': 25,
      'code': 'HK',
      'user': 'Haris khan',
      'email': 'mahnoorakhtar002@gmail.com',
      'firm': 'Khan\'s Firm',
      'action': 'Updated Case',
      'details': 'Case e341c939-18d0-4fac-9684-e7e58b0fe241 updated',
      'time': '24 Aug 2026, 10:47 am',
      'ip': '—',
      'status': 'Success',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedLogIndices.contains(id)) {
        _expandedLogIndices.remove(id);
      } else {
        _expandedLogIndices.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final filteredLogs = _logs.where((l) {
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (l['user'] as String).toLowerCase().contains(q) ||
          (l['email'] as String).toLowerCase().contains(q) ||
          (l['action'] as String).toLowerCase().contains(q) ||
          (l['firm'] as String).toLowerCase().contains(q) ||
          (l['details'] as String).toLowerCase().contains(q);

      final matchesFirm = _selectedFirm == 'All Firms' || l['firm'] == _selectedFirm;
      final matchesAction = _selectedAction == 'All Actions' || l['action'] == _selectedAction;
      final matchesStatus = _selectedStatus == 'All Status' || l['status'] == _selectedStatus;

      return matchesQuery && matchesFirm && matchesAction && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildMetricsOverview(isMobile),
            _buildSearchAndFiltersBar(isMobile),
            Expanded(
              child: filteredLogs.isEmpty
                  ? Center(
                      child: Text(
                        'No audit log entries found',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                      itemCount: filteredLogs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _buildCollapsibleLogCard(filteredLogs[index], isMobile),
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
              'Audit Logs',
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

  Widget _buildMetricsOverview(bool isMobile) {
    if (isMobile) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 170, child: _buildMetricTile('Total Activities', '100', '↑ 18.7%', const Color(0xFF0284C7), const Color(0xFFF0F9FF))),
              const SizedBox(width: 10),
              SizedBox(width: 170, child: _buildMetricTile('Successful Actions', '99', '99.0%', const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 10),
              SizedBox(width: 160, child: _buildMetricTile('Failed Actions', '1', '1.0%', const Color(0xFFE53935), const Color(0xFFFFEBEE))),
              const SizedBox(width: 10),
              SizedBox(width: 170, child: _buildMetricTile('Unique Users', '13', 'Across 8 firms', AppColors.primaryNavy, const Color(0xFFF1F5F9))),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(child: _buildMetricTile('Total Activities', '100', '↑ 18.7%', const Color(0xFF0284C7), const Color(0xFFF0F9FF))),
          const SizedBox(width: 10),
          Expanded(child: _buildMetricTile('Successful Actions', '99', '99.0%', const Color(0xFF10B981), const Color(0xFFECFDF5))),
          const SizedBox(width: 10),
          Expanded(child: _buildMetricTile('Failed Actions', '1', '1.0%', const Color(0xFFE53935), const Color(0xFFFFEBEE))),
          const SizedBox(width: 10),
          Expanded(child: _buildMetricTile('Unique Users', '13', 'Across 8 firms', AppColors.primaryNavy, const Color(0xFFF1F5F9))),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String val, String sub, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                val,
                style: AppTypography.header.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  sub,
                  style: AppTypography.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFiltersBar(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.navBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.bodyInter.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search by user name, email, action, or firm...',
                      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12),
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 14, color: AppColors.primaryNavy),
                label: Text(
                  'Export',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleLogCard(Map<String, dynamic> log, bool isMobile) {
    final int id = log['id'] as int;
    final String code = log['code'] as String;
    final String user = log['user'] as String;
    final String email = log['email'] as String;
    final String firm = log['firm'] as String;
    final String action = log['action'] as String;
    final String details = log['details'] as String;
    final String time = log['time'] as String;
    final String ip = log['ip'] as String;
    final String status = log['status'] as String;

    final isExpanded = _expandedLogIndices.contains(id);
    final isFailed = status == 'Failed' || action == 'Login Failed';

    Color actionColor = const Color(0xFF0284C7);
    Color actionBg = const Color(0xFFF0F9FF);

    if (isFailed) {
      actionColor = const Color(0xFFE53935);
      actionBg = const Color(0xFFFFEBEE);
    } else if (action == 'Login' || action == 'Logout') {
      actionColor = const Color(0xFF10B981);
      actionBg = const Color(0xFFECFDF5);
    } else if (action.contains('Created') || action.contains('Signup')) {
      actionColor = const Color(0xFF8B5CF6);
      actionBg = const Color(0xFFF5F3FF);
    }

    return QanomyCard(
      onTap: () => _toggleExpand(id),
      padding: const EdgeInsets.all(16.0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Always Visible Header: Rank # + Code Circle + User & Firm + Action Tag + Chevron
            Row(
              children: [
                Text(
                  '#$id',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isFailed ? const Color(0xFFFEF2F2) : const Color(0xFFE6F4EA),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    code,
                    style: AppTypography.labelSmall.copyWith(
                      color: isFailed ? const Color(0xFFDC2626) : const Color(0xFF00A980),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 3,
                        children: [
                          Text(
                            user,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              firm,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryNavy,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: AppTypography.bodyInter.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: actionBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    action,
                    style: AppTypography.labelSmall.copyWith(
                      color: actionColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primaryNavy,
                  size: 22,
                ),
              ],
            ),

            // Expanded Details Section
            if (isExpanded) ...[
              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
              const SizedBox(height: 14),

              Row(
                children: [
                  _buildLogStat('Timestamp', time, Icons.access_time_rounded),
                  _buildLogStat('IP Address', ip, Icons.desktop_windows_outlined),
                  _buildLogStat(
                    'Status',
                    status,
                    isFailed ? Icons.cancel_outlined : Icons.check_circle_outline_rounded,
                    color: isFailed ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTION DETAILS',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      details,
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogStat(String label, String value, IconData icon, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTypography.bodyInterSemiBold.copyWith(
              color: color ?? AppColors.primaryNavy,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
