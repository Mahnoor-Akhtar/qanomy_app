import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';

class AddTeamMemberScreen extends StatefulWidget {
  const AddTeamMemberScreen({super.key});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  final Map<String, bool> _permissions = {
    'View Dashboard': true,
    'View Cases': true,
    'Add / Edit Cases': true,
    'Delete Cases': false,
    'View Hearings': true,
    'Add / Edit Hearings': true,
    'Mark Hearing Done': true,
    'View Documents': true,
    'Upload Documents': true,
    'Delete Documents': false,
    'View Clients': true,
    'Add / Edit Clients': true,
    'Delete Clients': false,
    'View Invoices': true,
    'Create Invoices': false,
    'View Team': true,
    'View Reports': true,
    'View Notifications': true,
    'View Settings': true,
  };

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainContainer(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.sidebarNavy,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text('Add New Member', style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: Colors.white70)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A980),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Text('Save', style: AppTypography.bodyInterMedium.copyWith(color: Colors.white)),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18)),
          const SizedBox(height: AppSpacing.s24),
          _buildPersonalInformationForm(context),
          const SizedBox(height: AppSpacing.s32),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: AppSpacing.s32),
          Text('Portal Permissions', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18)),
          const SizedBox(height: AppSpacing.s24),
          _buildPermissionsGrid(context),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationForm(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    Widget buildRow(Widget child1, Widget child2) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child1,
            const SizedBox(height: AppSpacing.s16),
            child2,
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child1),
            const SizedBox(width: AppSpacing.s32),
            Expanded(child: child2),
          ],
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRow(
          _buildTextField('Full Name', true, 'Enter full name'),
          _buildDropdownField('Role', true, 'Lawyer'),
        ),
        const SizedBox(height: AppSpacing.s24),
        buildRow(
          _buildTextField('Email', true, 'Enter email address'),
          _buildPasswordField('Password', true, 'Enter password', _obscurePassword, () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          }),
        ),
        const SizedBox(height: AppSpacing.s24),
        buildRow(
          _buildPhoneField('Phone / WhatsApp', true),
          _buildPasswordField('Confirm Password', true, 'Confirm password', _obscureConfirmPassword, () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          }),
        ),
        const SizedBox(height: AppSpacing.s24),
        buildRow(
          _buildTextField('Designation', false, 'e.g. Senior Lawyer'),
          _buildInfoBox(),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13),
          children: [
            if (isRequired)
              TextSpan(
                text: ' *',
                style: AppTypography.bodyInterMedium.copyWith(color: Colors.red, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool isRequired, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF00A980)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, bool isRequired, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: hintText,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              items: [hintText].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, bool isRequired, String hintText, bool obscureText, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF00A980)),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(String label, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border.withOpacity(0.5))),
                ),
                child: Row(
                  children: [
                    Text('PK +92', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF00A980))),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Login credentials will be sent to the member's email & WhatsApp.",
              style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF1565C0), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsGrid(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    Widget buildRow(List<Widget> children) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 24), child: c)).toList(),
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children.map((c) => Expanded(child: c)).toList(),
        );
      }
    }

    return Column(
      children: [
        buildRow([
          _buildPermissionCategory('Dashboard', ['View Dashboard']),
          _buildPermissionCategory('Documents', ['View Documents', 'Upload Documents', 'Delete Documents']),
          _buildPermissionCategory('Team & Reports', ['View Team', 'View Reports']),
        ]),
        const SizedBox(height: 24),
        buildRow([
          _buildPermissionCategory('Cases', ['View Cases', 'Add / Edit Cases', 'Delete Cases']),
          _buildPermissionCategory('Clients', ['View Clients', 'Add / Edit Clients', 'Delete Clients']),
          _buildPermissionCategory('Notifications & Settings', ['View Notifications', 'View Settings']),
        ]),
        const SizedBox(height: 24),
        buildRow([
          _buildPermissionCategory('Hearings', ['View Hearings', 'Add / Edit Hearings', 'Mark Hearing Done']),
          _buildPermissionCategory('Billing & Invoices', ['View Invoices', 'Create Invoices']),
          const SizedBox(), // Empty space for alignment
        ]),
      ],
    );
  }

  Widget _buildPermissionCategory(String title, List<String> permissions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...permissions.map((p) => _buildCheckbox(p)).toList(),
      ],
    );
  }

  Widget _buildCheckbox(String label) {
    final isChecked = _permissions[label] ?? false;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _permissions[label] = !isChecked;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF00A980) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked ? const Color(0xFF00A980) : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.bodyInterMedium.copyWith(
                color: isChecked ? AppColors.primaryNavy : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
