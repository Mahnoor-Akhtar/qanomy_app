import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String name;
  final String type;
  final String cnic;
  final String phone;
  final String email;

  const ClientDetailsScreen({
    super.key,
    required this.name,
    required this.type,
    required this.cnic,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: AppBar(
          backgroundColor: AppColors.sidebarNavy,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 80,
          title: Text('Client Detail', style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopCard(context),
              const SizedBox(height: AppSpacing.s32),
              _buildTabBar(),
              const SizedBox(height: AppSpacing.s32),
              Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, _) {
                      switch (tabController.index) {
                        case 0:
                          return Responsive(
                            mobile: _buildMobileContent(context),
                            tablet: _buildDesktopContent(context),
                            desktop: _buildDesktopContent(context),
                          );
                        case 1:
                          return _buildCasesTab();
                        case 2:
                          return _buildInvoicesTab();
                        default:
                          return Container(
                            padding: const EdgeInsets.all(48),
                            alignment: Alignment.center,
                            child: Text(
                              'Content for this tab is coming soon.',
                              style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                            ),
                          );
                      }
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

  Widget _buildTopCard(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s32),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8ECAE6), Color(0xFF219EBC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF219EBC).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      name.substring(0, 2).toUpperCase(),
                      style: AppTypography.header.copyWith(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpacing.s16,
                        runSpacing: AppSpacing.s8,
                        children: [
                          Text(name, style: AppTypography.header.copyWith(color: AppColors.primaryNavy, fontSize: 26)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.pastelGreen,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF00A980).withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.circle, size: 8, color: Color(0xFF00A980)),
                                const SizedBox(width: 6),
                                Text(
                                  'ACTIVE',
                                  style: AppTypography.labelSmall.copyWith(color: const Color(0xFF00A980), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('$type Client', style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.s16 : AppSpacing.s32, vertical: AppSpacing.s24),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: isMobile
                ? Wrap(
                    spacing: AppSpacing.s24,
                    runSpacing: AppSpacing.s24,
                    children: [
                      SizedBox(width: 140, child: _buildTopInfoItem(Icons.credit_card_outlined, 'CNIC', cnic)),
                      SizedBox(width: 140, child: _buildTopInfoItem(Icons.phone_outlined, 'WHATSAPP', phone)),
                      SizedBox(width: 140, child: _buildTopInfoItem(Icons.email_outlined, 'EMAIL', email)),
                      SizedBox(width: 140, child: _buildTopInfoItem(Icons.location_city_outlined, 'CITY', 'Lahore')),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildTopInfoItem(Icons.credit_card_outlined, 'CNIC', cnic)),
                      _buildVerticalDivider(),
                      Expanded(child: _buildTopInfoItem(Icons.phone_outlined, 'WHATSAPP', phone)),
                      _buildVerticalDivider(),
                      Expanded(child: _buildTopInfoItem(Icons.email_outlined, 'EMAIL', email)),
                      _buildVerticalDivider(),
                      Expanded(child: _buildTopInfoItem(Icons.location_city_outlined, 'CITY', 'Lahore')),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
    );
  }

  Widget _buildTopInfoItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Icon(icon, size: 20, color: AppColors.blueGreen),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 2)),
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: const Color(0xFF00A980),
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: const Color(0xFF00A980),
        indicatorWeight: 3,
        labelStyle: AppTypography.bodyInterMedium.copyWith(fontSize: 15),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Cases (3)'),
          Tab(text: 'Invoices (3)'),
          Tab(text: 'Documents (0)'),
          Tab(text: 'Notes (0)'),
          Tab(text: 'Activity Log'),
        ],
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAboutCard(),
        const SizedBox(height: AppSpacing.s24),
        _buildOutstandingCard(context),
      ],
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildAboutCard()),
        const SizedBox(width: AppSpacing.s24),
        Expanded(flex: 6, child: _buildOutstandingCard(context)),
      ],
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.pastelBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline, color: AppColors.blueGreen, size: 20),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text('About Client', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18)),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),
          _buildAboutRow(Icons.category_outlined, 'Client Type', type),
          Divider(height: 24, color: AppColors.border.withOpacity(0.3)),
          _buildAboutRow(Icons.location_on_outlined, 'Address', '123 Main Street, Phase 5, DHA, Lahore'),
          Divider(height: 24, color: AppColors.border.withOpacity(0.3)),
          _buildAboutRow(Icons.work_outline, 'Occupation', 'Business Owner'),
          Divider(height: 24, color: AppColors.border.withOpacity(0.3)),
          _buildAboutRow(Icons.people_outline, 'Referred By', 'M. Ahmed (Advocate)'),
          Divider(height: 24, color: AppColors.border.withOpacity(0.3)),
          _buildAboutRow(Icons.sticky_note_2_outlined, 'Notes', 'Prefers communication via WhatsApp after 5 PM.'),
        ],
      ),
    );
  }

  Widget _buildAboutRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.s12),
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.textSecondary, fontSize: 14)),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutstandingCard(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.pastelOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.princetonOrange, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Text('Outstanding Summary', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18)),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blueGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View All Invoices', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.blueGreen)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSummaryBox(
                      'Total Invoices',
                      '3',
                      subValue: 'PKR 130,000',
                      bgColor: const Color(0xFFF8FAFC),
                      borderColor: AppColors.border,
                      textColor: AppColors.primaryNavy,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    _buildSummaryBox(
                      'Paid Amount',
                      'PKR 50,000',
                      bgColor: AppColors.pastelGreen,
                      borderColor: const Color(0xFF00A980).withOpacity(0.3),
                      textColor: const Color(0xFF00A980),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    _buildSummaryBox(
                      'Outstanding',
                      'PKR 80,000',
                      bgColor: AppColors.pastelRed,
                      borderColor: const Color(0xFFD32F2F).withOpacity(0.3),
                      textColor: const Color(0xFFD32F2F),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildSummaryBox(
                        'Total Invoices',
                        '3',
                        subValue: 'PKR 130,000',
                        bgColor: const Color(0xFFF8FAFC),
                        borderColor: AppColors.border,
                        textColor: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: _buildSummaryBox(
                        'Paid Amount',
                        'PKR 50,000',
                        bgColor: AppColors.pastelGreen,
                        borderColor: const Color(0xFF00A980).withOpacity(0.3),
                        textColor: const Color(0xFF00A980),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: _buildSummaryBox(
                        'Outstanding',
                        'PKR 80,000',
                        bgColor: AppColors.pastelRed,
                        borderColor: const Color(0xFFD32F2F).withOpacity(0.3),
                        textColor: const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String mainValue, {String? subValue, required Color bgColor, required Color borderColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(mainValue, style: AppTypography.header.copyWith(color: textColor, fontSize: 22)),
          if (subValue != null) ...[
            const SizedBox(height: 8),
            Text(subValue, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
          ]
        ],
      ),
    );
  }

  Widget _buildCasesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCaseCard('Ejaz vs Adnan', '-', 'OPEN'),
        const SizedBox(height: AppSpacing.s12),
        _buildCaseCard('Alia vs Adnan', '-', 'REOPEN'),
        const SizedBox(height: AppSpacing.s12),
        _buildCaseCard('Momina vs Muheeb', '-', 'REOPEN'),
      ],
    );
  }

  Widget _buildCaseCard(String title, String caseNo, String status) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16),
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Divider(color: AppColors.border.withOpacity(0.3), height: 1),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Case No: $caseNo',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'View Details',
                    style: AppTypography.labelSmall.copyWith(color: const Color(0xFF00A980), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInvoiceCard('-', 'PKR 50,000', '9/2/2026', 'PAID'),
        const SizedBox(height: AppSpacing.s12),
        _buildInvoiceCard('-', 'PKR 20,000', '8/21/2026', 'DRAFT'),
        const SizedBox(height: AppSpacing.s12),
        _buildInvoiceCard('-', 'PKR 60,000', '9/4/2026', 'DRAFT'),
      ],
    );
  }

  Widget _buildInvoiceCard(String invoiceNo, String amount, String dueDate, String status) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 18),
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Divider(color: AppColors.border.withOpacity(0.3), height: 1),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inv: $invoiceNo',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    dueDate,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
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
