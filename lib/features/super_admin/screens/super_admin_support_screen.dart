import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import 'super_admin_main_layout.dart';

class SuperAdminSupportScreen extends StatefulWidget {
  const SuperAdminSupportScreen({super.key});

  @override
  State<SuperAdminSupportScreen> createState() => _SuperAdminSupportScreenState();
}

class _SuperAdminSupportScreenState extends State<SuperAdminSupportScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-1082',
      'title': 'Unable to access my documents on mobile phone',
      'user': 'mahnoor@gmail.com',
      'firm': 'Qanomy Lawyers',
      'priority': 'HIGH',
      'status': 'OPEN',
      'date': 'Today, 02:40 pm',
      'message': 'Hello, I cannot see the Documents tab on my mobile bottom navigation bar. Also, the upload dialog bottom buttons are cut off when I try to upload a file. Please fix this.'
    },
    {
      'id': 'TKT-1079',
      'title': 'App bar is missing or has dark text on dark background',
      'user': 'ayesha@khanlaw.com',
      'firm': 'Khan & Associates',
      'priority': 'MEDIUM',
      'status': 'OPEN',
      'date': 'Yesterday, 11:15 am',
      'message': 'On the home screen dashboard, the status bar text is dark/almost invisible because it sits on a dark navy header without proper annotated overlay styles. Can we make it white?'
    },
    {
      'id': 'TKT-1051',
      'title': 'Failed to download custom report PDF',
      'user': 'fatima@lawhub.com',
      'firm': 'Multan Legal Hub',
      'priority': 'LOW',
      'status': 'RESOLVED',
      'date': '3 days ago',
      'message': 'Every time I click export on the Reports & Analytics dashboard, it redirects me to an error page. Fixed now?'
    }
  ];

  final _replyController = TextEditingController();

  void _resolveTicket(int index) {
    setState(() {
      _tickets[index]['status'] = 'RESOLVED';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket ${_tickets[index]['id']} marked as RESOLVED')),
    );
  }

  void _showTicketDetails(int index) {
    final t = _tickets[index];
    _replyController.clear();
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isResolved = t['status'] == 'RESOLVED';
            
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ticket Details', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                  Text(t['id'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t['title'] as String, style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: t['priority'] == 'HIGH' ? const Color(0xFFFFEBEE) : const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              t['priority'] as String,
                              style: AppTypography.labelSmall.copyWith(color: t['priority'] == 'HIGH' ? const Color(0xFFD32F2F) : AppColors.blueGreen, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Submitted by: ${t['user']}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Text('User Message:', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border.withOpacity(0.5))),
                        child: Text(
                          t['message'] as String,
                          style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 13, height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (!isResolved) ...[
                        Text('Response Reply:', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _replyController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Type your message to resolve this issue...',
                            hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                if (!isResolved) ...[
                  ElevatedButton(
                    onPressed: () {
                      _resolveTicket(index);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A980)),
                    child: const Text('Resolve & Reply'),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        title: Text(
          'Support Desk',
          style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDeskSummary(isMobile),
                const SizedBox(height: AppSpacing.s24),
                _buildTicketsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeskSummary(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: isMobile
          ? Column(
              children: [
                _buildSummaryItem('OPEN TICKETS', '${_tickets.where((t) => t['status'] == 'OPEN').length}'),
                const SizedBox(height: 12),
                _buildSummaryItem('RESOLVED TODAY', '${_tickets.where((t) => t['status'] == 'RESOLVED').length}'),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('OPEN TICKETS', '${_tickets.where((t) => t['status'] == 'OPEN').length}'),
                _buildSummaryItem('HIGH PRIORITY', '${_tickets.where((t) => t['priority'] == 'HIGH' && t['status'] == 'OPEN').length}'),
                _buildSummaryItem('RESOLVED TODAY', '${_tickets.where((t) => t['status'] == 'RESOLVED').length}'),
              ],
            ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildTicketsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tickets.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final t = _tickets[index];
        final status = t['status'] as String;
        final priority = t['priority'] as String;
        final isResolved = status == 'RESOLVED';
        
        Color priorityColor = priority == 'HIGH' ? const Color(0xFFD32F2F) : AppColors.blueGreen;
        Color priorityBg = priority == 'HIGH' ? const Color(0xFFFFEBEE) : const Color(0xFFE8F0FE);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.s20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: priorityBg, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      priority,
                      style: AppTypography.labelSmall.copyWith(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  Text(
                    t['id'] as String,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                t['title'] as String,
                style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Submitted by: ${t['user']} (${t['firm']}) • ${t['date']}',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isResolved ? Icons.check_circle : Icons.radio_button_checked,
                        color: isResolved ? const Color(0xFF00A980) : const Color(0xFFF59E0B),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: AppTypography.labelSmall.copyWith(
                          color: isResolved ? const Color(0xFF00A980) : const Color(0xFFF59E0B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _showTicketDetails(index),
                        child: Text(isResolved ? 'View' : 'View & Reply', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.blueGreen)),
                      ),
                      if (!isResolved) ...[
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _resolveTicket(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A980),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Resolve'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
