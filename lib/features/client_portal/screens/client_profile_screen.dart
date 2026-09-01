import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/image_picker_helper.dart';
import '../screens/client_portal_main_layout.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  Uint8List? _profileImageBytes;

  final _firstNameController = TextEditingController(text: 'Lord');
  final _lastNameController = TextEditingController(text: 'Beerus');
  final _emailController = TextEditingController(text: 'beerus@gmail.com');
  final _phoneController = TextEditingController(text: '+92 300 9876543');

  final _currentPasswordController = TextEditingController(text: 'Mahnoor123');
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
        });
      }
    } catch (e) {
      try {
        final bytes = await pickImageFromDevice();
        if (bytes != null) {
          setState(() {
            _profileImageBytes = Uint8List.fromList(bytes);
          });
        }
      } catch (innerErr) {
        debugPrint("Error picking profile image: $innerErr");
      }
    }
  }

  void _openSecurityModule() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.princetonOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.shield_outlined, color: AppColors.princetonOrange, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Security Module',
                          style: AppTypography.header.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage and update your password to keep your account safe.',
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 20),

                StatefulBuilder(
                  builder: (context, setModalState) {
                    return Column(
                      children: [
                        _buildPasswordField(
                          label: 'Current Password',
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrent,
                          onToggle: () => setModalState(() => _obscureCurrent = !_obscureCurrent),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          label: 'New Password',
                          controller: _newPasswordController,
                          hint: 'Create new password',
                          obscureText: _obscureNew,
                          onToggle: () => setModalState(() => _obscureNew = !_obscureNew),
                        ),
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          label: 'Confirm New Password',
                          controller: _confirmPasswordController,
                          hint: 'Confirm new password',
                          obscureText: _obscureConfirm,
                          onToggle: () => setModalState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_newPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a new password.')),
                          );
                          return;
                        }
                        if (_newPasswordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match.')),
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password updated successfully!'),
                            backgroundColor: AppColors.primaryNavy,
                          ),
                        );
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sidebarNavy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Update Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Top App Bar
            Container(
              color: AppColors.sidebarNavy,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 16,
                16,
                20,
              ),
              child: Row(
                children: [
                  if (isMobile)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                      onPressed: () => ClientPortalMainLayout.scaffoldKey.currentState?.openDrawer(),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    'My Profile',
                    style: AppTypography.header.copyWith(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: _buildProfileCard(isMobile),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Profile',
            style: AppTypography.header.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'View and manage your profile details and security settings.',
            style: AppTypography.bodyInter.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 24),

          // Profile Picture Area
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.sidebarNavy,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: _profileImageBytes != null
                      ? Image.memory(_profileImageBytes!, fit: BoxFit.cover)
                      : const Center(
                          child: Text(
                            'B',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 18),
              OutlinedButton(
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryNavy,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Change Picture', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form Fields: First Name & Last Name
          if (isMobile) ...[
            _buildFormField(
              label: 'First Name',
              controller: _firstNameController,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: 'Last Name',
              controller: _lastNameController,
              icon: Icons.person_outline_rounded,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'First Name',
                    controller: _firstNameController,
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    icon: Icons.person_outline_rounded,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),

          // Form Fields: Email Address & Phone Number
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  label: 'Email Address',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact support to change your email.',
                  style: AppTypography.captionInter.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: 'Phone Number',
              controller: _phoneController,
              icon: Icons.phone_outlined,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        label: 'Email Address',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        enabled: false,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contact support to change your email.',
                        style: AppTypography.captionInter.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Security Field Tile (Click to open Security Module)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _openSecurityModule,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shield_outlined, color: AppColors.princetonOrange, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Security Settings',
                              style: AppTypography.bodyInterMedium.copyWith(
                                color: AppColors.primaryNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Click to manage password and account security module',
                              style: AppTypography.captionInter.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Save Changes Button (Bottom Right)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile information updated successfully!'),
                    backgroundColor: AppColors.primaryNavy,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.princetonOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Form Input Field
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          style: AppTypography.bodyInter.copyWith(
            color: enabled ? AppColors.primaryNavy : AppColors.textMuted,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.princetonOrange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable Password Input Field
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? hint,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textMuted,
                size: 18,
              ),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.princetonOrange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

