import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../navigation/main_layout.dart';
import 'team_member_details_screen.dart';
import 'add_team_member_screen.dart';



class TeamMembersScreen extends StatelessWidget {
  const TeamMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: QanomyAppBar(
        title: 'Team Members',
        subtitle: 'Manage your law firm team and their access',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeamMemberScreen()),
          );
        },
        backgroundColor: const Color(0xFFFF8A00),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopStatsRow(),
            const SizedBox(height: AppSpacing.s24),
            _buildMainContainer(context),
          ],
        ),
      ),
    );
  }



  Widget _buildTopStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('Total Members', '4', Icons.person_outline, const Color(0xFF00A980)),
          const SizedBox(width: 16),
          _buildStatCard('Lawyers', '3', Icons.work_outline, const Color(0xFF42A5F5)),
          const SizedBox(width: 16),
          _buildStatCard('Clerks', '1', Icons.people_outline, const Color(0xFFAB47BC)),
          const SizedBox(width: 16),
          _buildStatCard('Read-only Users', '0', Icons.person_outline, const Color(0xFFFF9800)),
          const SizedBox(width: 16),
          _buildStatCard('Active', '0', Icons.check_circle_outline, const Color(0xFF26A69A)),
          const SizedBox(width: 16),
          _buildStatCard('Inactive', '0', Icons.cancel_outlined, const Color(0xFFEF5350)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color baseColor) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: baseColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilterBar(context),
        const SizedBox(height: AppSpacing.s24),
        _buildTeamTable(),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search by name, email, phone...',
                  hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: const Color(0xFF00A980)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (!isMobile) ...[
              _buildDropdown('All Roles'),
              const SizedBox(width: 12),
              _buildDropdown('All Status'),
              const SizedBox(width: 12),
              _buildFilterButton(Icons.filter_list, 'More Filters'),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hint, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
        ],
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTeamTable() {
    final members = [
      {'id': '1', 'initial': 'F', 'name': 'Fatima', 'subtitle': 'LAWYER', 'email': 'noorlioness999@gmail.com', 'phone': '03076362440', 'status': 'ACTIVE', 'joined': '13/08/2026'},
      {'id': '2', 'initial': 'A', 'name': 'Asim', 'subtitle': 'CLERK', 'email': 'qanomy8@gmail.com', 'phone': '03076962440', 'status': 'ACTIVE', 'joined': '10/08/2026'},
      {'id': '3', 'initial': 'E', 'name': 'Ejaz', 'subtitle': 'LAWYER', 'email': 'ayesha.ansari12098@gmail.com', 'phone': '03078362440', 'status': 'ACTIVE', 'joined': '10/08/2026'},
      {'id': '4', 'initial': 'H', 'name': 'Haris khan', 'subtitle': 'Owner', 'email': 'mahnoorakhtar002@gmail.com', 'phone': '03051180621', 'status': 'ACTIVE', 'joined': '07/08/2026'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final m = members[index];
        return _buildTeamMemberItem(context, m['id']!, m['initial']!, m['name']!, m['subtitle']!, m['email']!, m['phone']!, m['status']!, m['joined']!);
      },
    );
  }

  Widget _buildTeamMemberItem(BuildContext context, String id, String initial, String name, String subtitle, String email, String phone, String status, String joined) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamMemberDetailsScreen(
                  name: name,
                  role: subtitle,
                  email: email,
                  phone: phone,
                  status: status,
                  joined: joined,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFE8F5E9),
                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(Icons.work_outline, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(subtitle.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.tag, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text('ID: $id', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryNavy),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
