import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminSubscriptionsScreen extends StatefulWidget {
  const SuperAdminSubscriptionsScreen({super.key});

  @override
  State<SuperAdminSubscriptionsScreen> createState() => _SuperAdminSubscriptionsScreenState();
}

class _SuperAdminSubscriptionsScreenState extends State<SuperAdminSubscriptionsScreen> {
  int _selectedTab = 0; // 0=Subscription Plans, 1=Payment Transactions, 2=Failed Payments, 3=Billing Overview
  final Set<String> _expandedPlanNames = {};

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Free',
      'code': 'F',
      'tagline': 'For individual lawyers',
      'monthlyPrice': 'Free',
      'yearlyPrice': 'Free',
      'users': 'Up to 1',
      'cases': 'Up to 20',
      'storage': '1 GB',
      'subscribers': 7,
      'status': 'Active',
      'color': const Color(0xFF10B981), // Emerald Green
      'bgPill': const Color(0xFFECFDF5),
      'features': [
        'Cases Management',
        'Hearings & Reminders',
        'Documents Storage',
        'Cause List on WhatsApp',
        '+6 more features',
      ],
    },
    {
      'name': 'Basic',
      'code': 'B',
      'tagline': 'For small law firms',
      'monthlyPrice': 'PKR 1,499 / month',
      'yearlyPrice': 'PKR 14,390 / year',
      'savings': 'Save 20%',
      'users': 'Up to 5',
      'cases': 'Up to 2,000',
      'storage': '5 GB',
      'subscribers': 0,
      'status': 'Active',
      'color': const Color(0xFF0284C7), // Sky Blue
      'bgPill': const Color(0xFFF0F9FF),
      'features': [
        'Cases Management',
        'Hearings & Reminders',
        'Documents Storage',
        'Cause List on WhatsApp',
        '+6 more features',
      ],
    },
    {
      'name': 'Pro',
      'code': 'P',
      'tagline': 'For growing law firms',
      'monthlyPrice': 'PKR 3,999 / month',
      'yearlyPrice': 'PKR 38,390 / year',
      'savings': 'Save 20%',
      'users': 'Up to 10',
      'cases': 'Up to 5,000',
      'storage': '25 GB',
      'subscribers': 0,
      'status': 'Active',
      'color': AppColors.princetonOrange,
      'bgPill': const Color(0xFFFFF7ED),
      'features': [
        'Cases Management',
        'Hearings & Reminders',
        'Documents Storage',
        'Cause List on WhatsApp',
        '+6 more features',
      ],
    },
    {
      'name': 'Enterprise',
      'code': 'E',
      'tagline': 'For large organisations',
      'monthlyPrice': 'PKR 15,000 / month',
      'yearlyPrice': 'PKR 144,000 / year',
      'savings': 'Save 20%',
      'users': 'Up to 999',
      'cases': 'Up to 99,999',
      'storage': '200 GB',
      'subscribers': 0,
      'status': 'Active',
      'color': const Color(0xFF8B5CF6), // Purple
      'bgPill': const Color(0xFFF5F3FF),
      'features': [
        'Cases Management',
        'Hearings & Reminders',
        'Documents Storage',
        'Cause List on WhatsApp',
        '+6 more features',
      ],
    },
  ];

  void _toggleExpandPlan(String name) {
    setState(() {
      if (_expandedPlanNames.contains(name)) {
        _expandedPlanNames.remove(name);
      } else {
        _expandedPlanNames.add(name);
      }
    });
  }

  void _openPlanModal([Map<String, dynamic>? plan]) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _PlanFormDialog(
        initialPlan: plan,
        onSave: (updatedPlan) {
          setState(() {
            if (plan != null) {
              final idx = _plans.indexWhere((p) => p['name'] == plan['name']);
              if (idx != -1) {
                _plans[idx] = updatedPlan;
              }
            } else {
              _plans.add(updatedPlan);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.princetonOrange,
        onPressed: () => _openPlanModal(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, isMobile),
            _buildTabBar(isMobile),
            Expanded(
              child: _buildBodyContent(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      color: AppColors.sidebarNavy,
      padding: const EdgeInsets.fromLTRB(16, 52, 20, 24),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              onPressed: () => SuperAdminMainLayout.scaffoldKey.currentState?.openDrawer(),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Subscriptions & Billing',
              style: AppTypography.header.copyWith(
                color: Colors.white,
                fontSize: isMobile ? 22 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    final tabs = [
      'Subscription Plans',
      'Payment Transactions',
      'Failed Payments',
      'Billing Overview',
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tabs[index],
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textMuted,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBodyContent(bool isMobile) {
    switch (_selectedTab) {
      case 0:
        return _buildSubscriptionPlansList(isMobile);
      case 1:
        return _buildPlaceholderTab('Payment Transactions', Icons.receipt_long_outlined);
      case 2:
        return _buildPlaceholderTab('Failed Payments', Icons.error_outline);
      case 3:
        return _buildPlaceholderTab('Billing Overview', Icons.bar_chart_outlined);
      default:
        return _buildSubscriptionPlansList(isMobile);
    }
  }

  Widget _buildSubscriptionPlansList(bool isMobile) {
    return ListView.separated(
      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
      itemCount: _plans.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildCollapsiblePlanCard(_plans[index], isMobile),
    );
  }

  Widget _buildCollapsiblePlanCard(Map<String, dynamic> plan, bool isMobile) {
    final String name = plan['name'] as String;
    final Color themeColor = plan['color'] as Color;
    final Color bgPill = plan['bgPill'] as Color;
    final List<String> features = List<String>.from(plan['features'] as List);
    final String? savings = plan['savings'] as String?;

    final isExpanded = _expandedPlanNames.contains(name);

    return QanomyCard(
      onTap: () => _toggleExpandPlan(name),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collapsed View: Badge, Plan Name + Tagline + Price Summary + Toggle Chevron
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bgPill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: themeColor.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text(
                      plan['code'] as String,
                      style: AppTypography.header.copyWith(
                        color: themeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${plan['monthlyPrice']}',
                            style: AppTypography.bodyInterMedium.copyWith(
                              color: AppColors.primaryNavy,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        plan['tagline'] as String,
                        style: AppTypography.bodyInter.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),

            // Expanded View (Revealed when card is clicked)
            if (isExpanded) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 14),

              // Pricing Section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MONTHLY RATE',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan['monthlyPrice'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'YEARLY RATE',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (savings != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0E6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  savings,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.princetonOrange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan['yearlyPrice'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Resource Limits Grid (Users, Cases, Storage, Subscribers)
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.navBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _buildResourceStat('Users', plan['users'] as String, Icons.people_outline),
                    _buildResourceStat('Cases', plan['cases'] as String, Icons.work_outline),
                    _buildResourceStat('Storage', plan['storage'] as String, Icons.cloud_outlined),
                    _buildResourceStat('Subscribers', '${plan['subscribers']} firms', Icons.domain_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Key Features Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features.map((feat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF00A980)),
                        const SizedBox(width: 6),
                        Text(
                          feat,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primaryNavy,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Card Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _openPlanModal(plan),
                    icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryNavy),
                    label: Text(
                      'Edit Plan',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.group_outlined, size: 14, color: AppColors.blueGreen),
                    label: Text(
                      'Subscribers (${plan['subscribers']})',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.blueGreen, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      side: BorderSide(color: AppColors.blueGreen.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResourceStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTypography.bodyInterSemiBold.copyWith(
              color: AppColors.primaryNavy,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.textMuted.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All transactions & billing logs will appear here',
            style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _PlanFormDialog extends StatefulWidget {
  final Map<String, dynamic>? initialPlan;
  final ValueChanged<Map<String, dynamic>> onSave;

  const _PlanFormDialog({
    this.initialPlan,
    required this.onSave,
  });

  @override
  State<_PlanFormDialog> createState() => _PlanFormDialogState();
}

class _PlanFormDialogState extends State<_PlanFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _subtitleController;
  late TextEditingController _monthlyPriceController;
  late TextEditingController _yearlyPriceController;
  late TextEditingController _usersController;
  late TextEditingController _casesController;
  late TextEditingController _storageController;
  late ScrollController _featuresScrollController;

  late bool _isActive;
  late Map<String, bool> _featuresMap;

  final List<String> _allFeatures = [
    'Cases Management',
    'Hearings & Reminders',
    'Documents Storage',
    'WhatsApp / SMS Reminders',
    'Client Portal',
    'Invoicing & Billing',
    'Reports & Analytics',
    'API Access',
    'Team Members Limit',
    'Custom Court List',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initialPlan;
    _nameController = TextEditingController(text: p != null ? p['name'] : '');
    _subtitleController = TextEditingController(text: p != null ? p['tagline'] : '');

    String mPrice = p != null ? (p['monthlyPrice'] as String) : '0';
    mPrice = mPrice.replaceAll(RegExp(r'[^0-9]'), '');
    String yPrice = p != null ? (p['yearlyPrice'] as String) : '0';
    yPrice = yPrice.replaceAll(RegExp(r'[^0-9]'), '');

    _monthlyPriceController = TextEditingController(text: mPrice.isEmpty ? '0' : mPrice);
    _yearlyPriceController = TextEditingController(text: yPrice.isEmpty ? '0' : yPrice);

    _usersController = TextEditingController(text: p != null ? (p['users'] as String) : '5');
    _casesController = TextEditingController(text: p != null ? (p['cases'] as String) : '100');
    _storageController = TextEditingController(text: p != null ? (p['storage'] as String) : '10 GB');
    _featuresScrollController = ScrollController();

    _isActive = p == null || (p['status'] == 'Active');

    List<String> currentFeats = p != null ? List<String>.from(p['features'] as List) : [];
    _featuresMap = {
      for (var f in _allFeatures)
        f: currentFeats.any((cf) => cf.toLowerCase().contains(f.toLowerCase().split(' ')[0]))
    };
    if (p == null) {
      _featuresMap.updateAll((key, value) => false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _monthlyPriceController.dispose();
    _yearlyPriceController.dispose();
    _usersController.dispose();
    _casesController.dispose();
    _storageController.dispose();
    _featuresScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.initialPlan != null;
    final bool isMobile = Responsive.isMobile(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: isMobile ? double.infinity : 540,
        height: MediaQuery.of(context).size.height * 0.82,
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEdit ? 'Edit Subscription Plan' : 'Add New Subscription Plan',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 16),

            // Scrollable Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Name
                    _buildLabel('Plan Name *'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: AppTypography.bodyInter.copyWith(fontSize: 14),
                      decoration: _inputDecoration('e.g. Starter'),
                    ),
                    const SizedBox(height: 14),

                    // Subtitle
                    _buildLabel('Subtitle'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _subtitleController,
                      style: AppTypography.bodyInter.copyWith(fontSize: 14),
                      decoration: _inputDecoration('e.g. For solo practitioners'),
                    ),
                    const SizedBox(height: 14),

                    // Monthly & Yearly Price Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Monthly Price (PKR)'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _monthlyPriceController,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyInter.copyWith(fontSize: 14),
                                decoration: _inputDecoration('0'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Yearly Price (PKR)'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _yearlyPriceController,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyInter.copyWith(fontSize: 14),
                                decoration: _inputDecoration('0'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Max Users, Cases, Storage Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Max Users'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _usersController,
                                style: AppTypography.bodyInter.copyWith(fontSize: 14),
                                decoration: _inputDecoration('5'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Cases'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _casesController,
                                style: AppTypography.bodyInter.copyWith(fontSize: 14),
                                decoration: _inputDecoration('100'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Storage'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _storageController,
                                style: AppTypography.bodyInter.copyWith(fontSize: 14),
                                decoration: _inputDecoration('10 GB'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Key Features List
                    _buildLabel('Key Features'),
                    const SizedBox(height: 8),
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: RawScrollbar(
                        controller: _featuresScrollController,
                        thumbColor: AppColors.textMuted.withValues(alpha: 0.5),
                        radius: const Radius.circular(4),
                        thickness: 6,
                        child: GridView.builder(
                          controller: _featuresScrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : 2,
                            childAspectRatio: isMobile ? 5.5 : 4.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: _allFeatures.length,
                          itemBuilder: (context, idx) {
                            final feat = _allFeatures[idx];
                            final isChecked = _featuresMap[feat] ?? false;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _featuresMap[feat] = !isChecked;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: const Color(0xFF0284C7),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    onChanged: (val) {
                                      setState(() {
                                        _featuresMap[feat] = val ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: AppTypography.bodyInter.copyWith(
                                        color: AppColors.primaryNavy,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Radio Pills
                    _buildLabel('Status'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isActive = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isActive ? const Color(0xFFECFDF5) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _isActive ? const Color(0xFF10B981) : AppColors.border,
                                  width: _isActive ? 1.5 : 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Active',
                                  style: AppTypography.bodyInterMedium.copyWith(
                                    color: _isActive ? const Color(0xFF10B981) : AppColors.textMuted,
                                    fontWeight: _isActive ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isActive = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isActive ? const Color(0xFFF9FAFB) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: !_isActive ? AppColors.textMuted : AppColors.border,
                                  width: !_isActive ? 1.5 : 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Inactive',
                                  style: AppTypography.bodyInterMedium.copyWith(
                                    color: !_isActive ? AppColors.primaryNavy : AppColors.textMuted,
                                    fontWeight: !_isActive ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 16),

            // Footer Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sidebarNavy,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: Text(
                      isEdit ? 'Update Plan' : 'Save Plan',
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    final isRequired = text.contains('*');
    return RichText(
      text: TextSpan(
        text: text.replaceAll('*', ''),
        style: AppTypography.bodyInterMedium.copyWith(
          color: AppColors.primaryNavy,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0284C7)),
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim().isEmpty ? 'New Plan' : _nameController.text.trim();
    final subtitle = _subtitleController.text.trim().isEmpty ? 'For lawyers' : _subtitleController.text.trim();
    final mPrice = _monthlyPriceController.text.trim();
    final yPrice = _yearlyPriceController.text.trim();

    final selectedFeats = _featuresMap.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selectedFeats.isEmpty) {
      selectedFeats.addAll(['Cases Management', 'Hearings & Reminders', 'Documents Storage', '+6 more features']);
    } else {
      selectedFeats.add('+6 more features');
    }

    final newPlan = {
      'name': name,
      'code': name.isNotEmpty ? name[0].toUpperCase() : 'P',
      'tagline': subtitle,
      'monthlyPrice': mPrice == '0' || mPrice.isEmpty ? 'Free' : 'PKR $mPrice / month',
      'yearlyPrice': yPrice == '0' || yPrice.isEmpty ? 'Free' : 'PKR $yPrice / year',
      'savings': (yPrice != '0' && yPrice.isNotEmpty) ? 'Save 20%' : null,
      'users': _usersController.text.trim().isEmpty ? 'Up to 5' : (
        _usersController.text.trim().startsWith('Up') ? _usersController.text.trim() : 'Up to ${_usersController.text.trim()}'
      ),
      'cases': _casesController.text.trim().isEmpty ? 'Up to 100' : (
        _casesController.text.trim().startsWith('Up') ? _casesController.text.trim() : 'Up to ${_casesController.text.trim()}'
      ),
      'storage': _storageController.text.trim().isEmpty ? '10 GB' : _storageController.text.trim(),
      'subscribers': widget.initialPlan != null ? (widget.initialPlan!['subscribers'] ?? 0) : 0,
      'status': _isActive ? 'Active' : 'Inactive',
      'color': widget.initialPlan != null ? widget.initialPlan!['color'] : const Color(0xFF0284C7),
      'bgPill': widget.initialPlan != null ? widget.initialPlan!['bgPill'] : const Color(0xFFF0F9FF),
      'features': selectedFeats,
    };

    widget.onSave(newPlan);
    Navigator.pop(context);
  }
}
