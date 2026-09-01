import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import 'super_admin_main_layout.dart';

class SuperAdminFirmsScreen extends StatefulWidget {
  const SuperAdminFirmsScreen({super.key});

  @override
  State<SuperAdminFirmsScreen> createState() => _SuperAdminFirmsScreenState();
}

class _SuperAdminFirmsScreenState extends State<SuperAdminFirmsScreen> {
  String _filterStatus = 'ALL';

  final List<Map<String, dynamic>> _firms = [
    {'name': 'Khan & Associates', 'owner': 'Ayesha Khan', 'lawyers': 8, 'tier': 'Premium', 'status': 'ACTIVE', 'joined': 'Jan 2024', 'email': 'ayesha@khanlaw.com'},
    {'name': 'Multan Legal Hub', 'owner': 'Ejaz Ahmed', 'lawyers': 3, 'tier': 'Standard', 'status': 'ACTIVE', 'joined': 'Mar 2024', 'email': 'ejaz@multanlaw.com'},
    {'name': 'DHA Law Chambers', 'owner': 'M. Haris', 'lawyers': 12, 'tier': 'Premium', 'status': 'ACTIVE', 'joined': 'Feb 2024', 'email': 'haris@dhachambers.com'},
    {'name': 'Karachi Cyber Desk', 'owner': 'Fatima Shah', 'lawyers': 5, 'tier': 'Standard', 'status': 'SUSPENDED', 'joined': 'Apr 2024', 'email': 'fatima@cyberdesk.com'},
    {'name': 'Lahore Legal Aid', 'owner': 'Ali Raza', 'lawyers': 2, 'tier': 'Trial', 'status': 'TRIAL', 'joined': 'Aug 2024', 'email': 'ali@lahoreaid.com'},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final filtered = _filterStatus == 'ALL'
        ? _firms
        : _firms.where((f) => f['status'] == _filterStatus).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildFilterBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.s16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _buildFirmCard(filtered[index], isMobile),
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
      padding: const EdgeInsets.fromLTRB(12, 52, 16, 24),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text('Firms',
                style: AppTypography.header.copyWith(color: Colors.white, fontSize: 26)),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.princetonOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    const filters = ['ALL', 'ACTIVE', 'SUSPENDED', 'TRIAL'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: filters.map((f) {
          final isSelected = _filterStatus == f;
          return GestureDetector(
            onTap: () => setState(() => _filterStatus = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(f,
                  style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFirmCard(Map<String, dynamic> f, bool isMobile) {
    final status = f['status'] as String;
    final tier = f['tier'] as String;

    Color statusColor;
    Color statusBgColor;
    switch (status) {
      case 'ACTIVE':
        statusColor = const Color(0xFF00A980);
        statusBgColor = const Color(0xFFE8F5E9);
        break;
      case 'SUSPENDED':
        statusColor = const Color(0xFFE53935);
        statusBgColor = const Color(0xFFFFEBEE);
        break;
      default:
        statusColor = const Color(0xFFF97316);
        statusBgColor = const Color(0xFFFFF3E0);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE8F0FE),
                child: Text(
                  (f['name'] as String)[0],
                  style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f['name'] as String,
                        style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 15),
                        overflow: TextOverflow.ellipsis),
                    Text(f['email'] as String,
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
                child: Text(status,
                    style: AppTypography.labelSmall.copyWith(
                        color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfo('Owner', f['owner'] as String),
              _buildInfo('Lawyers', '${f['lawyers']}'),
              _buildInfo('Tier', tier),
              _buildInfo('Joined', f['joined'] as String),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildAction('View', Icons.visibility_outlined, AppColors.blueGreen),
              const SizedBox(width: 8),
              _buildAction(
                status == 'SUSPENDED' ? 'Activate' : 'Suspend',
                status == 'SUSPENDED' ? Icons.check_circle_outline : Icons.block_outlined,
                status == 'SUSPENDED' ? const Color(0xFF00A980) : const Color(0xFFE53935),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildAction(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
