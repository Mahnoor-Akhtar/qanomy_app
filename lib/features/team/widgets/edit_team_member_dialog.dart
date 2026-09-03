import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/team_member_model.dart';
import '../services/team_service.dart';

class EditTeamMemberDialog extends StatefulWidget {
  final TeamMemberModel member;
  final Function(TeamMemberModel updatedMember) onSave;

  const EditTeamMemberDialog({
    super.key,
    required this.member,
    required this.onSave,
  });

  @override
  State<EditTeamMemberDialog> createState() => _EditTeamMemberDialogState();
}

class _EditTeamMemberDialogState extends State<EditTeamMemberDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _designationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  late String _selectedStatus;
  late String _selectedRole;

  final Map<String, String> _roleDescriptions = {
    'LAWYER': 'Lawyers can manage assigned cases, hearings, documents and view reports.',
    'CLERK': 'Clerks can view cases, schedule hearings, and upload court documents.',
    'OWNER': 'Full administrative access to all modules, billing, team, and firm settings.',
    'READ-ONLY': 'Read-only access across assigned cases and firm calendar.',
  };

  late Map<String, Map<String, dynamic>> _permissionsList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _nameController = TextEditingController(text: widget.member.name);
    _designationController = TextEditingController(text: widget.member.designation);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneController = TextEditingController(text: widget.member.phone);

    _selectedStatus = widget.member.status.toUpperCase() == 'ACTIVE' ? 'Active' : 'Inactive';
    _selectedRole = widget.member.role.toUpperCase();
    if (!_roleDescriptions.containsKey(_selectedRole)) {
      _selectedRole = 'LAWYER';
    }

    _initPermissions();
  }

  void _initPermissions() {
    _permissionsList = {
      'Dashboard': {'View Dashboard': widget.member.permissions['View Dashboard'] ?? true},
      'Cases': {
        'View Cases': widget.member.permissions['View Cases'] ?? true,
        'Add / Edit Cases': widget.member.permissions['Add / Edit Cases'] ?? true,
        'Delete Cases': widget.member.permissions['Delete Cases'] ?? false,
      },
      'Hearings': {
        'View Hearings': widget.member.permissions['View Hearings'] ?? true,
        'Add / Edit Hearings': widget.member.permissions['Add / Edit Hearings'] ?? true,
        'Mark Hearing Done': widget.member.permissions['Mark Hearing Done'] ?? true,
      },
      'Documents': {
        'View Documents': widget.member.permissions['View Documents'] ?? true,
        'Upload Documents': widget.member.permissions['Upload Documents'] ?? true,
        'Delete Documents': widget.member.permissions['Delete Documents'] ?? false,
      },
      'Clients': {
        'View Clients': widget.member.permissions['View Clients'] ?? true,
        'Add / Edit Clients': widget.member.permissions['Add / Edit Clients'] ?? true,
        'Delete Clients': widget.member.permissions['Delete Clients'] ?? false,
      },
      'Billing & Invoices': {
        'View Invoices': widget.member.permissions['View Invoices'] ?? true,
        'Create Invoices': widget.member.permissions['Create Invoices'] ?? false,
      },
      'Team': {'View Team': widget.member.permissions['View Team'] ?? true},
      'Reports': {'View Reports': widget.member.permissions['View Reports'] ?? true},
      'Notifications': {'View Notifications': widget.member.permissions['View Notifications'] ?? true},
      'Settings': {'View Settings': widget.member.permissions['View Settings'] ?? true},
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final Map<String, bool> flatPermissions = {};
      _permissionsList.forEach((_, perms) {
        perms.forEach((key, val) {
          flatPermissions[key] = val as bool;
        });
      });

      final updatedMember = TeamMemberModel(
        id: widget.member.id,
        initial: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()[0].toUpperCase()
            : 'M',
        name: _nameController.text.trim(),
        role: _selectedRole,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        designation: _designationController.text.trim(),
        status: _selectedStatus.toUpperCase(),
        joined: widget.member.joined,
        permissions: flatPermissions,
      );

      TeamService.instance.updateMember(updatedMember);
      widget.onSave(updatedMember);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member "${updatedMember.name}" updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Team Member',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF00A980),
                indicatorWeight: 3,
                labelColor: const Color(0xFF00A980),
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(text: 'Profile Details'),
                  Tab(text: 'Role & Permissions'),
                ],
              ),
            ),

            // Tab View Body
            Expanded(
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileDetailsTab(),
                    _buildRoleAndPermissionsTab(),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A980),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: AppTypography.bodyInterSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              if (isMobile) {
                return Column(
                  children: [
                    _buildField('Full Name', _nameController, isRequired: true),
                    const SizedBox(height: 16),
                    _buildField('Designation', _designationController, hint: 'e.g. Senior Lawyer'),
                    const SizedBox(height: 16),
                    _buildField('Email', _emailController, isRequired: true),
                    const SizedBox(height: 16),
                    _buildStatusDropdown(),
                    const SizedBox(height: 16),
                    _buildField('Phone / WhatsApp', _phoneController),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildField('Full Name', _nameController, isRequired: true)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildField('Designation', _designationController, hint: 'e.g. Senior Lawyer')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildField('Email', _emailController, isRequired: true)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildStatusDropdown()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildField('Phone / WhatsApp', _phoneController)),
                      const SizedBox(width: 20),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleAndPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role & Role Description Header Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final roleOptions = ['LAWYER', 'CLERK', 'OWNER', 'READ-ONLY'];
              final normalizedRole = roleOptions.firstWhere(
                (opt) => opt.toUpperCase() == _selectedRole.toUpperCase(),
                orElse: () => roleOptions.first,
              );

              final roleDropdown = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Role', style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: normalizedRole,
                    isExpanded: true,
                    decoration: _getInputDecoration(color: const Color(0xFF00A980)),
                    items: roleOptions.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role, style: AppTypography.bodyInterSemiBold.copyWith(color: const Color(0xFF00A980))),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedRole = val);
                      }
                    },
                  ),
                ],
              );

              final roleDesc = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Role Description', style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.pageBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      _roleDescriptions[_selectedRole] ?? '',
                      style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                    ),
                  ),
                ],
              );

              if (isMobile) {
                return Column(
                  children: [
                    roleDropdown,
                    const SizedBox(height: 16),
                    roleDesc,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: roleDropdown),
                  const SizedBox(width: 20),
                  Expanded(child: roleDesc),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Permissions Header Title
          Text(
            'Permissions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 12),

          // Permissions Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: AppColors.pageBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('MODULE', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text('PERMISSION', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text('ACCESS', textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),

                  // Table Content Rows
                  ..._permissionsList.entries.expand((entry) {
                    final moduleName = entry.key;
                    final permissionsMap = entry.value;
                    final permEntries = permissionsMap.entries.toList();

                    return List.generate(permEntries.length, (idx) {
                      final permName = permEntries[idx].key;
                      final isChecked = permEntries[idx].value as bool;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                idx == 0 ? moduleName : '',
                                style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                permName,
                                style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Center(
                                child: Checkbox(
                                  value: isChecked,
                                  activeColor: const Color(0xFF00A980),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        permissionsMap[permName] = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isRequired = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 14),
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
          decoration: _getInputDecoration(hintText: hint),
          validator: isRequired
              ? (val) => (val == null || val.trim().isEmpty) ? '$label is required' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    final options = ['Active', 'Inactive'];
    final normalizedStatus = options.firstWhere(
      (opt) => opt.toUpperCase() == _selectedStatus.toUpperCase(),
      orElse: () => options.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: normalizedStatus,
          isExpanded: true,
          decoration: _getInputDecoration(),
          items: options.map((st) {
            return DropdownMenuItem<String>(
              value: st,
              child: Text(st, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedStatus = val);
            }
          },
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration({String? hintText, Color? color}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color ?? const Color(0xFF00A980), width: 1.5),
      ),
    );
  }
}
