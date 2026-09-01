import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../models/team_member_model.dart';
import '../services/team_service.dart';
import 'team_member_details_screen.dart';
import 'add_team_member_screen.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = 'All Roles';
  String _selectedStatusFilter = 'All Status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddMemberScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTeamMemberScreen()),
    );
  }

  List<TeamMemberModel> _filterMembers(List<TeamMemberModel> members) {
    final query = _searchController.text.toLowerCase().trim();
    return members.where((m) {
      final matchesSearch = query.isEmpty ||
          m.name.toLowerCase().contains(query) ||
          m.email.toLowerCase().contains(query) ||
          m.phone.toLowerCase().contains(query);

      final matchesRole = _selectedRoleFilter == 'All Roles' ||
          m.role.toUpperCase() == _selectedRoleFilter.toUpperCase();

      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          m.status.toUpperCase() == _selectedStatusFilter.toUpperCase();

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Team Members',
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: _openAddMemberScreen,
        backgroundColor: const Color(0xFFFF8A00),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: ValueListenableBuilder<List<TeamMemberModel>>(
        valueListenable: TeamService.instance,
        builder: (context, allMembers, _) {
          final totalCount = allMembers.length;
          final lawyersCount = allMembers.where((m) => m.role.toUpperCase() == 'LAWYER').length;
          final clerksCount = allMembers.where((m) => m.role.toUpperCase() == 'CLERK').length;
          final readOnlyCount = allMembers.where((m) => m.role.toUpperCase().contains('READ-ONLY')).length;
          final activeCount = allMembers.where((m) => m.status.toUpperCase() == 'ACTIVE').length;
          final inactiveCount = allMembers.where((m) => m.status.toUpperCase() == 'INACTIVE').length;

          final filteredMembers = _filterMembers(allMembers);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopStatsRow(
                  total: totalCount,
                  lawyers: lawyersCount,
                  clerks: clerksCount,
                  readOnly: readOnlyCount,
                  active: activeCount,
                  inactive: inactiveCount,
                ),
                const SizedBox(height: AppSpacing.s24),
                _buildMainContainer(context, filteredMembers),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopStatsRow({
    required int total,
    required int lawyers,
    required int clerks,
    required int readOnly,
    required int active,
    required int inactive,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('Total Members', '$total', Icons.person_outline, const Color(0xFF00A980)),
          const SizedBox(width: 16),
          _buildStatCard('Lawyers', '$lawyers', Icons.work_outline, const Color(0xFF42A5F5)),
          const SizedBox(width: 16),
          _buildStatCard('Clerks', '$clerks', Icons.people_outline, const Color(0xFFAB47BC)),
          const SizedBox(width: 16),
          _buildStatCard('Read-only Users', '$readOnly', Icons.person_outline, const Color(0xFFFF9800)),
          const SizedBox(width: 16),
          _buildStatCard('Active', '$active', Icons.check_circle_outline, const Color(0xFF26A69A)),
          const SizedBox(width: 16),
          _buildStatCard('Inactive', '$inactive', Icons.cancel_outlined, const Color(0xFFEF5350)),
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

  Widget _buildMainContainer(BuildContext context, List<TeamMemberModel> filteredMembers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilterBar(context),
        const SizedBox(height: AppSpacing.s24),
        _buildTeamTable(filteredMembers),
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
                controller: _searchController,
                onChanged: (_) => setState(() {}),
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
                    borderSide: const BorderSide(color: Color(0xFF00A980)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (!isMobile) ...[
              _buildDropdown(
                _selectedRoleFilter,
                ['All Roles', 'Lawyer', 'Clerk', 'Read-only User', 'Owner'],
                (val) => setState(() => _selectedRoleFilter = val!),
              ),
              const SizedBox(width: 12),
              _buildDropdown(
                _selectedStatusFilter,
                ['All Status', 'Active', 'Inactive'],
                (val) => setState(() => _selectedStatusFilter = val!),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String value, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(value) ? value : options.first,
          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13),
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
        ),
      ),
    );
  }

  Widget _buildTeamTable(List<TeamMemberModel> members) {
    if (members.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Text(
          'No team members found',
          style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final m = members[index];
        return _buildTeamMemberItem(context, m);
      },
    );
  }

  Widget _buildTeamMemberItem(BuildContext context, TeamMemberModel member) {
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
                  name: member.name,
                  role: member.role,
                  email: member.email,
                  phone: member.phone,
                  status: member.status,
                  joined: member.joined,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE8F5E9),
                  child: Text(
                    member.initial,
                    style: AppTypography.titleMedium.copyWith(color: const Color(0xFF00A980), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(Icons.work_outline, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(member.role.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.tag, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text('ID: ${member.id}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
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
