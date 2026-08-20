import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class CaseHistoryScreen extends StatelessWidget {
  const CaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Case History',
        showBackButton: true,
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
                _buildFilterBar(context),
                const SizedBox(height: AppSpacing.s24),
                _buildHistoryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              height: 44,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search by case title, client, court...',
                  hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: const Color(0xFF00A980)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (!isMobile) ...[
              _buildDropdown('Court (All)'),
              const SizedBox(width: 12),
              _buildDropdown('Case Type (All)'),
              const SizedBox(width: 12),
              _buildDropdown('Assigned Lawyer (All)'),
            ],
          ],
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh, size: 18, color: AppColors.textSecondary),
          label: Text('Reset', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hint, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
          const SizedBox(width: 12),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    final List<Map<String, String>> dummyCases = [
      {
        'title': 'Sajida vs Fahad',
        'status': 'CLOSED (WIN)',
        'client': 'Arooj Client\n03008383388',
        'oppositeParty': 'Fahad',
        'court': 'District & Sessions Court, Multan',
        'caseType': 'NAB / Cybercrime',
        'judge': 'Murtaza',
        'lawyer': 'Ejaz',
      },
      {
        'title': 'State vs Muhammad Ali',
        'status': 'CLOSED (WIN)',
        'client': 'Muhammad Ali\n03214567890',
        'oppositeParty': 'The State',
        'court': 'High Court, Lahore',
        'caseType': 'Criminal Appeal',
        'judge': 'Rizwan',
        'lawyer': 'Ejaz',
      },
      {
        'title': 'Zainab Bibi vs K-Electric',
        'status': 'CLOSED (WIN)',
        'client': 'Zainab Bibi\n03339876543',
        'oppositeParty': 'K-Electric Ltd.',
        'court': 'Consumer Court, Karachi',
        'caseType': 'Civil Suit / Damages',
        'judge': 'Farooq',
        'lawyer': 'M. Imran',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyCases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final c = dummyCases[index];
        return CaseHistoryCard(
          title: c['title']!,
          status: c['status']!,
          client: c['client']!,
          oppositeParty: c['oppositeParty']!,
          court: c['court']!,
          caseType: c['caseType']!,
          judge: c['judge']!,
          lawyer: c['lawyer']!,
        );
      },
    );
  }
}

class CaseHistoryCard extends StatefulWidget {
  final String title;
  final String status;
  final String client;
  final String oppositeParty;
  final String court;
  final String caseType;
  final String judge;
  final String lawyer;

  const CaseHistoryCard({
    super.key,
    required this.title,
    required this.status,
    required this.client,
    required this.oppositeParty,
    required this.court,
    required this.caseType,
    required this.judge,
    required this.lawyer,
  });

  @override
  State<CaseHistoryCard> createState() => _CaseHistoryCardState();
}

class _CaseHistoryCardState extends State<CaseHistoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Always Visible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF00A980).withOpacity(0.3)),
                      ),
                      child: Text(
                        widget.status,
                        style: AppTypography.labelSmall.copyWith(color: const Color(0xFF00A980), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
                // Collapsible Content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: GestureDetector(
                    onTap: () {}, // Swallows taps on the inner details container so it doesn't collapse
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.s16),
                        Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                        const SizedBox(height: AppSpacing.s16),
                        
                        // Details Grid
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoColumn('Client', widget.client),
                              const SizedBox(height: 12),
                              _buildInfoColumn('Opposite Party', widget.oppositeParty),
                              const SizedBox(height: 12),
                              _buildInfoColumn('Court', widget.court),
                              const SizedBox(height: 12),
                              _buildInfoColumn('Case Type', widget.caseType),
                              const SizedBox(height: 12),
                              _buildInfoColumn('Judge', widget.judge),
                              const SizedBox(height: 12),
                              _buildInfoColumn('Lawyer', widget.lawyer),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildInfoColumn('Client', widget.client)),
                              Expanded(flex: 2, child: _buildInfoColumn('Opposite Party', widget.oppositeParty)),
                              Expanded(flex: 3, child: _buildInfoColumn('Court', widget.court)),
                              Expanded(flex: 2, child: _buildInfoColumn('Case Type', widget.caseType)),
                              Expanded(flex: 2, child: _buildInfoColumn('Judge', widget.judge)),
                              Expanded(flex: 2, child: _buildInfoColumn('Lawyer', widget.lawyer)),
                            ],
                          ),
                          
                        const SizedBox(height: AppSpacing.s16),
                        Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                        const SizedBox(height: AppSpacing.s16),
                        
                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.textSecondary, size: 20),
                              tooltip: 'View Details',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                              tooltip: 'Edit Case',
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFF59E0B)), // Amber/Orange
                              label: Text('Reopen', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFF59E0B)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }
}
