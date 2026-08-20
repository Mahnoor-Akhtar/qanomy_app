import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../navigation/main_layout.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, String>> _tickets = [];

  void _openContactDialog() {
    showDialog(
      context: context,
      builder: (_) => _ContactSupportDialog(
        onSubmit: (subject, priority, description) {
          setState(() {
            _tickets.insert(0, {
              'subject': subject,
              'priority': priority,
              'description': description.isEmpty ? 'No description provided.' : description,
              'status': 'OPEN',
              'date': _formatDate(DateTime.now()),
            });
          });
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: QanomyAppBar(
        title: 'Help & Support',
        subtitle: 'Get in touch with Qanomy Support or view your request history',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildContactCard(),
                      const SizedBox(height: 16),
                      _buildHistoryCard(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildContactCard()),
                      const SizedBox(width: 20),
                      Expanded(flex: 3, child: _buildHistoryCard()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent, color: Color(0xFF3B82F6), size: 40),
          ),
          const SizedBox(height: 24),
          Text('Need Technical Help?', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 20)),
          const SizedBox(height: 12),
          Text(
            'Having trouble using the portal? Contact the Qanomy technical support team.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openContactDialog,
              icon: const Icon(Icons.email_outlined, size: 18, color: Colors.white),
              label: Text('Contact Support', style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 350),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support Request History', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
          const SizedBox(height: 16),
          if (_tickets.isEmpty) _buildEmptyState() else _buildTicketList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.description_outlined, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No Support Requests', style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary, fontSize: 15)),
            const SizedBox(height: 8),
            Text("You haven't submitted any support\nrequests yet.", textAlign: TextAlign.center, style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tickets.length,
      separatorBuilder: (_, __) => Divider(color: AppColors.border.withOpacity(0.4), height: 24),
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        final priorityColor = _priorityColor(ticket['priority']!);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket['subject']!,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(ticket['priority']!.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(ticket['description']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(ticket['status']!, style: AppTypography.labelSmall.copyWith(color: const Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 10)),
                ),
                Text(ticket['date']!, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ],
        );
      },
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return const Color(0xFFEF4444);
      case 'medium': return const Color(0xFFF59E0B);
      case 'low': return const Color(0xFF10B981);
      default: return const Color(0xFFF59E0B);
    }
  }
}

// ── Dialog ────────────────────────────────────────────────────────────────────

class _ContactSupportDialog extends StatefulWidget {
  final void Function(String subject, String priority, String description) onSubmit;

  const _ContactSupportDialog({required this.onSubmit});

  @override
  State<_ContactSupportDialog> createState() => _ContactSupportDialogState();
}

class _ContactSupportDialogState extends State<_ContactSupportDialog> {
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'Medium';

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryNavy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.support_agent, color: AppColors.primaryNavy, size: 22),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Contact Qanomy Support', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 17))),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Subject
              Text('Subject *', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _subjectController,
                decoration: _inputDecoration('e.g. Unable to view my documents'),
              ),
              const SizedBox(height: 16),

              // Priority
              Text('Priority *', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border.withOpacity(0.5)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _priority,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                    style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14),
                    items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text('Description *', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: _inputDecoration('Describe your issue in detail. Minimum 10 characters.'),
              ),
              const SizedBox(height: 28),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_subjectController.text.trim().isEmpty) return;
                        widget.onSubmit(_subjectController.text.trim(), _priority, _descController.text.trim());
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text('Submit Ticket', style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
