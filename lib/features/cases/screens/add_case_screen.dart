import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/api_service.dart';
import '../../clients/screens/add_client_screen.dart';
import '../../navigation/main_layout.dart';

import '../models/case_model.dart';
import '../services/case_service.dart';

class AddCaseScreen extends StatefulWidget {
  final CaseModel? initialCase;
  const AddCaseScreen({super.key, this.initialCase});

  @override
  State<AddCaseScreen> createState() => _AddCaseScreenState();
}

class _AddCaseScreenState extends State<AddCaseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _caseIdController = TextEditingController();
  final TextEditingController _firstPartyController = TextEditingController();
  final TextEditingController _oppositePartyController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final List<TextEditingController> _judgeControllers = [TextEditingController()];

  String? _selectedCourtType;
  String? _selectedCaseType;
  String _selectedStatus = 'Open';
  String _selectedOutcome = 'WIN';
  String? _selectedPriority;
  String? _selectedClient;
  String? _selectedLawyer;

  final List<String> _courtTypes = [
    'Supreme Court',
    'High Court',
    'Sessions Court',
    'Civil Court',
    'Family Court',
    'Special Court',
    'NAB Court',
    'Banking Court'
  ];

  final List<String> _caseTypes = [
    'Criminal',
    'Civil',
    'Constitutional',
    'Family',
    'Corporate',
    'Tax',
    'Labour',
    'Service',
    'NAB',
    'Banking'
  ];

  final List<String> _statusList = [
    'Open',
    'Pending',
    'In Progress',
    'Disposed',
    'Closed',
    'Closed (WIN)',
    'Closed (LOSS)',
    'Closed (SETTLED)',
  ];
  final List<String> _priorityList = ['High', 'Normal', 'Low', 'Urgent'];
  List<String> _clientList = ['Hamad Client', 'Arooj Client', 'Muhammad Ali'];
  List<Map<String, dynamic>> _apiClients = [];
  final List<String> _lawyerList = ['Fatima (Lawyer)', 'Ejaz (Lawyer)', 'Haris khan (Owner)'];

  @override
  void initState() {
    super.initState();
    _fetchDatabaseClients();
    if (widget.initialCase != null) {
      final c = widget.initialCase!;
      _caseIdController.text = c.caseIdNo;
      _firstPartyController.text = c.firstParty;
      _oppositePartyController.text = c.oppositeParty;
      _remarksController.text = c.remarks;
      _selectedCourtType = _courtTypes.contains(c.courtType) ? c.courtType : null;
      _selectedCaseType = _caseTypes.contains(c.caseType) ? c.caseType : null;
      _selectedStatus = _statusList.contains(c.status) ? c.status : 'Open';
      if (_selectedStatus.contains('LOSS')) {
        _selectedOutcome = 'LOSS';
      } else if (_selectedStatus.contains('SETTLED')) {
        _selectedOutcome = 'SETTLED';
      } else if (_selectedStatus.contains('WIN')) {
        _selectedOutcome = 'WIN';
      }
      _selectedPriority = _priorityList.contains(c.priority) ? c.priority : null;
      _selectedClient = _clientList.contains(c.client) ? c.client : (_clientList.isNotEmpty ? _clientList.first : null);
      _selectedLawyer = _lawyerList.contains(c.assignee) ? c.assignee : (_lawyerList.isNotEmpty ? _lawyerList.first : null);

      if (c.judges.isNotEmpty) {
        _judgeControllers.clear();
        for (var j in c.judges) {
          _judgeControllers.add(TextEditingController(text: j));
        }
      }
    }
  }

  void _addJudgeField() {
    setState(() {
      _judgeControllers.add(TextEditingController());
    });
  }

  void _removeJudgeField(int index) {
    if (_judgeControllers.length > 1) {
      setState(() {
        _judgeControllers[index].dispose();
        _judgeControllers.removeAt(index);
      });
    }
  }

  Future<void> _fetchDatabaseClients() async {
    try {
      final response = await ApiService.getClients();
      if (response['success'] == true && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map && response['data']['clients'] is List) {
          rawList = response['data']['clients'] as List;
        }

        if (rawList.isNotEmpty) {
          final List<String> fetchedNames = [];
          final List<Map<String, dynamic>> clientMaps = [];
          for (var item in rawList) {
            final map = item as Map<String, dynamic>;
            final name = '${map['firstName'] ?? ''} ${map['lastName'] ?? ''}'.trim();
            final displayName = name.isNotEmpty ? name : (map['email']?.toString() ?? 'Client');
            fetchedNames.add(displayName);
            clientMaps.add(map);
          }
          if (mounted) {
            setState(() {
              _apiClients = clientMaps;
              _clientList = fetchedNames;
              if (_selectedClient == null || !_clientList.contains(_selectedClient)) {
                _selectedClient = _clientList.first;
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to load clients from API: $e');
    }
  }

  Future<void> _saveCase() async {
    if (_formKey.currentState!.validate()) {
      final judgesList = _judgeControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final isEditing = widget.initialCase != null;
      final firstParty = _firstPartyController.text.trim();
      final oppositeParty = _oppositePartyController.text.trim();
      final title = '$firstParty vs $oppositeParty';

      // Find matching client ID from database
      String? clientId;
      for (var c in _apiClients) {
        final name = '${c['firstName'] ?? ''} ${c['lastName'] ?? ''}'.trim();
        if (name == _selectedClient || c['email'] == _selectedClient || c['id'] == _selectedClient) {
          clientId = c['id']?.toString();
          break;
        }
      }
      if (clientId == null && _apiClients.isNotEmpty) {
        clientId = _apiClients.first['id']?.toString();
      }

      if (clientId == null && !isEditing) {
        // Auto-create client in DB if none exists yet
        final uniqueEmail = 'client_${DateTime.now().millisecondsSinceEpoch}@qanomy.com';
        final newClientRes = await ApiService.createClient({
          'firstName': _selectedClient != null && _selectedClient!.isNotEmpty ? _selectedClient! : (firstParty.isNotEmpty ? firstParty : 'Client'),
          'lastName': '(Client)',
          'email': uniqueEmail,
          'clientType': 'INDIVIDUAL',
        });
        if (newClientRes['success'] == true && newClientRes['data'] != null) {
          clientId = newClientRes['data']['id']?.toString();
        } else {
          // Fallback: resolve client ID from existing database clients list
          final existingClientsRes = await ApiService.getClients();
          if (existingClientsRes['success'] == true && existingClientsRes['data'] != null) {
            List list = existingClientsRes['data'] is List
                ? existingClientsRes['data']
                : (existingClientsRes['data']['clients'] ?? []);
            if (list.isNotEmpty) {
              clientId = list.first['id']?.toString();
            }
          }
        }
      }

      final caseModel = CaseModel(
        id: isEditing ? widget.initialCase!.id : DateTime.now().millisecondsSinceEpoch.toString().substring(7),
        caseIdNo: _caseIdController.text.trim(),
        firstParty: firstParty,
        oppositeParty: oppositeParty,
        courtType: _selectedCourtType ?? '',
        caseType: _selectedCaseType ?? '',
        judges: judgesList,
        status: _selectedStatus,
        priority: _selectedPriority ?? 'Normal',
        remarks: _remarksController.text.trim(),
        client: _selectedClient ?? '',
        assignee: _selectedLawyer ?? 'Unassigned',
        isFavorite: widget.initialCase?.isFavorite ?? false,
      );

      // Submit case creation to backend API database
      if (!isEditing && clientId != null) {
        final casePayload = {
          'title': title,
          'firstParty': firstParty,
          'oppositeParty': oppositeParty,
          'caseNumber': _caseIdController.text.trim(),
          'description': _remarksController.text.trim(),
          'court': _selectedCourtType ?? 'Sessions Court',
          'caseType': _selectedCaseType ?? 'Civil',
          'priority': (_selectedPriority ?? 'NORMAL').toUpperCase(),
          'status': 'RUNNING',
          'clientId': clientId,
        };

        final apiResponse = await ApiService.createCase(casePayload);
        CaseService.instance.addCase(caseModel);
        if (apiResponse['success'] == true) {
          await CaseService.instance.fetchCasesFromBackend();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Case "$title" stored in database successfully!'),
                backgroundColor: const Color(0xFF00A980),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          }
          return;
        }
      }

      // Fallback update/add in case service
      if (isEditing) {
        CaseService.instance.updateCase(caseModel);
      } else {
        CaseService.instance.addCase(caseModel);
      }

      final isClosed = _selectedStatus.toLowerCase().startsWith('closed') ||
          _selectedStatus.toLowerCase().startsWith('disposed');

      if (isClosed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Case "${caseModel.displayTitle}" closed and moved to Case History!'),
            backgroundColor: const Color(0xFF00A980),
            action: SnackBarAction(
              label: 'VIEW HISTORY',
              textColor: Colors.white,
              onPressed: () {
                MainLayout.instance?.switchTab(13);
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Case "${caseModel.displayTitle}" ${isEditing ? "updated" : "created"} successfully!'),
            backgroundColor: const Color(0xFF00A980),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      Navigator.pop(context, caseModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: AppSpacing.s12,
        title: Text(
          'Add New Case',
          style: AppTypography.header.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Breadcrumb
              Text(
                'Dashboard > Cases > Add New Case',
                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Add New Case',
                style: AppTypography.header.copyWith(color: AppColors.primaryNavy, fontSize: 28),
              ),
              const SizedBox(height: AppSpacing.s24),

              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildBasicInfoSection(),
                    ),
                    const SizedBox(width: AppSpacing.s24),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPartiesAndAssignmentSection(),
                          const SizedBox(height: AppSpacing.s32),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: AppSpacing.s24),
                    _buildPartiesAndAssignmentSection(),
                    const SizedBox(height: AppSpacing.s32),
                    _buildActionButtons(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
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
          Text(
            'Basic Information',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primaryNavy,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),

          // Strictly 1 field per line
          _buildTextField(
            'Case ID/No',
            'e.g. Case-2024-001',
            controller: _caseIdController,
            isRequired: true,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter Case ID/No' : null,
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildTextField(
            'First Party',
            'e.g. Muhammad Ahmad',
            controller: _firstPartyController,
            isRequired: true,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter first party' : null,
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildTextField(
            'Opposite Party',
            'e.g. State / CC 123/2024',
            controller: _oppositePartyController,
            isRequired: true,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter opposite party' : null,
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildDropdownField(
            'Court Type',
            'Select Court Type',
            _selectedCourtType,
            _courtTypes,
            (val) => setState(() => _selectedCourtType = val),
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildDropdownField(
            'Case Type',
            'Select Case Type',
            _selectedCaseType,
            _caseTypes,
            (val) => setState(() => _selectedCaseType = val),
          ),
          const SizedBox(height: AppSpacing.s16),

          // Judges section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _judgeControllers.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        i == 0 ? 'Judge Name' : 'Additional Judge ${i + 1}',
                        'e.g. Honorable Justice XYZ',
                        controller: _judgeControllers[i],
                      ),
                    ),
                    if (i > 0)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _removeJudgeField(i),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              TextButton.icon(
                onPressed: _addJudgeField,
                icon: const Icon(Icons.add, size: 16, color: AppColors.princetonOrange),
                label: Text(
                  '+ Add another judge',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.princetonOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildDropdownField(
            'Case Status',
            'Open',
            _selectedStatus,
            _statusList,
            (val) {
              if (val != null) {
                setState(() {
                  _selectedStatus = val;
                  if (val == 'Closed') {
                    _selectedStatus = 'Closed ($_selectedOutcome)';
                  }
                });
              }
            },
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.s16),

          if (_selectedStatus.toLowerCase().startsWith('closed') ||
              _selectedStatus.toLowerCase().startsWith('disposed')) ...[
            _buildOutcomeSelector(),
            const SizedBox(height: AppSpacing.s16),
          ],

          _buildDropdownField(
            'Priority',
            'Select Priority',
            _selectedPriority,
            _priorityList,
            (val) => setState(() => _selectedPriority = val),
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildTextField(
            'Remarks / Description',
            'Enter case description or remarks',
            controller: _remarksController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesAndAssignmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
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
              Text(
                'Parties & Counsel',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Client ',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w600,
                      ),
                      children: const [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddClientScreen()),
                      );
                    },
                    child: Text(
                      '+ New Client',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.princetonOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildDropdownInput('Select Client', _selectedClient, _clientList, (val) => setState(() => _selectedClient = val)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
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
              Text(
                'Assignment',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'Assigned Lawyer / Team Member',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildDropdownInput('Select Lawyer / Member', _selectedLawyer, _lawyerList, (val) => setState(() => _selectedLawyer = val)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: AppTypography.bodyInterMedium.copyWith(
              color: AppColors.primaryNavy,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        ElevatedButton(
          onPressed: _saveCase,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.princetonOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Save Case',
            style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    required TextEditingController controller,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyInter.copyWith(
              color: AppColors.textMuted.withOpacity(0.7),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: const BorderSide(color: AppColors.princetonOrange),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String hint,
    String? currentValue,
    List<String> options,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        _buildDropdownInput(hint, currentValue, options, onChanged),
      ],
    );
  }

  Widget _buildDropdownInput(
    String hint,
    String? currentValue,
    List<String>? options,
    ValueChanged<String?> onChanged,
  ) {
    final opts = options ?? <String>[];
    final validValue = (currentValue != null && opts.contains(currentValue)) ? currentValue : null;

    return DropdownButtonFormField<String>(
      initialValue: validValue,
      isExpanded: true,
      items: opts.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyInter.copyWith(
          color: AppColors.textMuted.withOpacity(0.7),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: const BorderSide(color: AppColors.princetonOrange),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
    );
  }

  Widget _buildOutcomeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.bodyInterSemiBold.copyWith(color: AppColors.primaryNavy, fontSize: 14),
            children: const [
              TextSpan(text: 'Case Result / Outcome'),
              TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildOutcomePill(
                label: 'WIN',
                icon: Icons.emoji_events_outlined,
                color: const Color(0xFF00A980),
                isSelected: _selectedStatus.contains('WIN') || _selectedOutcome == 'WIN',
                onTap: () {
                  setState(() {
                    _selectedOutcome = 'WIN';
                    _selectedStatus = 'Closed (WIN)';
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildOutcomePill(
                label: 'LOSS',
                icon: Icons.cancel_outlined,
                color: Colors.redAccent,
                isSelected: _selectedStatus.contains('LOSS') || _selectedOutcome == 'LOSS',
                onTap: () {
                  setState(() {
                    _selectedOutcome = 'LOSS';
                    _selectedStatus = 'Closed (LOSS)';
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildOutcomePill(
                label: 'SETTLED',
                icon: Icons.handshake_outlined,
                color: Colors.amber[800]!,
                isSelected: _selectedStatus.contains('SETTLED') || _selectedOutcome == 'SETTLED',
                onTap: () {
                  setState(() {
                    _selectedOutcome = 'SETTLED';
                    _selectedStatus = 'Closed (SETTLED)';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutcomePill({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodyInterSemiBold.copyWith(
                color: isSelected ? color : AppColors.primaryNavy,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
