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
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Top App Bar
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
                          style: AppTypography.header.copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dashboard • Invoices',
                          style: AppTypography.captionInter.copyWith(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Top Stat Cards Row (Exact data from user screenshot)
                        _buildStatCardsRow(context),
                        const SizedBox(height: AppSpacing.s24),

                        // 2. Table Section Card (Search, Filter, Table Headers, Row, Footer)
                        _buildInvoicesTableCard(context),
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

  // Top 4 Stat Cards matching user screenshot
  Widget _buildStatCardsRow(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    int crossAxisCount = 4;
    if (isMobile) crossAxisCount = 1;
    else if (isTablet) crossAxisCount = 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 2.6 : 2.2,
      children: [
        _buildStatCard(
          title: 'Total Invoices',
          value: '1',
          subtitle: 'All Time',
          iconWidget: const Icon(Icons.description_outlined, color: AppColors.princetonOrange, size: 20),
          bgColor: const Color(0xFFFFF0E6),
        ),
        _buildStatCard(
          title: 'Total Billed',
          value: 'PKR 150,000',
          subtitle: 'All Time',
          iconWidget: const Text('Rs', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13)),
          bgColor: const Color(0xFFEFF6FF),
        ),
        _buildStatCard(
          title: 'Paid Amount',
          value: 'PKR 0',
          subtitle: 'All Time',
          iconWidget: const Icon(Icons.credit_card_outlined, color: Color(0xFF10B981), size: 20),
          bgColor: const Color(0xFFECFDF5),
        ),
        _buildStatCard(
          title: 'Outstanding',
          value: 'PKR 150,000',
          subtitle: 'All Time',
          iconWidget: const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
          bgColor: const Color(0xFFFEF2F2),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Widget iconWidget,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.captionInter.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.header.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.captionInter.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Table Section matching lawyer portal formatting
  Widget _buildInvoicesTableCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Header Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Search Input Field
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by invoice no., case, amount...',
                              hintStyle: AppTypography.bodyInter.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: AppTypography.bodyInter.copyWith(fontSize: 13, color: AppColors.primaryNavy),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Status Filter Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
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
                      items: ['All Status', 'Paid', 'Draft', 'Pending']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Scrollable Data Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: Column(
                children: [
                  // Table Column Headers
                  Container(
                    color: const Color(0xFFF9FAFB),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

                  // Data Rows
                  ..._invoices.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final inv = entry.value;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                              // Invoice No
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
                                  style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ),
                              // Due Date
                              Expanded(
                                flex: 2,
                                child: Text(
                                  inv['due']!,
                                  style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 12),
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
                              // Status Badge Tag (Outline rounded tag as per screenshot)
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Text(
                                      inv['status']!,
                                      style: AppTypography.captionInter.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
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
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Viewing ${inv['no']}...')),
                                        );
                                      },
                                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                      padding: EdgeInsets.zero,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.download_rounded, color: AppColors.textMuted, size: 18),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Downloading ${inv['no']}...')),
                                        );
                                      },
                                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              'Showing ${_invoices.length} invoices',
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
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
