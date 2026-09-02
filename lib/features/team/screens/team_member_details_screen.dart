import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/team_member_model.dart';
import '../services/team_service.dart';
import '../widgets/edit_team_member_dialog.dart';

class TeamMemberDetailsScreen extends StatefulWidget {
  final TeamMemberModel? member;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String status;
  final String joined;
  final String? id;

  const TeamMemberDetailsScreen({
    super.key,
    this.member,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.status,
    required this.joined,
    this.id,
  });

  @override
  State<TeamMemberDetailsScreen> createState() => _TeamMemberDetailsScreenState();
}

class _TeamMemberDetailsScreenState extends State<TeamMemberDetailsScreen> {
  late String _currentName;
  late String _currentRole;
  late String _currentEmail;
  late String _currentPhone;
  late String _currentStatus;
  late String _currentJoined;
  late String _memberId;

  @override
  void initState() {
    super.initState();
    _currentName = widget.member?.name ?? widget.name;
    _currentRole = widget.member?.role ?? widget.role;
    _currentEmail = widget.member?.email ?? widget.email;
    _currentPhone = widget.member?.phone ?? widget.phone;
    _currentStatus = widget.member?.status ?? widget.status;
    _currentJoined = widget.member?.joined ?? widget.joined;
    _memberId = widget.member?.id ?? widget.id ?? _currentName;
  }

  void _showEditRoleDialog(BuildContext context) {
    final memberModel = widget.member ??
        TeamMemberModel(
          id: _memberId,
          initial: _currentName.isNotEmpty ? _currentName[0].toUpperCase() : 'M',
          name: _currentName,
          role: _currentRole,
          email: _currentEmail,
          phone: _currentPhone,
          status: _currentStatus,
          joined: _currentJoined,
        );

    showDialog(
      context: context,
      builder: (context) => EditTeamMemberDialog(
        member: memberModel,
        onSave: (updated) {
          setState(() {
            _currentName = updated.name;
            _currentRole = updated.role;
            _currentEmail = updated.email;
            _currentPhone = updated.phone;
            _currentStatus = updated.status;
          });
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFE91E63)),
              const SizedBox(width: 10),
              Text('Delete Member', style: AppTypography.titleMedium.copyWith(color: const Color(0xFFE91E63))),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "$_currentName" from team members?\n\nThis action cannot be undone.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
            ),
            ElevatedButton(
              onPressed: () {
                final existingIndex = TeamService.instance.value.indexWhere((m) => m.id == _memberId || m.name == _currentName);
                if (existingIndex != -1) {
                  TeamService.instance.deleteMember(TeamService.instance.value[existingIndex].id);
                } else {
                  TeamService.instance.deleteMember(_memberId);
                }

                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to Team members screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Member "$_currentName" deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text('Delete Member', style: AppTypography.bodyInterSemiBold.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Team Member Details', style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildDetailsCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.s24),
          Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: AppSpacing.s24),
          _buildDetailRow('Email:', _currentEmail),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow('Phone:', _currentPhone),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow(
            'Status:',
            _currentStatus,
            valueColor: _currentStatus.toUpperCase() == 'ACTIVE'
                ? const Color(0xFF00A980)
                : const Color(0xFFE91E63),
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow('Joined:', _currentJoined),
          const SizedBox(height: AppSpacing.s24),
          Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: AppSpacing.s24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final roleColor = _currentRole.toUpperCase() == 'LAWYER'
        ? const Color(0xFF00A980)
        : _currentRole.toUpperCase() == 'OWNER'
            ? AppColors.princetonOrange
            : const Color(0xFF42A5F5);

    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Color(0xFFE8F5E9),
          backgroundImage: AssetImage('assets/images/default_avatar.png'),
        ),
        const SizedBox(width: AppSpacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentName, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 20)),
              const SizedBox(height: 4),
              Text(_currentRole.toUpperCase(), style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: roleColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: roleColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            _currentRole.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(color: roleColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary, fontSize: 15)),
        Text(
          value,
          style: AppTypography.bodyInterMedium.copyWith(
            color: valueColor ?? AppColors.primaryNavy,
            fontSize: 15,
            fontWeight: valueColor != null ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showEditRoleDialog(context),
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryNavy),
            label: Text('Edit Role', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC), // Light pink background
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF48FB1), width: 1),
          ),
          child: IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE91E63), size: 20),
            splashRadius: 24,
          ),
        ),
      ],
    );
  }
}
