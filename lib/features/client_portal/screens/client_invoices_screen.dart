import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../screens/client_portal_main_layout.dart';

class ClientInvoicesScreen extends StatefulWidget {
  const ClientInvoicesScreen({super.key});

  @override
  State<ClientInvoicesScreen> createState() => _ClientInvoicesScreenState();
}

class _ClientInvoicesScreenState extends State<ClientInvoicesScreen> {
  String _selectedStatusFilter = 'All Status';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _invoices = [
    {
      'no': 'INV-2026-4167',
      'case': 'Alia vs Adnan',
      'issue': '13-Aug-2026',
      'due': '22-Aug-2026',
      'amount': 'PKR 150,000',
      'paid': 'PKR 0',
      'status': 'Draft',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredInvoices {
    return _invoices.where((inv) {
      final matchesStatus = _selectedStatusFilter == 'All Status' || inv['status'] == _selectedStatusFilter;
      final query = _searchController.text.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          inv['no']!.toLowerCase().contains(query) ||
          inv['case']!.toLowerCase().contains(query) ||
          inv['amount']!.toLowerCase().contains(query);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Top App Bar Header (Matching Lawyer Portal dark navy layout)
            Container(
              color: AppColors.sidebarNavy,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 16,
                16,
                20,
              ),
              child: Row(
                children: [
                  if (isMobile)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                      onPressed: () => ClientPortalMainLayout.scaffoldKey.currentState?.openDrawer(),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoices & Payments',
                          style: AppTypography.header.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Dashboard',
                              style: AppTypography.captionInter.copyWith(color: Colors.white70, fontSize: 12),
                            ),
                            const Text(' • ', style: TextStyle(color: Colors.white38, fontSize: 12)),
                            Text(
                              'Invoices',
                              style: AppTypography.captionInter.copyWith(
                                color: AppColors.princetonOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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

            // Main Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Stat Cards Section (Matching Lawyer Section Styling)
                        _buildStatsCardsGrid(context),
                        const SizedBox(height: AppSpacing.s24),

                        // 2. Main Data Table Card (Filter Bar + Table Headers + Rows + Footer)
                        _buildMainTableCard(context),
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

  // Top 4 Stat Cards Matching Lawyer Invoices Screen Format
  Widget _buildStatsCardsGrid(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final card1 = _buildLawyerStyleStatCard(
      title: 'Total Invoices',
      value: '${_invoices.length}',
      subtitle: 'All Time',
      iconWidget: const Icon(Icons.description_outlined, color: Color(0xFFF97316), size: 18),
      bgColor: const Color(0xFFFFF0E6),
      trendColor: const Color(0xFFF97316),
    );

    final card2 = _buildLawyerStyleStatCard(
      title: 'Total Billed',
      value: 'PKR 150,000',
      subtitle: 'All Time',
      iconWidget: const Text('Rs', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13)),
      bgColor: const Color(0xFFEFF6FF),
      trendColor: const Color(0xFF2563EB),
    );

    final card3 = _buildLawyerStyleStatCard(
      title: 'Paid Amount',
      value: 'PKR 0',
      subtitle: 'All Time',
      iconWidget: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF10B981), size: 18),
      bgColor: const Color(0xFFECFDF5),
      trendColor: const Color(0xFF10B981),
    );

    final card4 = _buildLawyerStyleStatCard(
      title: 'Outstanding',
      value: 'PKR 150,000',
      subtitle: 'All Time',
      iconWidget: const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
      bgColor: const Color(0xFFFEF2F2),
      trendColor: const Color(0xFFEF4444),
    );

    if (isMobile) {
      return Column(
        children: [
          card1,
          const SizedBox(height: 12),
          card2,
          const SizedBox(height: 12),
          card3,
          const SizedBox(height: 12),
          card4,
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: card1),
              const SizedBox(width: 12),
              Expanded(child: card2),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: card3),
              const SizedBox(width: 12),
              Expanded(child: card4),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: card1),
        const SizedBox(width: 12),
        Expanded(child: card2),
        const SizedBox(width: 12),
        Expanded(child: card3),
        const SizedBox(width: 12),
        Expanded(child: card4),
      ],
    );
  }

  Widget _buildLawyerStyleStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Widget iconWidget,
    required Color bgColor,
    required Color trendColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: iconWidget,
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryNavy,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.trending_up, size: 12, color: trendColor),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: AppTypography.labelSmall.copyWith(color: trendColor, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Main Card Wrapper Containing Search Bar & Responsive Table
  Widget _buildMainTableCard(BuildContext context) {
    final filtered = _filteredInvoices;
    final isMobile = Responsive.isMobile(context);

    final Widget searchBox = Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: AppTypography.bodyInter.copyWith(
                fontSize: 13,
                color: AppColors.primaryNavy,
              ),
              decoration: InputDecoration(
                hintText: 'Search by invoice no., case, amount...',
                hintStyle: AppTypography.bodyInter.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
              onPressed: () => setState(() => _searchController.clear()),
            ),
        ],
      ),
    );

    final Widget statusDropdown = Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatusFilter,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy, size: 18),
          style: AppTypography.bodyInterMedium.copyWith(
            color: AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          onChanged: (val) {
            if (val != null) setState(() => _selectedStatusFilter = val);
          },
          items: ['All Status', 'Draft', 'Paid', 'Unpaid', 'Overdue']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Bar (Search Field & Status Dropdown)
          Padding(
            padding: const EdgeInsets.all(16),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      searchBox,
                      const SizedBox(height: 12),
                      statusDropdown,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: searchBox),
                      const SizedBox(width: 16),
                      statusDropdown,
                    ],
                  ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Scrollable Data Table matching Lawyer Invoices section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1050),
              child: Column(
                children: [
                  // Table Column Headers
                  Container(
                    color: const Color(0xFFF9FAFB),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        _buildTableHeader('#', flex: 1),
                        _buildTableHeader('INVOICE NO.', flex: 3),
                        _buildTableHeader('CASE', flex: 3),
                        _buildTableHeader('ISSUE DATE', flex: 2),
                        _buildTableHeader('DUE DATE', flex: 2),
                        _buildTableHeader('AMOUNT', flex: 2),
                        _buildTableHeader('PAID', flex: 2),
                        _buildTableHeader('STATUS', flex: 2, center: true),
                        _buildTableHeader('ACTIONS', flex: 2, center: true),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 1),

                  // Data Rows or Empty State
                  if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No invoices found matching your criteria.',
                            style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    ...filtered.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final inv = entry.value;

                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                // # Index
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '$index',
                                    style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                                  ),
                                ),
                                // Invoice No.
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    inv['no']!,
                                    style: AppTypography.bodyInterMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Case Name
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    inv['case']!,
                                    style: AppTypography.bodyInterMedium.copyWith(
                                      color: AppColors.primaryNavy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Issue Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    inv['issue']!,
                                    style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                // Due Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    inv['due']!,
                                    style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                // Amount
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    inv['amount']!,
                                    style: AppTypography.bodyInterMedium.copyWith(
                                      color: AppColors.primaryNavy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Paid
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    inv['paid']!,
                                    style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ),
                                // Status Pill Badge (Matching Lawyer Portal Tag Style)
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: _buildStatusBadge(inv['status']!),
                                  ),
                                ),
                                // Actions Buttons
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.textMuted, size: 18),
                                        onPressed: () {
                                          _showInvoiceDetailModal(context, inv);
                                        },
                                        tooltip: 'View Invoice',
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        padding: EdgeInsets.zero,
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(Icons.download_outlined, color: AppColors.textMuted, size: 18),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Downloading PDF for ${inv['no']}...'),
                                              backgroundColor: AppColors.primaryNavy,
                                            ),
                                          );
                                        },
                                        tooltip: 'Download PDF',
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.border, height: 1),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),

          // Footer Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Showing ${filtered.length} invoices',
              style: AppTypography.captionInter.copyWith(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {required int flex, bool center = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textSecondary;
    Color bgColor = Colors.white;

    if (status == 'Paid') {
      bgColor = const Color(0xFFECFDF5);
      textColor = const Color(0xFF10B981);
      borderColor = const Color(0xFFA7F3D0);
    } else if (status == 'Draft') {
      bgColor = Colors.white;
      textColor = AppColors.textSecondary;
      borderColor = AppColors.border;
    } else if (status == 'Unpaid' || status == 'Overdue') {
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFEF4444);
      borderColor = const Color(0xFFFCA5A5);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: AppTypography.captionInter.copyWith(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showInvoiceDetailModal(BuildContext context, Map<String, String> inv) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.princetonOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.receipt_long, color: AppColors.princetonOrange, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          inv['no']!,
                          style: AppTypography.header.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                _buildDetailRow('Case Title', inv['case']!),
                _buildDetailRow('Issue Date', inv['issue']!),
                _buildDetailRow('Due Date', inv['due']!),
                _buildDetailRow('Total Amount', inv['amount']!),
                _buildDetailRow('Amount Paid', inv['paid']!),
                _buildDetailRow('Status', inv['status']!),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading invoice ${inv['no']}...'),
                            backgroundColor: AppColors.primaryNavy,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Download Invoice', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13)),
          Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
