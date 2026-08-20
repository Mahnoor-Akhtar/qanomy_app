import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _activeTab = 0; // 0 = Personal Profile, 1 = Security & Password

  final _firstNameController = TextEditingController(text: 'Haris khan');
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController(text: 'mahnoorakhtar002@gmail.com');
  final _phoneController = TextEditingController(text: '03051180621');
  final _firmNameController = TextEditingController(text: "Khan's Firm");

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firmNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage your profile, security preferences, and subscription details.',
                  style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: AppSpacing.s24),
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMobileTabs(),
                      const SizedBox(height: 16),
                      _buildActiveTabContent(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 250, child: _buildDesktopSidebar()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildActiveTabContent()),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _activeTab == 0 ? const Color(0xFFE8F5E9) : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
                ),
                child: Text(
                  'Personal Profile',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyInterMedium.copyWith(
                    color: _activeTab == 0 ? const Color(0xFF10B981) : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _activeTab == 1 ? const Color(0xFFE8F5E9) : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                ),
                child: Text(
                  'Security & Password',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyInterMedium.copyWith(
                    color: _activeTab == 1 ? const Color(0xFF10B981) : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSidebarButton(0, 'Personal Profile', Icons.person_outline_rounded),
        const SizedBox(height: 12),
        _buildSidebarButton(1, 'Security & Password', Icons.lock_outline_rounded),
      ],
    );
  }

  Widget _buildSidebarButton(int index, String title, IconData icon) {
    final isActive = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.border.withOpacity(0.5) : Colors.transparent,
          ),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF10B981) : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTypography.bodyInterMedium.copyWith(
                color: isActive ? const Color(0xFF10B981) : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    if (_activeTab == 0) {
      return _buildPersonalProfileCard();
    } else {
      return _buildSecurityPasswordCard();
    }
  }

  Widget _buildPersonalProfileCard() {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Profile',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Update your personal information and contact details.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          
          // Profile Pic Row
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      color: AppColors.border.withOpacity(0.2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: const Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Picture',
                    style: AppTypography.bodyInterMedium.copyWith(
                      color: AppColors.primaryNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, GIF or PNG. Max size of 800K',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Forms Grid
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('First Name', _firstNameController),
                const SizedBox(height: 16),
                _buildTextField('Last Name', _lastNameController),
                const SizedBox(height: 16),
                _buildTextField('Email Address', _emailController, enabled: false),
                const SizedBox(height: 16),
                _buildTextField('Phone Number', _phoneController),
                const SizedBox(height: 16),
                _buildTextField('Law Firm Name', _firmNameController),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField('First Name', _firstNameController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Last Name', _lastNameController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Email Address', _emailController, enabled: false)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Phone Number', _phoneController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Law Firm Name', _firmNameController)),
                    const SizedBox(width: 16),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A980),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 0,
              ),
              child: Text(
                'Save Changes',
                style: AppTypography.bodyInterMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Color(0xFF00A980), size: 20),
              const SizedBox(width: 8),
              Text(
                'Change Password',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Ensure your account is using a secure password.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),

          _buildTextField('Current Password', _currentPasswordController, obscureText: true),
          const SizedBox(height: 16),
          _buildTextField('New Password', _newPasswordController, obscureText: true),
          const SizedBox(height: 16),
          _buildTextField('Confirm New Password', _confirmPasswordController, obscureText: true),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 0,
              ),
              child: Text(
                'Update Password',
                style: AppTypography.bodyInterMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: !enabled,
            fillColor: !enabled ? const Color(0xFFF1F5F9) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }
}
