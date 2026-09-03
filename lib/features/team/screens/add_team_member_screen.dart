import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/api_service.dart';
import '../models/team_member_model.dart';
import '../services/team_service.dart';

class TeamPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    var newString = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 3) {
        newString += '-';
      }
      newString += text[i];
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class AddTeamMemberScreen extends StatefulWidget {
  final TeamMemberModel? initialMember;

  const AddTeamMemberScreen({super.key, this.initialMember});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  String _selectedRole = 'Lawyer';
  final List<String> _roles = ['Lawyer', 'Clerk', 'Read-only User', 'Owner'];

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
  void initState() {
    super.initState();
    if (widget.initialMember != null) {
      final m = widget.initialMember!;
      _nameController.text = m.name;
      _emailController.text = m.email;
      _phoneController.text = m.phone.startsWith('0') ? m.phone.substring(1) : m.phone;
      _designationController.text = m.designation;
      
      final matchedRole = _roles.firstWhere(
        (r) => r.toLowerCase() == m.role.toLowerCase(),
        orElse: () => 'Lawyer',
      );
      _selectedRole = matchedRole;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  Future<void> _saveTeamMember() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a role'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final isEditing = widget.initialMember != null;
      final rawName = _nameController.text.trim();
      final nameParts = rawName.split(' ');
      final firstName = nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0] : rawName;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Member';
      final roleUpper = _selectedRole.toUpperCase();

      final userPayload = {
        'firstName': firstName,
        'lastName': lastName,
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': 'Password@123',
        'role': roleUpper,
      };

      final initial = rawName.isNotEmpty ? rawName[0].toUpperCase() : 'M';
      final now = DateTime.now();
      final formattedDate = widget.initialMember?.joined ??
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

      final member = TeamMemberModel(
        id: isEditing ? widget.initialMember!.id : DateTime.now().millisecondsSinceEpoch.toString().substring(7),
        initial: initial,
        name: rawName,
        role: roleUpper,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        designation: _designationController.text.trim(),
        status: widget.initialMember?.status ?? 'ACTIVE',
        joined: formattedDate,
      );

      if (!isEditing) {
        final res = await ApiService.createUser(userPayload);
        TeamService.instance.addMember(member);
        if (res['success'] == true) {
          await TeamService.instance.fetchTeamFromBackend();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Team member "$rawName" stored in database successfully!'),
                backgroundColor: const Color(0xFF00A980),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          }
          return;
        }
      }

      if (isEditing) {
        final updatePayload = {
          'firstName': firstName,
          'lastName': lastName,
          if (_emailController.text.trim().isNotEmpty) 'email': _emailController.text.trim(),
          if (_phoneController.text.trim().isNotEmpty) 'phone': _phoneController.text.trim(),
          'role': roleUpper,
          if (_designationController.text.trim().isNotEmpty) 'designation': _designationController.text.trim(),
        };
        final res = await ApiService.updateUser(widget.initialMember!.id, updatePayload);
        if (res['success'] == true) {
          await TeamService.instance.fetchTeamFromBackend();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Team member "$rawName" updated in database!'),
                backgroundColor: const Color(0xFF00A980),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          }
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team member "${member.name}" ${isEditing ? "updated" : "added"} successfully!'),
          backgroundColor: const Color(0xFF00A980),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, member);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialMember != null;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(context),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.5))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  side: BorderSide(color: AppColors.border.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
              ),
              const SizedBox(width: AppSpacing.s16),
              ElevatedButton.icon(
                onPressed: _saveTeamMember,
                icon: const Icon(Icons.save_outlined, size: 18, color: Colors.white),
                label: Text(
                  isEditing ? 'Update Member' : 'Save Member',
                  style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A980),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isEditing = widget.initialMember != null;

    return AppBar(
      backgroundColor: AppColors.sidebarNavy,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        isEditing ? 'Edit Team Member' : 'Add New Member',
        style: AppTypography.header.copyWith(color: Colors.white, fontSize: 20),
        overflow: TextOverflow.ellipsis,
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          'Full Name',
          true,
          'Enter full name',
          controller: _nameController,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
        ),
        const SizedBox(height: AppSpacing.s24),

        _buildDropdownField('Role', true, _selectedRole, _roles, (val) => setState(() => _selectedRole = val!)),
        const SizedBox(height: AppSpacing.s24),

        _buildTextField(
          'Email',
          true,
          'Enter email address',
          controller: _emailController,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter email' : null,
        ),
        const SizedBox(height: AppSpacing.s24),

        _buildPasswordField(
          'Password',
          true,
          'Enter password',
          _passwordController,
          _obscurePassword,
          () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter password' : null,
        ),
        const SizedBox(height: AppSpacing.s24),

        _buildPasswordField(
          'Confirm Password',
          true,
          'Confirm password',
          _confirmPasswordController,
          _obscureConfirmPassword,
          () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        const SizedBox(height: AppSpacing.s24),

        _buildPhoneField('Phone / WhatsApp', true),
        const SizedBox(height: AppSpacing.s24),

        _buildTextField(
          'Designation',
          false,
          'e.g. Senior Lawyer',
          controller: _designationController,
        ),
        const SizedBox(height: AppSpacing.s24),

        _buildInfoBox(),
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

  Widget _buildTextField(
    String label,
    bool isRequired,
    String hintText, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextFormField(
          controller: controller,
          validator: validator,
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
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: const BorderSide(color: Color(0xFF00A980)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    bool isRequired,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    final safeValue = options.firstWhere(
      (opt) => opt.toUpperCase() == currentValue.toUpperCase(),
      orElse: () => options.first,
    );

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
              value: safeValue,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    bool isRequired,
    String hintText,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggle, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
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
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: const BorderSide(color: Color(0xFF00A980)),
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
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [TeamPhoneInputFormatter()],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter phone number';
                    final clean = v.replaceAll('-', '');
                    if (clean.length < 10) return 'Phone must be 10 digits after +92 (e.g. 300-1234567)';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: '300-1234567',
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
        color: const Color(0xFFF0F0FF),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        final categories = [
          _buildPermissionCategory('Dashboard', ['View Dashboard']),
          _buildPermissionCategory('Cases', ['View Cases', 'Add / Edit Cases', 'Delete Cases']),
          _buildPermissionCategory('Hearings', ['View Hearings', 'Add / Edit Hearings', 'Mark Hearing Done']),
          _buildPermissionCategory('Documents', ['View Documents', 'Upload Documents', 'Delete Documents']),
          _buildPermissionCategory('Clients', ['View Clients', 'Add / Edit Clients', 'Delete Clients']),
          _buildPermissionCategory('Billing & Invoices', ['View Invoices', 'Create Invoices']),
          _buildPermissionCategory('Team & Reports', ['View Team', 'View Reports']),
          _buildPermissionCategory('Notifications & Settings', ['View Notifications', 'View Settings']),
        ];

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories
                .map((cat) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: cat,
                    ))
                .toList(),
          );
        }

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: categories
              .map((cat) => SizedBox(
                    width: (constraints.maxWidth - 48) / 3,
                    child: cat,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildPermissionCategory(String title, List<String> permissions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...permissions.map((p) => _buildCheckbox(p)),
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
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyInterMedium.copyWith(
                  color: isChecked ? AppColors.primaryNavy : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
