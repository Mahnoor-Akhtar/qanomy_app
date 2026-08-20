import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class CaseListItem extends StatelessWidget {
  final String title;
  final String assignee;
  final bool isFavorite;

  const CaseListItem({
    super.key,
    required this.title,
    required this.assignee,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
      child: Row(
        children: [
          // Folder Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.pastelBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_outlined,
              color: AppColors.primaryNavy,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          
          // Case Title and Star
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: AppTypography.bodyInterMedium.copyWith(
                      fontSize: 14,
                      color: AppColors.primaryNavy,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isFavorite) ...[
                  const SizedBox(width: AppSpacing.s8),
                  const Icon(
                    Icons.star,
                    color: AppColors.navOrange,
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(width: AppSpacing.s12),
          
          // Assignee and Chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                assignee,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
