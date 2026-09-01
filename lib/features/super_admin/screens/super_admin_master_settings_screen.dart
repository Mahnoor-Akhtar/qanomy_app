import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/qanomy_card.dart';
import 'super_admin_main_layout.dart';

class SuperAdminMasterSettingsScreen extends StatefulWidget {
  const SuperAdminMasterSettingsScreen({super.key});

  @override
  State<SuperAdminMasterSettingsScreen> createState() => _SuperAdminMasterSettingsScreenState();
}

class _SuperAdminMasterSettingsScreenState extends State<SuperAdminMasterSettingsScreen> {
  int _selectedTab = 0; // 0=Master Courts, 1=Notification Templates, 2=Other Settings

  // Tab 1: Master Courts
  final TextEditingController _courtSearchController = TextEditingController();
  String _courtSearchQuery = '';
  final Set<String> _expandedCourtNames = {};

  final List<Map<String, String>> _courts = [
    {'name': 'Anti-Terrorism Court (ATC), Karachi', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Anti-Terrorism Court (ATC), Lahore', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Balochistan High Court', 'type': 'High Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Banking Court, Karachi', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Banking Court, Lahore', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Civil Court, Karachi', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'Civil Court, Lahore', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Faisalabad', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Gujranwala', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Hyderabad', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Islamabad', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Karachi (Central)', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Karachi (East)', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Karachi (South)', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Karachi (West)', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Lahore', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Malir', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Multan', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Peshawar', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
    {'name': 'District & Sessions Court, Quetta', 'type': 'District Court', 'level': 'National', 'status': 'Active'},
  ];

  // Tab 2: Notification Templates
  int _channelFilter = 0; // 0=WhatsApp, 1=SMS, 2=Email
  final Set<String> _expandedTemplateNames = {};

  final List<Map<String, String>> _templates = [
    {'name': 'New Client Welcome', 'lang': 'English', 'purpose': 'Welcome new client', 'status': 'Active'},
    {'name': 'Case Disposed', 'lang': 'English', 'purpose': 'Case disposed notification', 'status': 'Active'},
    {'name': 'Document Shared', 'lang': 'English', 'purpose': 'Document shared with client', 'status': 'Active'},
    {'name': 'Payment Receipt', 'lang': 'English', 'purpose': 'Payment receipt confirmation', 'status': 'Active'},
    {'name': 'Payment Due Reminder', 'lang': 'English', 'purpose': 'Invoice payment due reminder', 'status': 'Active'},
    {'name': 'Hearing Update (Next Date)', 'lang': 'English', 'purpose': 'Next hearing date update', 'status': 'Active'},
    {'name': 'Hearing Update (Adjourned)', 'lang': 'English', 'purpose': 'Hearing adjourned notification', 'status': 'Active'},
    {'name': 'Hearing Today', 'lang': 'English', 'purpose': 'Hearing today notification', 'status': 'Active'},
    {'name': 'Hearing Reminder (1 Day Before)', 'lang': 'English', 'purpose': 'Hearing reminder 1 day before', 'status': 'Active'},
    {'name': 'Hearing Reminder (7 Days Before)', 'lang': 'English', 'purpose': 'Hearing reminder 7 days before', 'status': 'Active'},
    {'name': 'Welcome – New Client – English', 'lang': 'English', 'purpose': 'Send a welcome message to a newly added client with portal access instructions.', 'status': 'Active'},
    {'name': 'Case Closed – English', 'lang': 'English', 'purpose': 'Notify the client that their case has been officially marked as closed.', 'status': 'Active'},
    {'name': 'Subscription Renewal Reminder – English', 'lang': 'English', 'purpose': 'Remind the firm about their upcoming subscription renewal and billing date.', 'status': 'Active'},
    {'name': 'New Message Received – English', 'lang': 'English', 'purpose': 'Alert the client or lawyer that a new message has been received in the case chat.', 'status': 'Active'},
    {'name': 'Document Uploaded – English', 'lang': 'English', 'purpose': 'Notify the client that a new document has been uploaded to their case file.', 'status': 'Active'},
    {'name': 'Invoice Generated – English', 'lang': 'English', 'purpose': 'Inform the client that a new invoice has been generated for their case.', 'status': 'Active'},
    {'name': 'Payment Due Reminder – English', 'lang': 'English', 'purpose': 'Alert the client about a pending invoice payment that is due or overdue.', 'status': 'Active'},
    {'name': 'Case Status Update – English', 'lang': 'English', 'purpose': 'Notify the client when their case status has been updated by the lawyer.', 'status': 'Active'},
    {'name': 'Hearing Reminder – Urdu', 'lang': 'Urdu', 'purpose': 'سماعت کی یاددہانی – کلائنٹ کو آنے والی عدالتی سماعت کی تاریخ اور وقت کے بارے میں مطلع کریں۔', 'status': 'Active'},
    {'name': 'Hearing Reminder – English', 'lang': 'English', 'purpose': 'Remind the client about an upcoming court hearing date and time.', 'status': 'Active'},
  ];

  // Tab 3: Other Settings Form Controllers
  final TextEditingController _firstNameController = TextEditingController(text: 'Qanomy');
  final TextEditingController _lastNameController = TextEditingController(text: 'Admin (MA)');
  final TextEditingController _emailController = TextEditingController(text: 'mahnoor01999@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '+92 300 1234567');

  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _courtSearchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      floatingActionButton: (_selectedTab == 0 || _selectedTab == 1)
          ? FloatingActionButton(
              backgroundColor: AppColors.princetonOrange,
              onPressed: () {
                if (_selectedTab == 0) {
                  _showCourtModal(context, null);
                } else {
                  _showTemplateModal(context, null);
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
              'Master Settings',
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
    final tabs = ['Master Courts', 'Notification Templates', 'Other Settings'];

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
        return _buildMasterCourtsTab(isMobile);
      case 1:
        return _buildNotificationTemplatesTab(isMobile);
      case 2:
        return _buildOtherSettingsTab(isMobile);
      default:
        return _buildMasterCourtsTab(isMobile);
    }
  }

  // ---------------------------------------------------------------------------
  // TAB 1: MASTER COURTS
  // ---------------------------------------------------------------------------
  Widget _buildMasterCourtsTab(bool isMobile) {
    final filteredCourts = _courts.where((c) {
      final q = _courtSearchQuery.toLowerCase();
      return q.isEmpty ||
          c['name']!.toLowerCase().contains(q) ||
          c['type']!.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Master Courts (Pakistan)',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage all courts that will be available to firms.',
                style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.navBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _courtSearchController,
                        onChanged: (val) => setState(() => _courtSearchQuery = val),
                        style: AppTypography.bodyInter.copyWith(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search court name or type...',
                          hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
            itemCount: filteredCourts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final court = filteredCourts[index];
              final name = court['name']!;
              final type = court['type']!;
              final level = court['level']!;
              final status = court['status']!;
              final isExpanded = _expandedCourtNames.contains(name);

              return QanomyCard(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedCourtNames.remove(name);
                    } else {
                      _expandedCourtNames.add(name);
                    }
                  });
                },
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.gavel_rounded, size: 18, color: Color(0xFF0284C7)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.primaryNavy,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$type • Level: $level',
                                  style: AppTypography.bodyInter.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: AppTypography.labelSmall.copyWith(
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showCourtModal(context, court),
                              icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryNavy),
                              label: Text('Edit Court', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                side: const BorderSide(color: AppColors.border),
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
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: NOTIFICATION TEMPLATES
  // ---------------------------------------------------------------------------
  Widget _buildNotificationTemplatesTab(bool isMobile) {
    final channels = ['WhatsApp', 'SMS', 'Email'];

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Default Notification Templates',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 2),
              Text(
                'Create and manage default templates used for WhatsApp, SMS and Email notifications.',
                style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(channels.length, (idx) {
                  final isSelected = _channelFilter == idx;
                  return GestureDetector(
                    onTap: () => setState(() => _channelFilter = idx),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryNavy : const Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        channels[idx],
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
            itemCount: _templates.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final t = _templates[index];
              final name = t['name']!;
              final lang = t['lang']!;
              final purpose = t['purpose']!;
              final status = t['status']!;
              final isExpanded = _expandedTemplateNames.contains(name);

              return QanomyCard(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedTemplateNames.remove(name);
                    } else {
                      _expandedTemplateNames.add(name);
                    }
                  });
                },
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.mark_email_read_outlined, size: 18, color: Color(0xFF8B5CF6)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        name,
                                        style: AppTypography.titleMedium.copyWith(
                                          color: AppColors.primaryNavy,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        lang,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.primaryNavy,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  purpose,
                                  style: AppTypography.bodyInter.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: AppTypography.labelSmall.copyWith(
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showTemplateModal(context, t),
                              icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryNavy),
                              label: Text('Edit Template', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                side: const BorderSide(color: AppColors.border),
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
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: OTHER SETTINGS (Matching Screenshot!)
  // ---------------------------------------------------------------------------
  Widget _buildOtherSettingsTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? AppSpacing.s16 : AppSpacing.s24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: isMobile
              ? Column(
                  children: [
                    _buildProfileInformationCard(),
                    const SizedBox(height: AppSpacing.s20),
                    _buildChangePasswordCard(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildProfileInformationCard()),
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(child: _buildChangePasswordCard()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileInformationCard() {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline, size: 20, color: Color(0xFF0284C7)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Information',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Update your platform admin details.',
                    style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Avatar Image Center
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0256FF), width: 2),
                        color: const Color(0xFFEEF2FF),
                      ),
                      child: const ClipOval(
                        child: Center(
                          child: Icon(Icons.person, size: 40, color: Color(0xFF0256FF)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Allowed formats: JPG, PNG. Max size 2MB.',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // First Name
          _buildFormLabel('First Name *'),
          const SizedBox(height: 6),
          TextField(
            controller: _firstNameController,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('First Name'),
          ),
          const SizedBox(height: 16),

          // Last Name
          _buildFormLabel('Last Name'),
          const SizedBox(height: 6),
          TextField(
            controller: _lastNameController,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('Last Name'),
          ),
          const SizedBox(height: 16),

          // Email (ReadOnly)
          _buildFormLabel('Email (ReadOnly)'),
          const SizedBox(height: 6),
          TextField(
            controller: _emailController,
            readOnly: true,
            style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 14),
            decoration: _inputDecoration('Email', isReadOnly: true),
          ),
          const SizedBox(height: 16),

          // Phone Number
          _buildFormLabel('Phone Number'),
          const SizedBox(height: 6),
          TextField(
            controller: _phoneController,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('e.g. +92 300 1234567', icon: Icons.phone_outlined),
          ),
          const SizedBox(height: 24),

          // Save Profile Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile information updated successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0256FF), // Blue button from screenshot
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                'Save Profile',
                style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordCard() {
    return QanomyCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.key_outlined, size: 20, color: AppColors.princetonOrange),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Ensure your account is using a secure password.',
                    style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Current Password
          _buildFormLabel('Current Password *'),
          const SizedBox(height: 6),
          TextField(
            controller: _currentPassController,
            obscureText: true,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('••••••••', icon: Icons.lock_outline),
          ),
          const SizedBox(height: 16),

          // New Password
          _buildFormLabel('New Password *'),
          const SizedBox(height: 6),
          TextField(
            controller: _newPassController,
            obscureText: true,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('••••••••', icon: Icons.lock_outline),
          ),
          const SizedBox(height: 16),

          // Confirm New Password
          _buildFormLabel('Confirm New Password *'),
          const SizedBox(height: 6),
          TextField(
            controller: _confirmPassController,
            obscureText: true,
            style: AppTypography.bodyInter.copyWith(fontSize: 14),
            decoration: _inputDecoration('••••••••', icon: Icons.lock_outline),
          ),
          const SizedBox(height: 24),

          // Update Password Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5004F), // Pinkish red button from screenshot
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(
                'Update Password',
                style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormLabel(String text) {
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

  InputDecoration _inputDecoration(String hint, {IconData? icon, bool isReadOnly = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
      filled: true,
      fillColor: isReadOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF9FAFB),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: AppColors.textMuted) : null,
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

  void _showCourtModal(BuildContext context, Map<String, dynamic>? court) {
    final isEdit = court != null;
    final nameController = TextEditingController(text: isEdit ? court['name'] as String : '');
    final typeController = TextEditingController(text: isEdit ? court['type'] as String : '');
    String selectedLevel = isEdit ? (court['level'] as String? ?? 'National') : 'National';
    String selectedStatus = isEdit ? (court['status'] as String? ?? 'Active') : 'Active';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
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
                      Text(
                        isEdit ? 'Edit Master Court' : 'Add Master Court',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),

                  _buildFormLabel('Court Name *'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: AppTypography.bodyInter.copyWith(fontSize: 14),
                    decoration: _modalInputDecoration('e.g. Supreme Court of Pakistan'),
                  ),
                  const SizedBox(height: 14),

                  _buildFormLabel('Court Type *'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: typeController,
                    style: AppTypography.bodyInter.copyWith(fontSize: 14),
                    decoration: _modalInputDecoration('e.g. Supreme Court'),
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Court Level'),
                            const SizedBox(height: 6),
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedLevel,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryNavy),
                                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => selectedLevel = val);
                                  },
                                  items: ['National', 'Provincial', 'District']
                                      .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormLabel('Status'),
                            const SizedBox(height: 6),
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedStatus,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryNavy),
                                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => selectedStatus = val);
                                  },
                                  items: ['Active', 'Inactive']
                                      .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isEdit ? 'Court updated successfully' : 'Master court added successfully')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D61FF),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Court',
                          style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTemplateModal(BuildContext context, Map<String, dynamic>? template) {
    final isEdit = template != null;
    final nameController = TextEditingController(text: isEdit ? template['title'] as String : '');
    final categoryController = TextEditingController(text: isEdit ? template['category'] as String : '');
    String selectedStatus = isEdit ? (template['status'] as String? ?? 'Active') : 'Active';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
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
                      Text(
                        isEdit ? 'Edit Document Template' : 'Add Document Template',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),

                  _buildFormLabel('Template Name *'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: AppTypography.bodyInter.copyWith(fontSize: 14),
                    decoration: _modalInputDecoration('e.g. Legal Notice Template'),
                  ),
                  const SizedBox(height: 14),

                  _buildFormLabel('Category *'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: categoryController,
                    style: AppTypography.bodyInter.copyWith(fontSize: 14),
                    decoration: _modalInputDecoration('e.g. Civil Law'),
                  ),
                  const SizedBox(height: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormLabel('Status'),
                      const SizedBox(height: 6),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStatus,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryNavy),
                            style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedStatus = val);
                            },
                            items: ['Active', 'Inactive']
                                .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(height: 1, color: AppColors.border.withValues(alpha: 0.6)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isEdit ? 'Template updated successfully' : 'Document template added successfully')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D61FF),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Template',
                          style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _modalInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted.withValues(alpha: 0.8), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1D61FF)),
      ),
    );
  }
}
