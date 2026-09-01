import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';
import 'super_admin_ticket_details_screen.dart';

class SuperAdminSupportScreen extends StatefulWidget {
  const SuperAdminSupportScreen({super.key});

  @override
  State<SuperAdminSupportScreen> createState() => _SuperAdminSupportScreenState();
}

class _SuperAdminSupportScreenState extends State<SuperAdminSupportScreen> {
  String _filterStatus = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedTicketIds = {};

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': '#TK-C2D80BC5',
      'firm': 'Khan\'s Firm',
      'subject': 'Documents',
      'priority': 'Medium',
      'status': 'Open',
      'assignedTo': 'Unassigned',
      'updated': '20/08/2026, 1:49:48 pm',
      'email': 'mahnoorakhtar002@gmail.com',
      'message': 'Unable to process document uploads in legal filing section. Please review storage quota.',
    },
    {
      'id': '#TK-B4D91AE2',
      'firm': 'Pwm',
      'subject': 'Subscription Inquiry',
      'priority': 'Low',
      'status': 'In Progress',
      'assignedTo': 'Haris Khan',
      'updated': '25/08/2026, 11:20:15 am',
      'email': 'awaisiqbalalamgirian@gmail.com',
      'message': 'Requesting upgrade path details for migrating to Pro tier.',
    },
    {
      'id': '#TK-F81A9C04',
      'firm': 'NUMERIC COMMUNICATIONS',
      'subject': 'WhatsApp Integration',
      'priority': 'High',
      'status': 'Resolved',
      'assignedTo': 'Qanomy Admin',
      'updated': '18/08/2026, 04:15:30 pm',
      'email': 'numericcommunication@gmail.com',
      'message': 'Cause list WhatsApp notifications successfully configured.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedTicketIds.contains(id)) {
        _expandedTicketIds.remove(id);
      } else {
        _expandedTicketIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    // Calculate Counts
    final int openCount = _tickets.where((t) => t['status'] == 'Open').length;
    final int inProgressCount = _tickets.where((t) => t['status'] == 'In Progress').length;
    final int waitingCount = _tickets.where((t) => t['status'] == 'Waiting for Reply').length;
    final int resolvedCount = _tickets.where((t) => t['status'] == 'Resolved').length;
    final int closedCount = _tickets.where((t) => t['status'] == 'Closed').length;

    final filteredTickets = _tickets.where((ticket) {
      bool matchesStatus = true;
      if (_filterStatus == 'OPEN') matchesStatus = ticket['status'] == 'Open';
      if (_filterStatus == 'IN_PROGRESS') matchesStatus = ticket['status'] == 'In Progress';
      if (_filterStatus == 'WAITING') matchesStatus = ticket['status'] == 'Waiting for Reply';
      if (_filterStatus == 'RESOLVED') matchesStatus = ticket['status'] == 'Resolved';
      if (_filterStatus == 'CLOSED') matchesStatus = ticket['status'] == 'Closed';

      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (ticket['id'] as String).toLowerCase().contains(q) ||
          (ticket['firm'] as String).toLowerCase().contains(q) ||
          (ticket['subject'] as String).toLowerCase().contains(q);

      return matchesStatus && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildFilterPillsBar(
              total: _tickets.length,
              open: openCount,
              inProgress: inProgressCount,
              waiting: waitingCount,
              resolved: resolvedCount,
              closed: closedCount,
            ),
            _buildSearchBar(isMobile),
            Expanded(
              child: filteredTickets.isEmpty
                  ? Center(
                      child: Text(
                        'No support tickets found',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                      itemCount: filteredTickets.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildCollapsibleTicketCard(filteredTickets[index], isMobile),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 24),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Support Tickets',
              style: AppTypography.header.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 22 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPillsBar({
    required int total,
    required int open,
    required int inProgress,
    required int waiting,
    required int resolved,
    required int closed,
  }) {
    final filters = [
      {'key': 'ALL', 'label': 'All Tickets', 'count': total},
      {'key': 'OPEN', 'label': 'Open', 'count': open},
      {'key': 'IN_PROGRESS', 'label': 'In Progress', 'count': inProgress},
      {'key': 'WAITING', 'label': 'Waiting for Reply', 'count': waiting},
      {'key': 'RESOLVED', 'label': 'Resolved', 'count': resolved},
      {'key': 'CLOSED', 'label': 'Closed', 'count': closed},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final String key = f['key'] as String;
            final isSelected = _filterStatus == key;
            return GestureDetector(
              onTap: () => setState(() => _filterStatus = key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      f['label'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textMuted,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.princetonOrange : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${f['count']}',
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.primaryNavy,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.navBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: AppTypography.bodyInter.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search by ticket ID, firm name, subject...',
                  hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 16, color: AppColors.primaryNavy),
            label: Text(
              'Export',
              style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleTicketCard(Map<String, dynamic> ticket, bool isMobile) {
    final String id = ticket['id'] as String;
    final String firm = ticket['firm'] as String;
    final String subject = ticket['subject'] as String;
    final String priority = ticket['priority'] as String;
    final String status = ticket['status'] as String;
    final String assignedTo = ticket['assignedTo'] as String;
    final String updated = ticket['updated'] as String;
    final String message = ticket['message'] as String;

    final isExpanded = _expandedTicketIds.contains(id);

    Color statusColor = const Color(0xFF0284C7);
    Color statusBgColor = const Color(0xFFF0F9FF);

    if (status == 'Open') {
      statusColor = AppColors.princetonOrange;
      statusBgColor = const Color(0xFFFFF7ED);
    } else if (status == 'In Progress') {
      statusColor = const Color(0xFF8B5CF6);
      statusBgColor = const Color(0xFFF5F3FF);
    } else if (status == 'Resolved') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFECFDF5);
    }

    Color priorityColor = const Color(0xFF0284C7);
    if (priority == 'High') priorityColor = const Color(0xFFE53935);
    if (priority == 'Medium') priorityColor = AppColors.princetonOrange;

    return QanomyCard(
      onTap: () => _toggleExpand(id),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Always Visible Header: Ticket ID & Firm Name + Subject & Status Badge + Chevron Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.confirmation_number_outlined, size: 20, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$id • $firm',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Subject: $subject',
                        style: AppTypography.bodyInter.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),

            // Expanded Details Section (Revealed upon tap)
            if (isExpanded) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 14),

              if (isMobile)
                Wrap(
                  runSpacing: 10,
                  spacing: 16,
                  children: [
                    SizedBox(width: 140, child: _buildTicketStat('Priority', priority, Icons.flag_outlined, priorityColor)),
                    SizedBox(width: 140, child: _buildTicketStat('Status', status, Icons.info_outline, statusColor)),
                    SizedBox(width: 140, child: _buildTicketStat('Assigned To', assignedTo, Icons.person_outline, AppColors.primaryNavy)),
                    SizedBox(width: 140, child: _buildTicketStat('Updated', updated, Icons.schedule_outlined, AppColors.textMuted)),
                  ],
                )
              else
                Row(
                  children: [
                    _buildTicketStat('Priority', priority, Icons.flag_outlined, priorityColor),
                    _buildTicketStat('Status', status, Icons.info_outline, statusColor),
                    _buildTicketStat('Assigned To', assignedTo, Icons.person_outline, AppColors.primaryNavy),
                    _buildTicketStat('Updated', updated, Icons.schedule_outlined, AppColors.textMuted),
                  ],
                ),
              const SizedBox(height: 14),

              // User Message Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.navBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TICKET MESSAGE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuperAdminTicketDetailsScreen(ticket: ticket),
                        ),
                      );
                    },
                    icon: const Icon(Icons.reply_rounded, size: 14, color: AppColors.primaryNavy),
                    label: Text(
                      'Reply & Assign',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        ticket['status'] = 'Resolved';
                      });
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 14, color: Colors.white),
                    label: Text(
                      'Mark Resolved',
                      style: AppTypography.labelMedium.copyWith(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTypography.bodyInterSemiBold.copyWith(
              color: color,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
