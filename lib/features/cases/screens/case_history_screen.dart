import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../navigation/main_layout.dart';
import '../models/case_model.dart';
import '../services/case_service.dart';
import 'case_details_screen.dart';
import 'add_case_screen.dart';

class CaseHistoryScreen extends StatefulWidget {
  const CaseHistoryScreen({super.key});

  @override
  State<CaseHistoryScreen> createState() => _CaseHistoryScreenState();
}

class _CaseHistoryScreenState extends State<CaseHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _historyCases = [
    {
      'title': 'Sajida vs Fahad',
      'firstParty': 'Sajida',
      'oppositeParty': 'Fahad',
      'status': 'CLOSED (WIN)',
      'client': 'Arooj Client\n03008383388',
      'court': 'District & Sessions Court, Multan',
      'caseType': 'NAB / Cybercrime',
      'judge': 'Murtaza',
      'lawyer': 'Ejaz',
    },
    {
      'title': 'State vs Muhammad Ali',
      'firstParty': 'State',
      'oppositeParty': 'Muhammad Ali',
      'status': 'CLOSED (WIN)',
      'client': 'Muhammad Ali\n03214567890',
      'court': 'High Court, Lahore',
      'caseType': 'Criminal Appeal',
      'judge': 'Rizwan',
      'lawyer': 'Ejaz',
    },
    {
      'title': 'Zainab Bibi vs K-Electric',
      'firstParty': 'Zainab Bibi',
      'oppositeParty': 'K-Electric Ltd.',
      'status': 'CLOSED (WIN)',
      'client': 'Zainab Bibi\n03339876543',
      'court': 'Consumer Court, Karachi',
      'caseType': 'Civil Suit / Damages',
      'judge': 'Farooq',
      'lawyer': 'M. Imran',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reopenCase(Map<String, String> c) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.refresh, color: Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              Text('Reopen Case', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy)),
            ],
          ),
          content: Text(
            'Are you sure you want to reopen "${c['title']}"?\n\nThis case will be moved from Case History to the active Cases module.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
            ),
            ElevatedButton(
              onPressed: () {
                // 1. Remove from local history list
                setState(() {
                  _historyCases.removeWhere((item) => item['title'] == c['title']);
                });

                // 2. Move case into CaseService (active Cases module)
                final newCase = CaseModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  caseIdNo: 'Case-2024-00${DateTime.now().second % 100}',
                  firstParty: c['firstParty'] ?? c['title']!.split(' vs ').first,
                  oppositeParty: c['oppositeParty'] ?? c['title']!.split(' vs ').last,
                  courtType: c['court'] ?? '',
                  caseType: c['caseType'] ?? '',
                  client: c['client'] ?? '',
                  assignee: c['lawyer'] ?? 'Unassigned',
                  status: 'Running',
                  hearingDate: DateTime.now().add(const Duration(days: 2)),
                );
                CaseService.instance.addCase(newCase);

                Navigator.pop(context); // Close dialog

                // 3. Show feedback & navigation option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Case "${c['title']}" reopened and moved to Cases module!'),
                    action: SnackBarAction(
                      label: 'VIEW CASES',
                      textColor: const Color(0xFF00A980),
                      onPressed: () {
                        MainLayout.instance?.switchTab(1); // Navigate to Cases screen
                      },
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text('Reopen Case', style: AppTypography.bodyInterSemiBold.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCase(Map<String, String> c) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text('Delete Record', style: AppTypography.titleMedium.copyWith(color: Colors.redAccent)),
            ],
          ),
          content: Text(
            'Are you sure you want to delete the record for "${c['title']}"?\n\nThis action cannot be undone.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancel', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _historyCases.removeWhere((item) => item['title'] == c['title']);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Record "${c['title']}" deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text('Delete', style: AppTypography.bodyInterSemiBold.copyWith(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CaseModel>>(
      valueListenable: CaseService.instance,
      builder: (context, activeCases, _) {
        final closedFromService = activeCases.where((c) {
          final st = c.status.toLowerCase();
          return st.startsWith('closed') || st.startsWith('disposed');
        }).map((c) => {
          'title': c.displayTitle,
          'firstParty': c.firstParty,
          'oppositeParty': c.oppositeParty,
          'status': c.status.toUpperCase(),
          'client': c.client.isNotEmpty ? c.client : 'Client',
          'court': c.courtType.isNotEmpty ? c.courtType : 'High Court',
          'caseType': c.caseType.isNotEmpty ? c.caseType : 'Civil',
          'judge': c.judges.isNotEmpty ? c.judges.first : 'Honorable Judge',
          'lawyer': c.assignee,
        }).toList();

        final allHistoryCases = [...closedFromService, ..._historyCases];

        final filteredCases = allHistoryCases.where((c) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return c['title']!.toLowerCase().contains(q) ||
              c['client']!.toLowerCase().contains(q) ||
              c['court']!.toLowerCase().contains(q) ||
              c['lawyer']!.toLowerCase().contains(q);
        }).toList();

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
                    if (filteredCases.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.history_outlined, size: 56, color: AppColors.textMuted.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'No history cases found',
                              style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCases.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final c = filteredCases[index];
                          return CaseHistoryCard(
                            title: c['title']!,
                            status: c['status']!,
                            client: c['client']!,
                            oppositeParty: c['oppositeParty']!,
                            court: c['court']!,
                            caseType: c['caseType']!,
                            judge: c['judge']!,
                            lawyer: c['lawyer']!,
                            onReopen: () => _reopenCase(c),
                            onDelete: () => _deleteCase(c),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search by case title, client, court...',
                  hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00A980)),
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
          onPressed: () {
            setState(() {
              _searchController.clear();
              _searchQuery = '';
            });
          },
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
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
  final VoidCallback onReopen;
  final VoidCallback onDelete;

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
    required this.onReopen,
    required this.onDelete,
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
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
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
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF00A980).withValues(alpha: 0.3)),
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
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.s16),
                        Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
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
                        Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
                        const SizedBox(height: AppSpacing.s16),
                        
                        // Actions Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CaseDetailsScreen(
                                      caseTitle: widget.title,
                                      caseNo: 'Case-2024-001',
                                      status: widget.status,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.textSecondary, size: 20),
                              tooltip: 'View Details',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCaseScreen(
                                      initialCase: CaseModel(
                                        id: 'hist-edit',
                                        caseIdNo: 'Case-2024-001',
                                        firstParty: widget.title.contains(' vs ') ? widget.title.split(' vs ').first : widget.title,
                                        oppositeParty: widget.title.contains(' vs ') ? widget.title.split(' vs ').last : '',
                                        courtType: widget.court,
                                        caseType: widget.caseType,
                                        client: widget.client.split('\n').first,
                                        assignee: widget.lawyer,
                                        status: widget.status,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                              tooltip: 'Edit Case',
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: widget.onReopen,
                              icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFF59E0B)),
                              label: Text('Reopen', style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFF59E0B)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              onSelected: (value) {
                                switch (value) {
                                  case 'view':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CaseDetailsScreen(
                                          caseTitle: widget.title,
                                          caseNo: 'Case-2024-001',
                                          status: widget.status,
                                        ),
                                      ),
                                    );
                                    break;
                                  case 'edit':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddCaseScreen(
                                          initialCase: CaseModel(
                                            id: 'hist-edit',
                                            caseIdNo: 'Case-2024-001',
                                            firstParty: widget.title.contains(' vs ') ? widget.title.split(' vs ').first : widget.title,
                                            oppositeParty: widget.title.contains(' vs ') ? widget.title.split(' vs ').last : '',
                                            courtType: widget.court,
                                            caseType: widget.caseType,
                                            client: widget.client.split('\n').first,
                                            assignee: widget.lawyer,
                                            status: widget.status,
                                          ),
                                        ),
                                      ),
                                    );
                                    break;
                                  case 'reopen':
                                    widget.onReopen();
                                    break;
                                  case 'delete':
                                    widget.onDelete();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye_outlined, size: 18, color: AppColors.primaryNavy),
                                      SizedBox(width: 10),
                                      Text('View Details'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryNavy),
                                      SizedBox(width: 10),
                                      Text('Edit Case'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'reopen',
                                  child: Row(
                                    children: [
                                      Icon(Icons.refresh, size: 18, color: Color(0xFFF59E0B)),
                                      SizedBox(width: 10),
                                      Text('Reopen Case', style: TextStyle(color: Color(0xFFF59E0B))),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                      SizedBox(width: 10),
                                      Text('Delete Record', style: TextStyle(color: Colors.redAccent)),
                                    ],
                                  ),
                                ),
                              ],
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
