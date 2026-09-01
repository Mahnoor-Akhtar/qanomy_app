import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';

class SuperAdminFirmDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> firm;

  const SuperAdminFirmDetailsScreen({
    super.key,
    required this.firm,
  });

  @override
  State<SuperAdminFirmDetailsScreen> createState() => _SuperAdminFirmDetailsScreenState();
}

class _SuperAdminFirmDetailsScreenState extends State<SuperAdminFirmDetailsScreen> {
  int _activeTab = 0; // 0=Overview, 1=Subscription History, 2=Users, 3=Audit Log

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final f = widget.firm;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTopAppBar(context, isMobile, f['name'] as String? ?? 'Firm Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildLeftMainColumn(context, f, isMobile),
                              const SizedBox(height: AppSpacing.s20),
                              _buildRightSideColumn(context, f),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 8, child: _buildLeftMainColumn(context, f, isMobile)),
                              const SizedBox(width: AppSpacing.s24),
                              Expanded(flex: 4, child: _buildRightSideColumn(context, f)),
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

  Widget _buildTopAppBar(BuildContext context, bool isMobile, String firmName) {
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
              'Firm Details',
              style: AppTypography.header.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftMainColumn(BuildContext context, Map<String, dynamic> f, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFirmHeaderCard(f, isMobile),
        const SizedBox(height: AppSpacing.s20),
        if (_activeTab == 0) ...[
          _buildUsageSummarySection(f, isMobile),
          const SizedBox(height: AppSpacing.s20),
          _buildFirmInformationCard(f, isMobile),
        ] else
          _buildTabPlaceholder(_getTabName(_activeTab)),
      ],
    );
  }

  Widget _buildFirmHeaderCard(Map<String, dynamic> f, bool isMobile) {
    final name = f['name'] as String? ?? 'Firm';
    final owner = f['owner'] as String? ?? 'Owner';
    final email = f['email'] as String? ?? 'email@domain.com';
    final phone = f['phone'] as String? ?? '03086283763';
    final status = f['status'] as String? ?? 'ACTIVE';
    final plan = f['plan'] as String? ?? 'Free';

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE8F0FE),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'P',
                  style: AppTypography.header.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 22,
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
                            style: AppTypography.header.copyWith(
                              color: AppColors.primaryNavy,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status == 'ACTIVE' ? 'Active' : status,
                            style: AppTypography.labelSmall.copyWith(
                              color: const Color(0xFF00A980),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            plan,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      owner,
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(email, style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(phone, style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text('—, Pakistan', style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.login_rounded, size: 16, color: Colors.white),
                  label: Text(
                    'Login as Firm',
                    style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sidebarNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          // Inner Tabs Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubTabItem(0, 'Overview'),
                _buildSubTabItem(1, 'Subscription History'),
                _buildSubTabItem(2, 'Users'),
                _buildSubTabItem(3, 'Audit Log'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem(int index, String label) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.princetonOrange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyInterMedium.copyWith(
            color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildUsageSummarySection(Map<String, dynamic> f, bool isMobile) {
    final int users = f['users'] as int? ?? 1;
    final int cases = f['cases'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Usage Summary',
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'This Month',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Last updated: just now',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = isMobile
                ? (constraints.maxWidth - AppSpacing.s12) / 2
                : (constraints.maxWidth - (3 * AppSpacing.s12)) / 4;

            return Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                _buildUsageCard('USERS', '$users / 5', Icons.people_outline, const Color(0xFF10B981), const Color(0xFFECFDF5), users / 5.0, itemWidth),
                _buildUsageCard('CASES', '$cases / 100', Icons.work_outline, const Color(0xFF0284C7), const Color(0xFFF0F9FF), cases / 100.0, itemWidth),
                _buildUsageCard('STORAGE', '0.0 GB / 10 GB', Icons.cloud_outlined, const Color(0xFFF97316), const Color(0xFFFFF7ED), 0.05, itemWidth),
                _buildUsageCard('DOCUMENTS', '0', Icons.description_outlined, const Color(0xFF8B5CF6), const Color(0xFFF5F3FF), 0.0, itemWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildUsageCard(String title, String val, IconData icon, Color color, Color bg, double progress, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            val,
            style: AppTypography.header.copyWith(
              color: AppColors.primaryNavy,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFirmInformationCard(Map<String, dynamic> f, bool isMobile) {
    final name = f['name'] as String? ?? 'Pwm';
    final owner = f['owner'] as String? ?? 'Muhammad Awais Iqbal';
    final email = f['email'] as String? ?? 'awaisiqbalalamgirian@gmail.com';
    final phone = f['phone'] as String? ?? '03086283763';
    final joined = f['joined'] as String? ?? '29/08/2026';
    final status = f['status'] as String? ?? 'ACTIVE';

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Firm Information',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Column(
            children: [
              _buildInfoRow('Firm Name', name, 'Owner', owner),
              const SizedBox(height: 16),
              _buildInfoRow('Email', email, 'Phone', phone),
              const SizedBox(height: 16),
              _buildInfoRow('Address', '—', 'Joined Date', joined),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status == 'ACTIVE' ? 'Active' : status,
                            style: AppTypography.labelSmall.copyWith(
                              color: const Color(0xFF00A980),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('City', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text('—', style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String l1, String v1, String l2, String v2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 4),
              Text(v1, style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l2, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 4),
              Text(v2, style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightSideColumn(BuildContext context, Map<String, dynamic> f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSubscriptionDetailsCard(f),
        const SizedBox(height: AppSpacing.s20),
        _buildActionsCard(context, f),
      ],
    );
  }

  Widget _buildSubscriptionDetailsCard(Map<String, dynamic> f) {
    final plan = f['plan'] as String? ?? 'Free';

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Subscription',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildSubDetailRow('Plan', '$plan Plan'),
          const Divider(height: 20, color: AppColors.border),
          _buildSubDetailRow('Billing Cycle', 'Monthly'),
          const Divider(height: 20, color: AppColors.border),
          _buildSubDetailRow('Amount', 'PKR 0 / month'),
          const Divider(height: 20, color: AppColors.border),
          _buildSubDetailRow('Next Billing Date', '28/09/2026'),
          const Divider(height: 20, color: AppColors.border),
          _buildSubDetailRow('Payment Method', '—'),
          const Divider(height: 20, color: AppColors.border),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Auto Renew', style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12)),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF00A980)),
                  const SizedBox(width: 4),
                  Text('Enabled', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF00A980), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sidebarNavy,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Manage Subscription',
                style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12)),
        Text(value, style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionsCard(BuildContext context, Map<String, dynamic> f) {
    final status = f['status'] as String? ?? 'ACTIVE';

    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Suspend Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.pause_circle_outline, size: 16, color: Color(0xFFD97706)),
              label: Text(
                status == 'SUSPENDED' ? 'Activate Firm' : 'Suspend Firm',
                style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFBEB),
                side: const BorderSide(color: Color(0xFFFDE68A)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Send Warning Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFD97706)),
              label: Text(
                'Send Warning',
                style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFBEB),
                side: const BorderSide(color: Color(0xFFFDE68A)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Delete Firm Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFE53935)),
              label: Text(
                'Delete Firm',
                style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFE53935), fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                side: const BorderSide(color: Color(0xFFFFCDD2)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          const SizedBox(height: 14),
          Center(
            child: Text(
              'All actions are logged in Audit Log',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPlaceholder(String tabName) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.folder_open_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              '$tabName Tab',
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Records and detailed logs for $tabName will appear here',
              style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0: return 'Overview';
      case 1: return 'Subscription History';
      case 2: return 'Users';
      case 3: return 'Audit Log';
      default: return 'Overview';
    }
  }
}
