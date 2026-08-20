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
        subtitle: 'Complete audit log of actions in your firm',
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
                _buildHeaderActions(),
                const SizedBox(height: AppSpacing.s24),
                _buildActivityList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(Icons.play_circle_outline, color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 8),
              Text('Track Activity', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
              const SizedBox(width: 8),
              Switch(
                value: true,
                onChanged: (v) {},
                activeColor: const Color(0xFFFF8A00),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
          label: Text('Clear Log', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFEF4444))),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFEF2F2),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {'name': 'Haris khan', 'tag': 'LOGIN', 'desc': 'User logged in successfully', 'time': '3h ago • 8/20/2026, 9:36:12 AM'},
      {'name': 'Haris khan', 'tag': 'LOGIN', 'desc': 'User logged in successfully', 'time': '2d ago • 8/17/2026, 7:11:01 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:28 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:25 PM'},
      {'name': 'Haris khan', 'tag': 'LOGIN FAILED', 'desc': 'Invalid password', 'time': '2d ago • 8/17/2026, 7:10:11 PM'},
      {'name': 'Qanomy Admin (MA)', 'tag': 'LOGIN', 'desc': 'Administrator impersonated firm owner mahnoorakhtar002@gmail.com', 'time': '2d ago • 8/17/2026, 6:45:02 PM'},
      {'name': 'Haris khan', 'tag': 'UPDATED FIRM', 'desc': 'Firm "Khan\'s Firm" updated', 'time': '2d ago • 8/17/2026, 6:19:26 PM'},
    ];

    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 8, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.builder(
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
      ),
    );
  }

  Widget _buildTimelineItem({
    required String name,
    required String tag,
    required String desc,
    required String time,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Stack(
              children: [
                // Vertical line
                Positioned(
                  left: 24,
                  top: 0,
                  bottom: isLast ? null : 0,
                  height: isLast ? 40 : null, // Stop line at mid-point for last item
                  child: Container(width: 2, color: const Color(0xFFE2E8F0)),
                ),
                // Horizontal connecting line
                Positioned(
                  left: 24,
                  top: 40,
                  right: 0,
                  child: Container(height: 2, color: const Color(0xFFE2E8F0)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withOpacity(0.5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F9FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.description_outlined, color: Color(0xFF0EA5E9), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF), // Light blue bg
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(tag, style: AppTypography.labelSmall.copyWith(color: const Color(0xFF3B82F6), fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                              Text(desc, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(time, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
