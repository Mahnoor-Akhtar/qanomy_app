import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final List<Map<String, String>> _invoices = [
    {'no': 'INV-2026-4167', 'client': 'Hamad Client', 'case': 'Alia vs Adnan', 'issue': '13-Aug-2026', 'due': '22-Aug-2026', 'amount': 'PKR 150,000', 'paid': 'PKR 0', 'status': 'Draft'},
    {'no': 'INV-2026-1192', 'client': 'Arooj Client', 'case': 'Ali vs Babar', 'issue': '13-Aug-2026', 'due': '21-Aug-2026', 'amount': 'PKR 20,000', 'paid': 'PKR 0', 'status': 'Draft'},
    {'no': 'INV-2026-8724', 'client': 'Muhammad Ali', 'case': 'Momina vs Muheeb', 'issue': '13-Aug-2026', 'due': '05-Sept-2026', 'amount': 'PKR 70,000', 'paid': 'PKR 0', 'status': 'Draft'},
    {'no': 'INV-2026-7899', 'client': 'Arooj Client', 'case': 'Ali vs Ahmed', 'issue': '13-Aug-2026', 'due': '04-Sept-2026', 'amount': 'PKR 60,000', 'paid': 'PKR 0', 'status': 'Draft'},
    {'no': 'INV-2026-1310', 'client': 'Arooj Client', 'case': 'Alia vs Adnan', 'issue': '13-Aug-2026', 'due': '02-Sept-2026', 'amount': 'PKR 50,000', 'paid': 'PKR 50,000', 'status': 'Paid'},
  ];

  void _addInvoice(Map<String, String> newInv) {
    setState(() {
      _invoices.insert(0, newInv);
    });
  }

  void _showCreateInvoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CreateInvoiceDialog();
      },
    ).then((value) {
      if (value != null && value is Map<String, String>) {
        _addInvoice(value);
      }
    });
  }

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
        heroTag: null,
        onPressed: _showCreateInvoiceDialog,
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
        _buildStatCard('Total Invoices', '${_invoices.length}', 'All time', Icons.description_outlined, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
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
                  shape: BoxShape.circle,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildFilterBar(),
        ),
        const SizedBox(height: 16),
        _buildInvoicesList(),
      ],
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

  Widget _buildInvoicesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final inv = _invoices[index];
        return InvoiceCard(
          index: index,
          no: inv['no']!,
          client: inv['client']!,
          caseName: inv['case']!,
          issueDate: inv['issue']!,
          dueDate: inv['due']!,
          amount: inv['amount']!,
          paid: inv['paid']!,
          status: inv['status']!,
        );
      },
    );
  }
}

class InvoiceCard extends StatefulWidget {
  final int index;
  final String no;
  final String client;
  final String caseName;
  final String issueDate;
  final String dueDate;
  final String amount;
  final String paid;
  final String status;

  const InvoiceCard({
    super.key,
    required this.index,
    required this.no,
    required this.client,
    required this.caseName,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    required this.paid,
    required this.status,
  });

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isPaid = widget.status == 'Paid';
    
    final statusBgColor = isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9);
    final statusTextColor = isPaid ? const Color(0xFF10B981) : AppColors.textSecondary;
    final accentColor = isPaid ? const Color(0xFF10B981) : const Color(0xFF94A3B8);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        child: Stack(
          children: [
            // Left Accent Status Bar using Positioned
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 5,
              child: Container(
                color: accentColor,
              ),
            ),
            // Content shifted slightly to make room for Left Accent Bar
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.no,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.primaryNavy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.client,
                                  style: AppTypography.bodyInter.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.amount,
                                style: AppTypography.bodyInterMedium.copyWith(
                                  color: AppColors.primaryNavy,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  widget.status,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: statusTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSpacing.s16),
                              Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                              const SizedBox(height: AppSpacing.s16),
                              
                              if (isMobile)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoColumn('Case', widget.caseName),
                                    const SizedBox(height: 12),
                                    _buildInfoColumn('Issue Date', widget.issueDate),
                                    const SizedBox(height: 12),
                                    _buildInfoColumn('Due Date', widget.dueDate),
                                    const SizedBox(height: 12),
                                    _buildInfoColumn('Paid Amount', widget.paid),
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 3, child: _buildInfoColumn('Case', widget.caseName)),
                                    Expanded(flex: 2, child: _buildInfoColumn('Issue Date', widget.issueDate)),
                                    Expanded(flex: 2, child: _buildInfoColumn('Due Date', widget.dueDate)),
                                    Expanded(flex: 2, child: _buildInfoColumn('Paid Amount', widget.paid)),
                                  ],
                                ),
                                
                              const SizedBox(height: AppSpacing.s16),
                              Divider(color: AppColors.border.withOpacity(0.5), height: 1),
                              const SizedBox(height: AppSpacing.s16),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.textSecondary, size: 20),
                                    tooltip: 'View Invoice',
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.download_outlined, color: AppColors.textSecondary, size: 20),
                                    tooltip: 'Download PDF',
                                  ),
                                  const SizedBox(width: 12),
                                  if (!isPaid)
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF10B981)),
                                      label: Text(
                                        'Mark as Paid',
                                        style: AppTypography.bodyInterMedium.copyWith(
                                          color: const Color(0xFF10B981),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF10B981)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
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
          ],
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

class CreateInvoiceDialog extends StatefulWidget {
  const CreateInvoiceDialog({super.key});

  @override
  State<CreateInvoiceDialog> createState() => _CreateInvoiceDialogState();
}

class _CreateInvoiceDialogState extends State<CreateInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedClient;
  String? _selectedCase;
  DateTime? _dueDate;
  final _amountController = TextEditingController();
  String _paymentTerms = '15 Days';

  final List<String> _clients = ['Hamad Client', 'Arooj Client', 'Muhammad Ali'];
  final List<String> _cases = ['Alia vs Adnan', 'Ali vs Babar', 'Momina vs Muheeb', 'Ali vs Ahmed', 'No case linked'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day}-${months[date.month - 1]}-${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 15)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF023047),
              onPrimary: Colors.white,
              onSurface: Color(0xFF023047),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 24,
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Invoice',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primaryNavy,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  
                  Text(
                    'Client *',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedClient,
                    hint: const Text('Select client...'),
                    validator: (value) => value == null ? 'Client is required' : null,
                    items: _clients.map((client) {
                      return DropdownMenuItem(
                        value: client,
                        child: Text(client),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedClient = val;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Case (optional)',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCase,
                    hint: const Text('No case linked'),
                    items: _cases.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCase = val;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Due Date *',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dueDate == null ? 'mm/dd/yyyy' : _formatDate(_dueDate!),
                            style: AppTypography.bodyInter.copyWith(
                              color: _dueDate == null ? AppColors.textMuted : AppColors.primaryNavy,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Amount (PKR) *',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. 150000',
                      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Payment Terms',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _paymentTerms,
                    items: ['15 Days', '30 Days', '45 Days', 'Due on Receipt'].map((term) {
                      return DropdownMenuItem(
                        value: term,
                        child: Text(term),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _paymentTerms = val ?? '15 Days';
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.border.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_dueDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please pick a due date')),
                              );
                              return;
                            }
                            
                            final amountVal = double.tryParse(_amountController.text) ?? 0.0;
                            final amountFormatted = "PKR ${amountVal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}";
                            
                            final newInv = {
                              'no': 'INV-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                              'client': _selectedClient!,
                              'case': _selectedCase ?? 'No case linked',
                              'issue': _formatDate(DateTime.now()),
                              'due': _formatDate(_dueDate!),
                              'amount': amountFormatted,
                              'paid': 'PKR 0',
                              'status': 'Draft',
                            };
                            Navigator.pop(context, newInv);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A980),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Invoice',
                          style: AppTypography.bodyInterMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
