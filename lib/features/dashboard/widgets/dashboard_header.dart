import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(AppSpacing.s24, AppSpacing.s48, AppSpacing.s24, AppSpacing.s64), // Extra bottom padding for overlap
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Date, Greeting, Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      'THURSDAY - 20 AUGUST 2026',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Good morning',
                  style: AppTypography.header.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                RichText(
                  text: TextSpan(
                    style: AppTypography.bodyInter.copyWith(color: Colors.white70, fontSize: 13),
                    children: [
                      TextSpan(
                        text: '0 hearings',
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.princetonOrange, fontSize: 13),
                      ),
                      const TextSpan(text: ' listed today'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right Side: Action Icons
          Row(
            children: [
              _buildIcon(Icons.search),
              const SizedBox(width: AppSpacing.s12),
              Stack(
                children: [
                  _buildIcon(Icons.notifications_none),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.princetonOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.s16),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Center(
                  child: Text(
                    'HK',
                    style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      color: Colors.white,
      size: 24,
    );
  }
}
