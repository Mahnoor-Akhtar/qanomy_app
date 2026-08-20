import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import '../../navigation/main_layout.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: QanomyAppBar(
        title: 'Invoices & Billing',
        actions: [
          QanomyAppBarButton(
            label: 'Export',
            icon: Icons.file_download_outlined,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00A980),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatsCards(context),
                const SizedBox(height: AppSpacing.s24),
                _buildTableSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    int crossAxisCount = 4;
    if (isMobile) crossAxisCount = 2;
    if (isTablet) crossAxisCount = 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isMobile ? 1.4 : (isTablet ? 2.0 : 2.5),
      children: [
        _buildStatCard('Total Invoices', '5', 'All time', Icons.description_outlined, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
        _buildStatCard('Total Billed', 'PKR 350,000', 'All time', Icons.currency_rupee, const Color(0xFF3B82F6), const Color(0xFFDBEAFE)),
        _buildStatCard('Paid Amount', 'PKR 50,000', 'All time', Icons.credit_card_outlined, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
        _buildStatCard('Outstanding', 'PKR 250,000', 'Unpaid', Icons.error_outline, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.8),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.trending_up, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: AppTypography.labelSmall.copyWith(color: iconColor, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(BuildContext context) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildFilterBar(),
          ),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: _buildDataTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border.withOpacity(0.5)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by invoice no., client, case...',
                hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
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
              Text('All Status', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
              const SizedBox(width: 12),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    final invoices = [
      {'no': 'INV-2026-4167', 'client': 'Hamad Client', 'case': 'Alia vs Adnan', 'issue': '13-Aug-2026', 'due': '22-Aug-2026', 'amount': 'PKR 150,000', 'paid': 'PKR 0', 'status': 'Draft'},
      {'no': 'INV-2026-1192', 'client': 'Arooj Client', 'case': 'Ali vs Babar', 'issue': '13-Aug-2026', 'due': '21-Aug-2026', 'amount': 'PKR 20,000', 'paid': 'PKR 0', 'status': 'Draft'},
      {'no': 'INV-2026-8724', 'client': 'Muhammad Ali', 'case': 'Momina vs Muheeb', 'issue': '13-Aug-2026', 'due': '05-Sept-2026', 'amount': 'PKR 70,000', 'paid': 'PKR 0', 'status': 'Draft'},
      {'no': 'INV-2026-7899', 'client': 'Arooj Client', 'case': 'Ali vs Ahmed', 'issue': '13-Aug-2026', 'due': '04-Sept-2026', 'amount': 'PKR 60,000', 'paid': 'PKR 0', 'status': 'Draft'},
      {'no': 'INV-2026-1310', 'client': 'Arooj Client', 'case': 'Alia vs Adnan', 'issue': '13-Aug-2026', 'due': '02-Sept-2026', 'amount': 'PKR 50,000', 'paid': 'PKR 50,000', 'status': 'Paid'},
    ];

    return DataTable(
      headingRowHeight: 56,
      dataRowMaxHeight: 64,
      dataRowMinHeight: 64,
      horizontalMargin: 24,
      columnSpacing: 24,
      headingTextStyle: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
      columns: const [
        DataColumn(label: Text('#')),
        DataColumn(label: Text('INVOICE NO.')),
        DataColumn(label: Text('CLIENT')),
        DataColumn(label: Text('CASE')),
        DataColumn(label: Text('ISSUE DATE')),
        DataColumn(label: Text('DUE DATE')),
        DataColumn(label: Text('AMOUNT')),
        DataColumn(label: Text('PAID')),
        DataColumn(label: Text('STATUS')),
        DataColumn(label: Text('ACTIONS')),
      ],
      rows: invoices.asMap().entries.map((entry) {
        final index = entry.key;
        final inv = entry.value;
        final isPaid = inv['status'] == 'Paid';
        
        return DataRow(
          cells: [
            DataCell(Text('${index + 1}', style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
            DataCell(Text(inv['no']!, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
            DataCell(Text(inv['client']!, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
            DataCell(Text(inv['case']!, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
            DataCell(Text(inv['issue']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
            DataCell(Text(inv['due']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
            DataCell(Text(inv['amount']!, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13))),
            DataCell(Text(inv['paid']!, style: AppTypography.bodyInterMedium.copyWith(color: isPaid ? const Color(0xFF10B981) : const Color(0xFF10B981), fontSize: 13))), // Green color for Paid amounts
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9), // Light green vs Light grey
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  inv['status']!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isPaid ? const Color(0xFF10B981) : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: AppColors.textSecondary),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.download_outlined, size: 18, color: AppColors.textSecondary),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
