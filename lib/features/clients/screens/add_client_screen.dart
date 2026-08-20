import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';

class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: AppSpacing.s12,
        title: Text(
          'Add New Client',
          style: AppTypography.header.copyWith(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Responsive(
          mobile: _buildMobileLayout(),
          tablet: _buildDesktopLayout(),
          desktop: _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildClientInfoSection(),
        const SizedBox(height: AppSpacing.s24),
        _buildPortalAccessSection(),
        const SizedBox(height: AppSpacing.s32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildClientInfoSection(),
            ),
            const SizedBox(width: AppSpacing.s24),
            Expanded(
              flex: 1,
              child: _buildPortalAccessSection(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildClientInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline, color: AppColors.skyBlue, size: 20),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Client Information',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDropdownField('Client Type', 'Individual', isRequired: true, prefixIcon: Icons.category_outlined)),
              const SizedBox(width: AppSpacing.s24),
              Expanded(child: _buildTextField('Company Name (If applicable)', 'Enter company name', prefixIcon: Icons.business_outlined)),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField('Client Name', 'Enter client full name', isRequired: true, prefixIcon: Icons.badge_outlined)),
              const SizedBox(width: AppSpacing.s24),
              Expanded(child: _buildTextField('NTN (If applicable)', 'Enter NTN number', prefixIcon: Icons.numbers_outlined)),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField('CNIC', 'XXXXX-XXXXXXX-X', isRequired: true, prefixIcon: Icons.credit_card_outlined)),
              const SizedBox(width: AppSpacing.s24),
              Expanded(child: _buildTextField('Occupation / Business', 'Enter occupation or business', prefixIcon: Icons.work_outline)),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField('Phone / WhatsApp', 'Enter phone number', isRequired: true, prefixIcon: Icons.phone_outlined)),
              const SizedBox(width: AppSpacing.s24),
              Expanded(child: _buildTextField('Referred By', 'Enter name (optional)', prefixIcon: Icons.handshake_outlined)),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Email', 'Enter email address', prefixIcon: Icons.email_outlined),
                    const SizedBox(height: AppSpacing.s24),
                    _buildTextField('City', 'Lahore', prefixIcon: Icons.location_city_outlined),
                    const SizedBox(height: AppSpacing.s24),
                    _buildTextField('Address', 'Enter full address', maxLines: 3, prefixIcon: Icons.home_outlined),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s24),
              Expanded(child: _buildTextField('Notes', 'Enter any notes about client', maxLines: 9, prefixIcon: Icons.note_alt_outlined)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortalAccessSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_outlined, color: Color(0xFF00A980), size: 20),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Portal Access',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Allow client to access their cases, hearings, documents and invoices securely.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.s24),
          _buildDropdownField('Client Status', 'Active'),
          const SizedBox(height: AppSpacing.s24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Portal Access',
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                ),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: const Color(0xFF00A980),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const Divider(),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Portal Credentials',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildCopyField('Email', 'client_portal@noorportal.pk'),
          const SizedBox(height: AppSpacing.s16),
          _buildCopyField('Temporary Password', 'nOzfEQ3x'),
          const SizedBox(height: AppSpacing.s24),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Credentials will be securely sent via WhatsApp / Email upon saving.',
                    style: AppTypography.labelSmall.copyWith(color: const Color(0xFF2E7D32), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.close, size: 16, color: AppColors.primaryNavy),
          label: Text(
            'Cancel',
            style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save_outlined, size: 16, color: Colors.white),
          label: Text(
            'Save Client',
            style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A980), // Vibrant mint green from mockup
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {bool isRequired = false, int maxLines = 1, IconData? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
            children: isRequired ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted.withOpacity(0.7), fontSize: 14),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00A980), width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, {bool isRequired = false, IconData? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
            children: isRequired ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        _buildDropdownInput(hint, prefixIcon: prefixIcon),
      ],
    );
  }

  Widget _buildDropdownInput(String hint, {IconData? prefixIcon}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        items: const [],
        onChanged: (val) {},
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted.withOpacity(0.7), fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00A980), width: 1.5),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
      ),
    );
  }

  Widget _buildCopyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.s8),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18, color: Color(0xFF00A980)),
                onPressed: () {},
                tooltip: 'Copy',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
