import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../navigation/main_layout.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Notifications & Reminders',
        subtitle: 'View your live activity and notifications',
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
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Mark all as read',
          style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF00A980), fontSize: 13),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(color: AppColors.border.withOpacity(0.3), height: 1),
        itemBuilder: (context, index) {
          final n = notifications[index];
          return _buildNotificationItem(
            title: n['title'] as String,
            desc: n['desc'] as String,
            time: n['time'] as String,
            unread: n['unread'] as bool,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String desc,
    required String time,
    required bool unread,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator dot
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: unread ? const Color(0xFF00A980) : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Time
          Text(
            time,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
