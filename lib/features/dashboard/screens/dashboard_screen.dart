import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveConstraints.maxContentWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Advocate',
                style: AppTypography.bodyInter.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Your practice, in order.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s32),
              
              _buildSectionHeader('Requires Attention'),
              const SizedBox(height: AppSpacing.s16),
              
              // Attention Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Upcoming Hearings',
                      '3',
                      AppColors.princetonOrange,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: _buildMetricCard(
                      'Pending Contracts',
                      '12',
                      AppColors.blueGreen,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.s32),
              
              _buildSectionHeader('Today\'s Cause List'),
              const SizedBox(height: AppSpacing.s16),
              
              // Cause List Item
              QanomyCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10:30 AM',
                          style: AppTypography.bodyInterMedium.copyWith(
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s12,
                            vertical: AppSpacing.s4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'High Court',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primaryNavy,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'Ahmed vs. State of Punjab',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      'Bail Application - Court Room 4',
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.s16),
              
              QanomyCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2:00 PM',
                          style: AppTypography.bodyInterMedium.copyWith(
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s12,
                            vertical: AppSpacing.s4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.skyBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'District Court',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primaryNavy,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'TechNova Pvt Ltd vs. FBR',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      'Tax Hearing - Room 12',
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.titleLarge,
    );
  }

  Widget _buildMetricCard(String title, String value, Color accentColor) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: accentColor,
              size: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            value,
            style: AppTypography.header.copyWith(
              fontSize: 32,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            title,
            style: AppTypography.bodyInterMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
