import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Notifications & Reminders',
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
                _buildMarkAsReadButton(),
                const SizedBox(height: AppSpacing.s16),
                _buildNotificationsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkAsReadButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(
          Icons.done_all_rounded,
          size: 18,
          color: Color(0xFF00A980),
        ),
        label: Text(
          'Mark all as read',
          style: AppTypography.bodyInterMedium.copyWith(
            color: const Color(0xFF00A980),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = [
      {
        'title': 'New Hearing Scheduled',
        'desc': 'A hearing for case "Ali vs Ahmed" has been scheduled on 8/17/2026.',
        'time': '8/17/2026, 5:07:52 PM',
        'unread': true,
      },
      {
        'title': 'New Hearing Scheduled',
        'desc': 'A hearing for case "Ejaz vs Adnan" has been scheduled on 8/13/2026.',
        'time': '8/13/2026, 3:19:32 PM',
        'unread': false,
      },
      {
        'title': 'New Case Assigned',
        'desc': 'You have been assigned to case "Ali vs Ahmed".',
        'time': '8/13/2026, 3:04:03 PM',
        'unread': true,
      },
      {
        'title': 'New Case Assigned',
        'desc': 'You have been assigned to case "Ejaz vs Adnan".',
        'time': '8/13/2026, 2:57:49 PM',
        'unread': true,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final n = notifications[index];
        return _buildNotificationItem(
          title: n['title'] as String,
          desc: n['desc'] as String,
          time: n['time'] as String,
          unread: n['unread'] as bool,
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String desc,
    required String time,
    required bool unread,
  }) {
    final isHearing = title.contains('Hearing');
    final iconColor = isHearing ? const Color(0xFFFB8500) : const Color(0xFF219EBC);
    final iconData = isHearing ? Icons.calendar_today_rounded : Icons.folder_shared_rounded;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: unread ? iconColor : Colors.grey.withOpacity(0.2),
            width: 5,
          ),
          top: BorderSide(color: AppColors.border.withOpacity(0.3)),
          bottom: BorderSide(color: AppColors.border.withOpacity(0.3)),
          right: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Avatar Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Content details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (unread)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'NEW',
                              style: AppTypography.labelSmall.copyWith(
                                color: const Color(0xFF00A980),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: AppTypography.bodyInter.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Soft responsive timestamp with clock icon
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.textMuted,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
