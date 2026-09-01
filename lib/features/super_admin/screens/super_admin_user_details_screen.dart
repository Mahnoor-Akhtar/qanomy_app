import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminUserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const SuperAdminUserDetailsScreen({
    super.key,
    required this.user,
  });

  @override
  State<SuperAdminUserDetailsScreen> createState() => _SuperAdminUserDetailsScreenState();
}

class _SuperAdminUserDetailsScreenState extends State<SuperAdminUserDetailsScreen> {
  int _activeTab = 0; // 0=Overview, 1=Activity Log, 2=Sessions
  late bool _isBlocked;

  @override
  void initState() {
    super.initState();
    final status = (widget.user['status'] as String? ?? 'ACTIVE').toUpperCase();
    _isBlocked = status == 'BLOCKED';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final u = widget.user;

    final String name = u['name'] as String? ?? 'Muhammad Awais Iqbal';
    final String email = u['email'] as String? ?? 'ceopathwaymentor@gmail.com';
    final String phone = u['phone'] as String? ?? '03120102009';
    final String role = u['role'] as String? ?? 'LAWYER';
    final String firm = u['firm'] as String? ?? 'PATH WAY MENTOR (PRIVATE) LIMITED';
    final String joined = u['joined'] as String? ?? '01/09/2026';
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTopAppBar(context, isMobile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserHeroHeaderCard(
                          name: name,
                          email: email,
                          phone: phone,
                          role: role,
                          firm: firm,
                          joined: joined,
                          initial: initial,
                          isMobile: isMobile,
                        ),
                        const SizedBox(height: AppSpacing.s20),
                        _buildTabBar(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildTabContent(
                          context: context,
                          u: u,
                          name: name,
                          email: email,
                          phone: phone,
                          role: role,
                          firm: firm,
                          isMobile: isMobile,
                        ),
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

  Widget _buildTopAppBar(BuildContext context, bool isMobile) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'User Details',
              style: AppTypography.header.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeroHeaderCard({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String firm,
    required String joined,
    required String initial,
    required bool isMobile,
  }) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: AppTypography.header.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 18 : 22,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: _isBlocked ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isBlocked ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _isBlocked ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isBlocked ? 'BLOCKED' : 'ACTIVE',
                                style: AppTypography.labelSmall.copyWith(
                                  color: _isBlocked ? const Color(0xFFDC2626) : const Color(0xFF15803D),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$role • $firm',
                      style: AppTypography.bodyInterSemiBold.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$email   •   $phone',
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Member since $joined',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    final tabs = ['Overview', 'Activity Log', 'Sessions'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _activeTab == index;
            return InkWell(
              onTap: () => setState(() => _activeTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.princetonOrange : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: AppTypography.bodyInterMedium.copyWith(
                    color: isSelected ? AppColors.princetonOrange : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required BuildContext context,
    required Map<String, dynamic> u,
    required String name,
    required String email,
    required String phone,
    required String role,
    required String firm,
    required bool isMobile,
  }) {
    if (_activeTab == 1) {
      return _buildActivityLogTab();
    }
    if (_activeTab == 2) {
      return _buildSessionsTab();
    }

    // Overview Tab (Index 0)
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildOverviewDetailsCard(name: name, email: email, phone: phone, role: role, firm: firm),
          const SizedBox(height: AppSpacing.s20),
          _buildQuickActionsCard(context),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _buildOverviewDetailsCard(name: name, email: email, phone: phone, role: role, firm: firm),
        ),
        const SizedBox(width: AppSpacing.s24),
        Expanded(
          flex: 5,
          child: _buildQuickActionsCard(context),
        ),
      ],
    );
  }

  Widget _buildOverviewDetailsCard({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String firm,
  }) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Profile Details',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          _buildDetailRow('Full Name', name),
          _buildDetailRowWithBadge('Email', email, 'Verified'),
          _buildDetailRowWithBadge('Phone', phone, 'Verified'),
          _buildDetailRow('Role', role),
          _buildDetailRow('Firm', firm),
          _buildDetailRow('Status', _isBlocked ? 'BLOCKED' : 'ACTIVE'),
          _buildDetailRow('Last Login', '-'),
          _buildDetailRow('IP Address', '-'),
          _buildDetailRow('Password Changed', '-'),
          _buildDetailRow('Two-Factor Authentication', 'Disabled'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: AppTypography.bodyInter.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyInterMedium.copyWith(
                color: AppColors.primaryNavy,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithBadge(String label, String value, String badgeText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: AppTypography.bodyInter.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  value,
                  style: AppTypography.bodyInterMedium.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    badgeText,
                    style: AppTypography.labelSmall.copyWith(
                      color: const Color(0xFF047857),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isBlocked = !_isBlocked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_isBlocked ? 'User blocked successfully' : 'User unblocked successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBlocked ? const Color(0xFF10B981) : const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                _isBlocked ? 'Unblock User' : 'Block User',
                style: AppTypography.bodyInterMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                SuperAdminMainLayout.instance?.switchSidebar(7); // Audit Logs tab
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'View Audit Log',
                style: AppTypography.bodyInterMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Note: All actions are logged in Audit Logs.',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogTab() {
    final logs = [
      {
        'id': 1,
        'code': 'MA',
        'user': 'Muhammad Awais Iqbal',
        'action': 'Login',
        'details': 'User logged in successfully to Super Admin Portal',
        'time': '1 Sept 2026, 08:48 AM',
        'ip': '172.71.124.208',
        'status': 'Success',
        'firm': 'PATH WAY MENTOR',
      },
      {
        'id': 2,
        'code': 'MA',
        'user': 'Muhammad Awais Iqbal',
        'action': 'Updated Case',
        'details': 'Case filing draft updated for PATH WAY MENTOR',
        'time': '28 Aug 2026, 04:20 PM',
        'ip': '192.168.1.45',
        'status': 'Success',
        'firm': 'PATH WAY MENTOR',
      },
      {
        'id': 3,
        'code': 'MA',
        'user': 'Muhammad Awais Iqbal',
        'action': 'Created Document',
        'details': 'Uploaded legal contract template Filing_Contract.pdf',
        'time': '25 Aug 2026, 11:15 AM',
        'ip': '192.168.1.45',
        'status': 'Success',
        'firm': 'PATH WAY MENTOR',
      },
    ];

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Activity Audit History',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = logs[index];
              return _buildUserAuditItem(log);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserAuditItem(Map<String, dynamic> log) {
    final id = log['id'];
    final code = log['code'] as String;
    final action = log['action'] as String;
    final details = log['details'] as String;
    final time = log['time'] as String;
    final ip = log['ip'] as String;
    final status = log['status'] as String;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '#$id',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4EA),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  code,
                  style: AppTypography.labelSmall.copyWith(color: Color(0xFF00A980), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log['user'] as String,
                      style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13.5, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      time,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  action,
                  style: AppTypography.labelSmall.copyWith(color: const Color(0xFF00A980), fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('Time: $time', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10.5)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.desktop_windows_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('IP: $ip', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10.5)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 12, color: Color(0xFF10B981)),
                  const SizedBox(width: 4),
                  Text(status, style: AppTypography.labelSmall.copyWith(color: const Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTION DETAILS',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 3),
                Text(
                  details,
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active User Sessions',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.laptop_mac_rounded, size: 24, color: AppColors.primaryNavy),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chrome on Windows (Current Session)',
                      style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'IP Address: 192.168.1.45 • Last active: Just now',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Active',
                  style: AppTypography.labelSmall.copyWith(color: const Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
