import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';
import 'super_admin_user_details_screen.dart';

class SuperAdminUsersScreen extends StatefulWidget {
  const SuperAdminUsersScreen({super.key});

  @override
  State<SuperAdminUsersScreen> createState() => _SuperAdminUsersScreenState();
}

class _SuperAdminUsersScreenState extends State<SuperAdminUsersScreen> {
  String _filterRole = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Muhammad Awais Iqbal',
      'firm': 'Pwm',
      'role': 'LAWYER',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'phone': '03086283763',
      'joined': '29/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Zubair Ahmed',
      'firm': 'Awan Law Chamber',
      'role': 'LAWYER',
      'email': 'zbhutta5@gmail.com',
      'phone': '03007723984',
      'joined': '29/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Haroon Rasheed',
      'firm': 'Hgg',
      'role': 'LAWYER',
      'email': 'bsha0517@gmail.com',
      'phone': '03303065888',
      'joined': '19/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Waleed Awan',
      'firm': 'NUMERIC COMMUNICATIONS',
      'role': 'LAWYER',
      'email': 'numericcommunication@gmail.com',
      'phone': '03218401979',
      'joined': '17/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Ahsan Khan',
      'firm': 'Khan\'s Firm',
      'role': 'LAWYER',
      'email': 'hariskhan8498@gmail.com',
      'phone': '03433297773',
      'joined': '14/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Fatima',
      'firm': 'Khan\'s Firm',
      'role': 'LAWYER',
      'email': 'noorlioness999@gmail.com',
      'phone': '03076362440',
      'joined': '13/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Asim',
      'firm': 'Khan\'s Firm',
      'role': 'CLERK',
      'email': 'qanomy8@gmail.com',
      'phone': '03076962440',
      'joined': '10/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Ejaz',
      'firm': 'Khan\'s Firm',
      'role': 'LAWYER',
      'email': 'ayesha.ansari12098@gmail.com',
      'phone': '03078362440',
      'joined': '10/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Ejaz',
      'firm': 'Asi',
      'role': 'LAWYER',
      'email': 'ejazi@beyondnorth.net',
      'phone': '03333282832',
      'joined': '07/08/2026',
      'status': 'Active',
    },
    {
      'name': 'Haris khan',
      'firm': 'Khan\'s Firm',
      'role': 'LAWYER',
      'email': 'mahnoorakhtar002@gmail.com',
      'phone': '03051180621',
      'joined': '07/08/2026',
      'status': 'Active',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final filteredUsers = _users.where((user) {
      final matchesRole = _filterRole == 'ALL' || user['role'] == _filterRole;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (user['name'] as String).toLowerCase().contains(q) ||
          (user['firm'] as String).toLowerCase().contains(q) ||
          (user['email'] as String).toLowerCase().contains(q) ||
          (user['phone'] as String).toLowerCase().contains(q);
      return matchesRole && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildMetricsOverview(isMobile),
            _buildSearchAndFilterBar(isMobile),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        'No global users found',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                      itemCount: filteredUsers.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildCollapsibleUserCard(filteredUsers[index], isMobile),
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
              'Global Users',
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
              SizedBox(width: 170, child: _buildMetricTile('Total Users', '10', 'Across 6 firms', const Color(0xFF0284C7), const Color(0xFFF0F9FF))),
              const SizedBox(width: 12),
              SizedBox(width: 160, child: _buildMetricTile('Active Users', '10', '100.0%', const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 12),
              SizedBox(width: 160, child: _buildMetricTile('Blocked Users', '0', '0.0%', const Color(0xFFE53935), const Color(0xFFFFEBEE))),
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
          Expanded(child: _buildMetricTile('Total Users', '10', 'Across 6 firms', const Color(0xFF0284C7), const Color(0xFFF0F9FF))),
          const SizedBox(width: 12),
          Expanded(child: _buildMetricTile('Active Users', '10', '100.0%', const Color(0xFF10B981), const Color(0xFFECFDF5))),
          const SizedBox(width: 12),
          Expanded(child: _buildMetricTile('Blocked Users', '0', '0.0%', const Color(0xFFE53935), const Color(0xFFFFEBEE))),
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

  Widget _buildSearchAndFilterBar(bool isMobile) {
    const filters = ['ALL', 'LAWYER', 'CLERK'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.navBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.bodyInter.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, phone, CNIC or firm...',
                      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 16, color: AppColors.primaryNavy),
                label: Text(
                  'Export',
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: filters.map((f) {
              final isSelected = _filterRole == f;
              return GestureDetector(
                onTap: () => setState(() => _filterRole = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f,
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleUserCard(Map<String, dynamic> user, bool isMobile) {
    final name = user['name'] as String;
    final firm = user['firm'] as String;
    final role = user['role'] as String;
    final email = user['email'] as String;
    final isClerk = role == 'CLERK';

    return QanomyCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SuperAdminUserDetailsScreen(user: user),
          ),
        );
      },
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isClerk ? const Color(0xFFFFF7ED) : const Color(0xFFEEF2FF),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTypography.header.copyWith(
                color: isClerk ? AppColors.princetonOrange : const Color(0xFF6366F1),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isClerk ? const Color(0xFFFFF7ED) : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role,
                        style: AppTypography.labelSmall.copyWith(
                          color: isClerk ? AppColors.princetonOrange : const Color(0xFF6366F1),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Firm: $firm • $email',
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}
