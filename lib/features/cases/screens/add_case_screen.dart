import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';

class AddCaseScreen extends StatelessWidget {
  const AddCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: AppSpacing.s12, // Slight spacing from the back arrow
        title: Text(
          'Add New Case',
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
        _buildBasicInfoSection(),
        const SizedBox(height: AppSpacing.s24),
        _buildPartiesAndAssignmentSection(),
        const SizedBox(height: AppSpacing.s32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildBasicInfoSection()),
        const SizedBox(width: AppSpacing.s24),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPartiesAndAssignmentSection(),
              const SizedBox(height: AppSpacing.s32),
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          _buildTextField(
            'First Party',
            'e.g. Muhammad Ahmad',
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildTextField(
            'Opposite Party',
            'e.g. State / CC 123/2024',
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildTextField(
            'Court Name',
            'Select or type court name (e.g. Sessions Court Lahore)',
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildTextField(
            'Case Type',
            'Select or type custom case type (e.g. Constitutional, NAB, Banking)',
          ),
          const SizedBox(height: AppSpacing.s16),
          _buildTextField('Judge Name', 'e.g. Honorable Justice XYZ'),
          const SizedBox(height: AppSpacing.s16),
          _buildDropdownField('Case Status', 'Open', isRequired: true),
          const SizedBox(height: AppSpacing.s16),
          _buildDropdownField('Priority', 'Select Priority'),
          const SizedBox(height: AppSpacing.s16),
          _buildTextField(
            'Remarks / Description',
            'Enter case description or remarks',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesAndAssignmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Parties & Counsel',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Client ',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w600,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+ New Client',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.princetonOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildDropdownInput('Select Client'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assignment',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Assigned Lawyer / Team Member',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildDropdownInput('Select Lawyer / Member'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: AppTypography.bodyInterMedium.copyWith(
              color: AppColors.primaryNavy,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.princetonOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Save Case',
            style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyInter.copyWith(
              color: AppColors.border,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.princetonOrange),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String hint, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        _buildDropdownInput(hint),
      ],
    );
  }

  Widget _buildDropdownInput(String hint) {
    return DropdownButtonFormField<String>(
      items: const [],
      onChanged: (val) {},
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyInter.copyWith(
          color: AppColors.border,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.princetonOrange),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
    );
  }
}
