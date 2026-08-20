import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../navigation/main_layout.dart';
import '../../../core/utils/responsive.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Your Activity',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderActions(context),
                const SizedBox(height: AppSpacing.s24),
                _buildActivityList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTrackActivityRow(),
                const Divider(height: 32),
                _buildClearLogButton(isFullWidth: true),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildTrackActivityRow()),
                const SizedBox(width: 24),
                _buildClearLogButton(isFullWidth: false),
              ],
            ),
    );
  }

  Widget _buildTrackActivityRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9), // Soft green
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sensors_rounded, // Sleek track sensor
            color: Color(0xFF10B981),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track Activity',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Monitor and log admin actions in the portal',
                style: AppTypography.bodyInter.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: true,
          onChanged: (v) {},
          activeColor: const Color(0xFFFF8A00),
          activeTrackColor: const Color(0xFFFF8A00).withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildClearLogButton({required bool isFullWidth}) {
    final button = TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFEF4444)),
      label: Text(
        'Clear Log',
        style: AppTypography.bodyInterMedium.copyWith(
          color: const Color(0xFFEF4444),
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFFEF2F2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }

  Widget _buildActivityList() {
    final List<Map<String, String>> activities = [
      {'name': 'Haris khan', 'tag': 'LOGIN', 'desc': 'User logged in successfully', 'time': '3h ago • 8/20/2026, 9:36:12 AM'},
      {'name': 'Haris khan', 'tag': 'LOGIN', 'desc': 'User logged in successfully', 'time': '2d ago • 8/17/2026, 7:11:01 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:28 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:25 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:11 PM'},
      {'name': 'Qanomy Admin (MA)', 'tag': 'LOGIN', 'desc': 'Administrator impersonated firm owner mahnoorakhtar002@gmail.com', 'time': '2d ago • 8/17/2026, 6:45:02 PM'},
      {'name': 'Haris khan', 'tag': 'UPDATED FIRM', 'desc': "Firm \"Khan's Firm\" updated", 'time': '2d ago • 8/17/2026, 6:19:26 PM'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final act = activities[index];
        return _buildTimelineItem(
          name: act['name']!,
          tag: act['tag']!,
          desc: act['desc']!,
          time: act['time']!,
          isLast: index == activities.length - 1,
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required String name,
    required String tag,
    required String desc,
    required String time,
    required bool isLast,
  }) {
    final isSuccess = tag == 'LOGIN';
    final isFailure = tag == 'LOGIN FAILED';
    
    Color statusColor;
    IconData nodeIcon;
    Color badgeBg;
    Color badgeText;
    
    if (isSuccess) {
      statusColor = const Color(0xFF10B981);
      nodeIcon = Icons.check_rounded;
      badgeBg = const Color(0xFFD1FAE5);
      badgeText = const Color(0xFF059669);
    } else if (isFailure) {
      statusColor = const Color(0xFFEF4444);
      nodeIcon = Icons.close_rounded;
      badgeBg = const Color(0xFFFEE2E2);
      badgeText = const Color(0xFFDC2626);
    } else {
      statusColor = const Color(0xFF3B82F6);
      nodeIcon = Icons.edit_rounded;
      badgeBg = const Color(0xFFEFF6FF);
      badgeText = const Color(0xFF2563EB);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  bottom: isLast ? null : 0,
                  height: isLast ? 28 : null,
                  child: Container(
                    width: 2,
                    color: AppColors.border.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  top: 16,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: statusColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        nodeIcon,
                        size: 14,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 4,
                          color: statusColor,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: AppTypography.titleMedium.copyWith(
                                          color: AppColors.primaryNavy,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: badgeBg,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tag,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: badgeText,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
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
                                const SizedBox(height: 10),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
