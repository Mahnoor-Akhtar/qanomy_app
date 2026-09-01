import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminNotificationsScreen extends StatefulWidget {
  const SuperAdminNotificationsScreen({super.key});

  @override
  State<SuperAdminNotificationsScreen> createState() => _SuperAdminNotificationsScreenState();
}

class _SuperAdminNotificationsScreenState extends State<SuperAdminNotificationsScreen> {
  TimeOfDay _selectedTiming = const TimeOfDay(hour: 8, minute: 30);
  String _searchQuery = '';
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _notifications = [
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:47 am',
      'message': 'The status of case "Momina vs Muheeb" is now ALLOWED.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:47 am',
      'message': 'The status of case "Alia vs Adnan" is now REMAND.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:42 am',
      'message': 'The status of case "Ali vs Naveed" is now OPEN.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:42 am',
      'message': 'The status of case "Momina vs Muheeb" is now REOPEN.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:41 am',
      'message': 'The status of case "Ali vs Babar" is now REOPEN.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'Case Status Updated',
      'date': '24-Aug-2026, 10:41 am',
      'message': 'The status of case "Ejaz vs Adnan" is now OPEN.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'New Hearing Scheduled',
      'date': '17-Aug-2026, 5:07 pm',
      'message': 'A hearing for case "Ali vs Ahmed" has been scheduled on 8/17/2026.',
      'tag': 'New Hearing',
      'type': 'Hearing',
    },
    {
      'title': 'New Document Uploaded',
      'date': '17-Aug-2026, 3:50 pm',
      'message': 'A new document "Coursera GSZCPL63KR71 (1)" was uploaded to your case.',
      'tag': 'Document Uploaded',
      'type': 'Document',
    },
    {
      'title': 'Payment Received',
      'date': '14-Aug-2026, 6:09 pm',
      'message': 'A payment of 50000 has been recorded for invoice INV-2026-1310.',
      'tag': 'Payment Received',
      'type': 'Billing',
    },
    {
      'title': 'Case Status Updated',
      'date': '14-Aug-2026, 5:56 pm',
      'message': 'The status of case "Sajida vs Fahad" is now CLOSED.',
      'tag': 'Case Updated',
      'type': 'Case',
    },
    {
      'title': 'New Document Uploaded',
      'date': '13-Aug-2026, 5:23 pm',
      'message': 'A new document "ChatGPT Image Aug 13, 2026, 11_51_02 AM" was uploaded to your case.',
      'tag': 'Document Uploaded',
      'type': 'Document',
    },
    {
      'title': 'New Invoice Created',
      'date': '13-Aug-2026, 3:04 pm',
      'message': 'A new invoice (INV-2026-7899) for amount 60000 has been issued.',
      'tag': 'Invoice Created',
      'type': 'Billing',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTiming,
    );
    if (picked != null && picked != _selectedTiming) {
      setState(() {
        _selectedTiming = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final filteredNotifs = _notifications.where((n) {
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          n['title']!.toLowerCase().contains(q) ||
          n['message']!.toLowerCase().contains(q) ||
          n['tag']!.toLowerCase().contains(q);

      final matchesType = _selectedType == 'All Types' || n['type'] == _selectedType;

      return matchesQuery && matchesType;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTimingConfigurationCard(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildMetricsOverview(isMobile),
                        const SizedBox(height: AppSpacing.s20),
                        _buildSearchAndFiltersBar(isMobile),
                        const SizedBox(height: AppSpacing.s16),
                        _buildNotificationsList(filteredNotifs, isMobile),
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
              'Notifications & Alerts',
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

  Widget _buildTimingConfigurationCard(bool isMobile) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alarm_rounded, color: AppColors.princetonOrange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Daily Hearing Notification Timing',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Configure the time of day when users with scheduled hearings will receive their hearing details PDF report via email.',
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          Row(
            children: [
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.navBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 18, color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimeOfDay(_selectedTiming),
                        style: AppTypography.bodyInterSemiBold.copyWith(
                          color: AppColors.primaryNavy,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Daily notification timing saved: ${_formatTimeOfDay(_selectedTiming)}')),
                  );
                },
                icon: const Icon(Icons.save_outlined, size: 16, color: Colors.white),
                label: Text(
                  'Save Timing',
                  style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsOverview(bool isMobile) {
    if (isMobile) {
      return QanomyCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SizedBox(width: 100, child: _buildMetricStat('Total', '100', const Color(0xFF0284C7), const Color(0xFFF0F9FF))),
              SizedBox(width: 100, child: _buildMetricStat('Unread', '0', const Color(0xFFE53935), const Color(0xFFFFEBEE))),
              SizedBox(width: 100, child: _buildMetricStat('Read', '5', const Color(0xFF10B981), const Color(0xFFECFDF5))),
              SizedBox(width: 100, child: _buildMetricStat('Filtered', '100', AppColors.primaryNavy, const Color(0xFFF1F5F9))),
            ],
          ),
        ),
      );
    }
    return QanomyCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _buildMetricStat('Total', '100', const Color(0xFF0284C7), const Color(0xFFF0F9FF)),
          _buildMetricStat('Unread', '0', const Color(0xFFE53935), const Color(0xFFFFEBEE)),
          _buildMetricStat('Read', '5', const Color(0xFF10B981), const Color(0xFFECFDF5)),
          _buildMetricStat('Filtered', '100', AppColors.primaryNavy, const Color(0xFFF1F5F9)),
        ],
      ),
    );
  }

  Widget _buildMetricStat(String label, String count, Color color, Color bg) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Text(
              count,
              style: AppTypography.header.copyWith(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFiltersBar(bool isMobile) {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.navBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.bodyInter.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search notifications…',
                      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: _selectedType,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedType = val);
                  },
                  items: ['All Types', 'Case', 'Hearing', 'Document', 'Billing']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                  items: ['All Status', 'Read', 'Unread']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNavy, size: 20),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _selectedType = 'All Types';
                    _selectedStatus = 'All Status';
                  });
                },
                tooltip: 'Refresh Notifications',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, String>> notifs, bool isMobile) {
    if (notifs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No notifications match your filter',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final n = notifs[index];
        final String tag = n['tag']!;
        final String title = n['title']!;
        final String date = n['date']!;
        final String message = n['message']!;

        Color tagBg = const Color(0xFFF0F9FF);
        Color tagColor = const Color(0xFF0284C7);
        IconData tagIcon = Icons.notifications_none_rounded;

        if (tag == 'Case Updated') {
          tagBg = const Color(0xFFFFF7ED);
          tagColor = AppColors.princetonOrange;
          tagIcon = Icons.balance_rounded;
        } else if (tag == 'New Hearing') {
          tagBg = const Color(0xFFF5F3FF);
          tagColor = const Color(0xFF8B5CF6);
          tagIcon = Icons.event_rounded;
        } else if (tag == 'Document Uploaded') {
          tagBg = const Color(0xFFECFDF5);
          tagColor = const Color(0xFF10B981);
          tagIcon = Icons.description_rounded;
        } else if (tag == 'Payment Received' || tag == 'Invoice Created') {
          tagBg = const Color(0xFFEFF6FF);
          tagColor = const Color(0xFF2563EB);
          tagIcon = Icons.receipt_long_rounded;
        }

        return QanomyCard(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(tagIcon, size: 20, color: tagColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          date,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.labelSmall.copyWith(
                        color: tagColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  message,
                  style: AppTypography.bodyInter.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
