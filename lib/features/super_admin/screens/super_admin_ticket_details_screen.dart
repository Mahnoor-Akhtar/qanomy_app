import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';

class SuperAdminTicketDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;

  const SuperAdminTicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<SuperAdminTicketDetailsScreen> createState() => _SuperAdminTicketDetailsScreenState();
}

class _SuperAdminTicketDetailsScreenState extends State<SuperAdminTicketDetailsScreen> {
  int _noteMode = 0; // 0=Reply to Client, 1=Internal Note
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final t = widget.ticket;

    final String id = t['id'] as String? ?? '#TK-C2D80BC5';
    final String firm = t['firm'] as String? ?? 'Khan\'s Firm';
    final String subject = t['subject'] as String? ?? 'Documents';
    final String priority = t['priority'] as String? ?? 'Medium';
    final String status = t['status'] as String? ?? 'Open';
    final String email = t['email'] as String? ?? '—';
    final String updated = t['updated'] as String? ?? '20/08/2026, 1:49:48 pm';
    final String message = t['message'] as String? ?? 'Unable to process document uploads in legal filing section. Please review storage quota.';

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTopNavBar(context, isMobile, id, status),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTicketHeaderInfo(id, status, priority, subject, updated),
                        const SizedBox(height: AppSpacing.s24),
                        isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildLeftChatColumn(context, message, updated),
                                  const SizedBox(height: AppSpacing.s20),
                                  _buildRightTicketInfoCard(firm, email),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 8, child: _buildLeftChatColumn(context, message, updated)),
                                  const SizedBox(width: AppSpacing.s24),
                                  Expanded(flex: 4, child: _buildRightTicketInfoCard(firm, email)),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context, bool isMobile, String id, String status) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 20),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 14, color: Colors.white),
            label: Text(
              'Back to Tickets',
              style: AppTypography.labelMedium.copyWith(color: Colors.white, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white38),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, size: 16, color: Colors.white),
            label: Text(
              'Actions',
              style: AppTypography.labelMedium.copyWith(color: Colors.white, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white38),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                widget.ticket['status'] = 'Resolved';
              });
            },
            icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
            label: Text(
              'Resolve Ticket',
              style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF023047),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketHeaderInfo(String id, String status, String priority, String subject, String updated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              id,
              style: AppTypography.header.copyWith(
                color: AppColors.primaryNavy,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: AppTypography.labelSmall.copyWith(
                      color: const Color(0xFF0284C7),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_outlined, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    priority,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subject,
          style: AppTypography.header.copyWith(
            color: AppColors.primaryNavy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Created on $updated via Web',
          style: AppTypography.bodyInter.copyWith(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftChatColumn(BuildContext context, String message, String updated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Client Message Card
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF6366F1), // Indigo
              child: Text(
                'C',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Client User',
                        style: AppTypography.bodyInterSemiBold.copyWith(
                          color: AppColors.primaryNavy,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'CLIENT',
                          style: AppTypography.labelSmall.copyWith(
                            color: const Color(0xFF6366F1),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        updated,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      message,
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s24),

        // Reply / Internal Note Form Box
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF38BDF8), width: 1.5), // Blue accent border
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Selector Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _noteMode = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _noteMode == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _noteMode == 0
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)]
                              : null,
                        ),
                        child: Text(
                          'Reply to Client',
                          style: AppTypography.bodyInterMedium.copyWith(
                            color: AppColors.primaryNavy,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _noteMode = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _noteMode == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _noteMode == 1
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)]
                              : null,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shield_outlined, size: 12, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              'Internal Note',
                              style: AppTypography.bodyInter.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Text Area
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: TextField(
                  controller: _replyController,
                  maxLines: 5,
                  style: AppTypography.bodyInter.copyWith(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: _noteMode == 0 ? 'Type your reply here...' : 'Type internal team note here...',
                    hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Bottom Action Toolbar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file_rounded, color: AppColors.textMuted, size: 20),
                      onPressed: () {},
                      tooltip: 'Attach File',
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_replyController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Response sent successfully')),
                          );
                          _replyController.clear();
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 14, color: AppColors.textMuted),
                      label: Text(
                        _noteMode == 0 ? 'Send Reply' : 'Add Note',
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textMuted, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Center(
          child: Text(
            'Created by system on $updated via Web',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildRightTicketInfoCard(String firm, String email) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TICKET INFORMATION',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),

          // Firm Name Row
          Text(
            'FIRM NAME',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.domain_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  firm,
                  style: AppTypography.bodyInterSemiBold.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Email Row
          Text(
            'EMAIL',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  email,
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
