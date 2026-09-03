import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../models/case_model.dart';
import '../services/case_service.dart';
import '../widgets/case_list_item.dart';
import 'add_case_screen.dart';
import 'case_details_screen.dart';
import 'case_history_screen.dart';

enum CaseActionMode { none, edit, delete }

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  CaseActionMode _actionMode = CaseActionMode.none;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _animationController,
    );
    CaseService.instance.fetchCasesFromBackend();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFabMenu() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _closeFabMenu() {
    if (_animationController.isCompleted || _animationController.isAnimating) {
      _animationController.reverse();
    }
  }

  void _openAddCaseScreen() async {
    _closeFabMenu();
    setState(() {
      _actionMode = CaseActionMode.none;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCaseScreen()),
    );
  }

  void _navigateToEditScreen(CaseModel caseItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddCaseScreen(initialCase: caseItem)),
    );
  }

  void _toggleEditMode() {
    _closeFabMenu();
    setState(() {
      if (_actionMode == CaseActionMode.edit) {
        _actionMode = CaseActionMode.none;
      } else {
        _actionMode = CaseActionMode.edit;
      }
    });
  }

  void _toggleDeleteMode() {
    _closeFabMenu();
    setState(() {
      if (_actionMode == CaseActionMode.delete) {
        _actionMode = CaseActionMode.none;
      } else {
        _actionMode = CaseActionMode.delete;
      }
    });
  }

  void _confirmDeleteCase(CaseModel caseItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete case "${caseItem.displayTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              CaseService.instance.deleteCase(caseItem.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Case "${caseItem.displayTitle}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCaseOptionsSheet(CaseModel caseItem) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caseItem.displayTitle,
              style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
            ),
            Text('ID: ${caseItem.caseIdNo}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.remove_red_eye_outlined, color: AppColors.primaryNavy),
              title: const Text('View Case Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CaseDetailsScreen(
                      caseTitle: caseItem.displayTitle,
                      caseNo: caseItem.caseIdNo.isEmpty ? 'ABBD87AA' : caseItem.caseIdNo,
                      status: caseItem.status.toUpperCase(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Color(0xFFFF8A00)),
              title: const Text('Edit Case'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEditScreen(caseItem);
              },
            ),
            ListTile(
              leading: Icon(
                caseItem.isFavorite ? Icons.star : Icons.star_border,
                color: AppColors.navOrange,
              ),
              title: Text(caseItem.isFavorite ? 'Unstar Case' : 'Star Case'),
              onTap: () {
                Navigator.pop(context);
                CaseService.instance.toggleFavorite(caseItem.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Case', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteCase(caseItem);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<CaseModel> _filterCases(List<CaseModel> cases, {bool myCasesOnly = false}) {
    final query = _searchController.text.toLowerCase().trim();
    return cases.where((c) {
      final title = c.displayTitle.toLowerCase();
      final caseId = c.caseIdNo.toLowerCase();
      final client = c.client.toLowerCase();
      final assignee = c.assignee.toLowerCase();

      final matchesSearch = query.isEmpty ||
          title.contains(query) ||
          caseId.contains(query) ||
          client.contains(query) ||
          assignee.contains(query);

      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: QanomyAppBar(
          title: 'Cases',
          actions: [
            QanomyAppBarButton(
              label: 'History',
              icon: Icons.history_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CaseHistoryScreen()),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildExpandableFab(),
        body: Column(
          children: [
            const SizedBox(height: AppSpacing.s16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppSpacing.s16),
                          const Icon(
                            Icons.search,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Search by case title, ID, client...',
                                hintStyle: AppTypography.bodyInter.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: AppTypography.bodyInter.copyWith(
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.5),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mode Active Banner Indicator
            if (_actionMode != CaseActionMode.none) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _actionMode == CaseActionMode.edit
                        ? const Color(0xFFFF8A00).withOpacity(0.12)
                        : Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _actionMode == CaseActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _actionMode == CaseActionMode.edit ? Icons.edit_outlined : Icons.delete_outline,
                        color: _actionMode == CaseActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _actionMode == CaseActionMode.edit
                              ? 'Edit Mode Active — tap pencil on any case'
                              : 'Delete Mode Active — tap trash on any case',
                          style: AppTypography.bodyInterMedium.copyWith(
                            fontSize: 13,
                            color: _actionMode == CaseActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _actionMode = CaseActionMode.none),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _actionMode == CaseActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.s16),

            // Tabs
            TabBar(
              indicatorColor: AppColors.princetonOrange,
              indicatorWeight: 3,
              labelColor: AppColors.primaryNavy,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: AppTypography.labelSmall,
              dividerColor: AppColors.border.withOpacity(0.3),
              tabs: const [
                Tab(text: 'All Cases'),
                Tab(text: 'My Cases'),
              ],
            ),

            // Tab Views
            Expanded(
              child: ValueListenableBuilder<List<CaseModel>>(
                valueListenable: CaseService.instance,
                builder: (context, allCases, _) {
                  return TabBarView(
                    children: [
                      _buildCasesList(_filterCases(allCases, myCasesOnly: false)),
                      _buildCasesList(_filterCases(allCases, myCasesOnly: true)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableFab() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double progress = _expandAnimation.value;

        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (progress > 0.01) ...[
                // 1. Add Case (Directly Above main button)
                Positioned(
                  bottom: 60 * progress,
                  right: 0,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Add Case',
                        icon: Icons.add,
                        onPressed: _openAddCaseScreen,
                      ),
                    ),
                  ),
                ),

                // 2. Edit Case (Top-Left Diagonal)
                Positioned(
                  bottom: 50 * progress,
                  right: 50 * progress,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Edit Case',
                        icon: Icons.edit_outlined,
                        onPressed: _toggleEditMode,
                      ),
                    ),
                  ),
                ),

                // 3. Delete Case (Directly Left)
                Positioned(
                  bottom: 0,
                  right: 60 * progress,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Delete Case',
                        icon: Icons.delete_outline,
                        onPressed: _toggleDeleteMode,
                      ),
                    ),
                  ),
                ),
              ],

              // Main Trigger Button (Bottom-Right corner)
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: FloatingActionButton(
                    heroTag: 'main_case_fab',
                    onPressed: _toggleFabMenu,
                    backgroundColor: const Color(0xFFFF8A00),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: AnimatedRotation(
                      turns: progress * 0.25,
                      duration: Duration.zero,
                      child: Icon(
                        progress > 0.5 ? Icons.close : Icons.menu,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionIconButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FloatingActionButton(
        heroTag: label,
        onPressed: onPressed,
        tooltip: label,
        backgroundColor: const Color(0xFFFF8A00),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCasesList(List<CaseModel> cases) {
    return RefreshIndicator(
      onRefresh: () => CaseService.instance.fetchCasesFromBackend(),
      child: cases.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'No cases found',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.s24),
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index];
                return CaseListItem(
                  caseItem: caseData,
                  showEditButton: _actionMode == CaseActionMode.edit,
                  showDeleteButton: _actionMode == CaseActionMode.delete,
                  onEdit: () => _navigateToEditScreen(caseData),
                  onDelete: () => _confirmDeleteCase(caseData),
                  onLongPress: () => _showCaseOptionsSheet(caseData),
                );
              },
            ),
    );
  }
}
