import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/case_model.dart';
import '../screens/case_details_screen.dart';

class CaseListItem extends StatelessWidget {
  final CaseModel caseItem;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showEditButton;
  final bool showDeleteButton;

  const CaseListItem({
    super.key,
    required this.caseItem,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.showEditButton = false,
    this.showDeleteButton = false,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseDetailsScreen(
                    caseTitle: caseItem.displayTitle,
                    caseNo: caseItem.caseIdNo.isEmpty ? 'ABBD87AA' : caseItem.caseIdNo,
                    status: caseItem.status.toUpperCase(),
                  ),
                ),
              );
            },
        onLongPress: onLongPress,
        child: Padding(
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
                        caseItem.displayTitle,
                        style: AppTypography.bodyInterMedium.copyWith(
                          fontSize: 14,
                          color: AppColors.primaryNavy,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (caseItem.isFavorite) ...[
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

              // Assignee, Edit, Delete Buttons, and Chevron
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    caseItem.assignee,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (showEditButton && onEdit != null) ...[
                    const SizedBox(width: AppSpacing.s8),
                    InkWell(
                      onTap: onEdit,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A00).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFFF8A00),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                  if (showDeleteButton && onDelete != null) ...[
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
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
        ),
      ),
    );
  }
}
