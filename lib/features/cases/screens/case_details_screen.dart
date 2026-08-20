import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';

class CaseDetailsScreen extends StatelessWidget {
  final String caseTitle;
  final String caseNo;
  final String status;

  const CaseDetailsScreen({
    super.key,
    required this.caseTitle,
    required this.caseNo,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Responsive(
                mobile: Column(
                  children: [
                    _buildTopLeftCard(context),
                    const SizedBox(height: AppSpacing.s24),
                    _buildQuickInfoCard(),
                  ],
                ),
                tablet: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildTopLeftCard(context)),
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(flex: 3, child: _buildQuickInfoCard()),
                  ],
                ),
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: _buildTopLeftCard(context)),
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(flex: 3, child: _buildQuickInfoCard()),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s32),
              _buildTabBar(),
              const SizedBox(height: AppSpacing.s32),
              Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, _) {
                      if (tabController.index == 0) {
                        return _buildCaseInfoTab(context);
                      }
                      return Container(
                        padding: const EdgeInsets.all(48),
                        alignment: Alignment.center,
                        child: Text(
                          'Content for this tab is coming soon.',
                          style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryNavy,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Case Detail', style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24)),
              ],
            ),
          ),
          if (!Responsive.isMobile(context))
            Row(
              children: [
                _buildActionButton(Icons.notifications_none, 'Add Reminder', AppColors.blueGreen, true),
                const SizedBox(width: 12),
                _buildActionButton(Icons.edit_outlined, 'Edit Case', Colors.white, false),
                const SizedBox(width: 12),
                _buildActionButton(Icons.more_vert, 'More', Colors.white, false),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: isPrimary ? Colors.white : AppColors.primaryNavy),
      label: Text(label, style: AppTypography.bodyInterMedium.copyWith(color: isPrimary ? Colors.white : AppColors.primaryNavy, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? color : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  Widget _buildTopLeftCard(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD180), Color(0xFFFF9100)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFF9100).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.account_balance, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(caseTitle, style: AppTypography.header.copyWith(color: AppColors.primaryNavy, fontSize: 22)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Case ID: $caseNo', style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildStatusBadge(status),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFFFC107).withOpacity(0.3)),
                          ),
                          child: Text(
                            'Medium Priority',
                            style: AppTypography.labelSmall.copyWith(color: const Color(0xFFF57F17), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: 24),
          Wrap(
            spacing: 32,
            runSpacing: 24,
            children: [
              _buildInfoColumn(Icons.account_balance_outlined, 'Court', 'Peshawar High Court'),
              _buildInfoColumn(Icons.calendar_month_outlined, 'Next Hearing', 'No upcoming hearing'),
              _buildInfoColumn(Icons.gavel_outlined, 'Case Type', 'NAB / Cybercrime'),
              _buildInfoColumn(Icons.person_outline, 'Assigned Lawyer', 'Fatima'),
              _buildInfoColumn(Icons.people_outline, 'Opposite Party', 'Adnan'),
              _buildInfoColumn(Icons.person_pin_outlined, 'Judge Name', 'Asim'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Info', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoColumn(Icons.calendar_today, 'Filing Date', '13 Aug 2026')),
              Expanded(child: _buildInfoColumn(Icons.person, 'Client', 'Hamad Client')),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoColumn(Icons.gavel, 'Case Result', 'Pending Result'),
          const SizedBox(height: 24),
          _buildInfoColumn(Icons.info_outline, 'Result Details', 'No details available.'),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: const Color(0xFF00A980),
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: const Color(0xFF00A980),
        indicatorWeight: 3,
        labelStyle: AppTypography.bodyInterMedium.copyWith(fontSize: 14),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Case Info'),
          Tab(text: 'Hearing History (1)'),
          Tab(text: 'Documents (3)'),
          Tab(text: 'Notes'),
          Tab(text: 'Client Info'),
          Tab(text: 'Invoices (2)'),
          Tab(text: 'Activity Log'),
        ],
      ),
    );
  }

  Widget _buildCaseInfoTab(BuildContext context) {
    return Responsive(
      mobile: Column(
        children: [
          _buildCaseInformationCard(context),
          const SizedBox(height: AppSpacing.s24),
          _buildTimelineCard(),
        ],
      ),
      tablet: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: _buildCaseInformationCard(context)),
          const SizedBox(width: AppSpacing.s24),
          Expanded(flex: 3, child: _buildTimelineCard()),
        ],
      ),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: _buildCaseInformationCard(context)),
          const SizedBox(width: AppSpacing.s24),
          Expanded(flex: 3, child: _buildTimelineCard()),
        ],
      ),
    );
  }

  Widget _buildCaseInformationCard(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    Widget buildRow(Widget child1, Widget child2) {
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child1,
            const SizedBox(height: 24),
            child2,
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child1),
            Expanded(child: child2),
          ],
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Case Information', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildRow(
                  _buildGridItem('CASE TITLE', caseTitle),
                  _buildGridItem('COURT', 'Peshawar High Court'),
                ),
                const SizedBox(height: 32),
                buildRow(
                  _buildGridItem('CASE TYPE', 'NAB / Cybercrime'),
                  _buildGridItem('FILING DATE', '13 Aug 2026'),
                ),
                const SizedBox(height: 32),
                buildRow(
                  _buildGridItem('NEXT HEARING DATE', 'No upcoming hearing'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CASE STATUS', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      _buildStatusBadge(status),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                buildRow(
                  _buildGridItem('CASE RESULT', 'Pending Result'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PRIORITY', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFFFC107)),
                        ),
                        child: Text(
                          'MEDIUM',
                          style: AppTypography.labelSmall.copyWith(color: const Color(0xFFF57F17), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                buildRow(
                  _buildGridItem('ASSIGNED LAWYER', 'Fatima'),
                  _buildGridItem('CLIENT', 'Hamad Client'),
                ),
                const SizedBox(height: 32),
                Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                const SizedBox(height: 24),
                _buildGridItem('DESCRIPTION / REMARKS', 'No description or remarks available.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14)),
      ],
    );
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
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
            children: [
              Text('Timeline', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
              const SizedBox(width: 8),
              Text('(Latest Activity)', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimelineItem(Icons.receipt_outlined, const Color(0xFFFFC107), 'Invoice Issued', 'Invoice INV-2026-1210 issued...', '13 Aug 2026, 02:59 pm', isLast: false),
          _buildTimelineItem(Icons.receipt_outlined, const Color(0xFFFFC107), 'Invoice Issued', 'Invoice INV-2026-4167 issue...', '13 Aug 2026, 02:58 pm', isLast: false),
          _buildTimelineItem(Icons.description_outlined, const Color(0xFFF06292), 'Document Uploaded', 'audit_logs', '13 Aug 2026, 02:31 pm', isLast: false),
          _buildTimelineItem(Icons.description_outlined, const Color(0xFFF06292), 'Document Uploaded', 'Convert_it_into_a_video_with_d', '13 Aug 2026, 02:31 pm', isLast: true),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('View Full Timeline', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryNavy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(IconData icon, Color color, String title, String subtitle, String time, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(time, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'REOPEN':
      case 'PAID':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF00A980);
        break;
      case 'DRAFT':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFD32F2F);
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
