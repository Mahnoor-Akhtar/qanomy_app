import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class TeamMemberDetailsScreen extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String status;
  final String joined;
  
  const TeamMemberDetailsScreen({
    super.key,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.status,
    required this.joined,
  });

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
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.s24),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: AppSpacing.s24),
          _buildDetailRow('Email:', email),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow('Phone:', phone),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow('Status:', status, valueColor: const Color(0xFFE91E63)),
          const SizedBox(height: AppSpacing.s16),
          _buildDetailRow('Joined:', joined),
          const SizedBox(height: AppSpacing.s24),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: AppSpacing.s24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final roleColor = role.toUpperCase() == 'LAWYER' ? const Color(0xFF00A980) : const Color(0xFF42A5F5);

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
              Text(name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 20)),
              const SizedBox(height: 4),
              Text(role.toUpperCase(), style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: roleColor.withOpacity(0.3)),
          ),
          child: Text(
            role.toUpperCase(),
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
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryNavy),
            label: Text('Edit Role', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.border.withOpacity(0.5)),
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
            onPressed: () {},
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE91E63), size: 20),
            splashRadius: 24,
          ),
        ),
      ],
    );
  }
}
