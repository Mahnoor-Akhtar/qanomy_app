import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../clients/screens/add_client_screen.dart';

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

  final List<String> _statusList = ['Open', 'Pending', 'In Progress', 'Disposed', 'Closed'];
  final List<String> _priorityList = ['High', 'Normal', 'Low', 'Urgent'];
  final List<String> _clientList = ['Hamad Client', 'Arooj Client', 'Muhammad Ali'];
  final List<String> _lawyerList = ['Fatima (Lawyer)', 'Ejaz (Lawyer)', 'Haris khan (Owner)'];

  @override
  void initState() {
    super.initState();
    if (widget.initialCase != null) {
      final c = widget.initialCase!;
      _caseIdController.text = c.caseIdNo;
      _firstPartyController.text = c.firstParty;
      _oppositePartyController.text = c.oppositeParty;
      _remarksController.text = c.remarks;
      _selectedCourtType = _courtTypes.contains(c.courtType) ? c.courtType : null;
      _selectedCaseType = _caseTypes.contains(c.caseType) ? c.caseType : null;
      _selectedStatus = _statusList.contains(c.status) ? c.status : 'Open';
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

  @override
  void dispose() {
    _caseIdController.dispose();
    _firstPartyController.dispose();
    _oppositePartyController.dispose();
    _remarksController.dispose();
    for (var c in _judgeControllers) {
      c.dispose();
    }
    super.dispose();
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

  void _saveCase() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClient == null || _selectedClient!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a client'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final judgesList = _judgeControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final isEditing = widget.initialCase != null;

      final caseModel = CaseModel(
        id: isEditing ? widget.initialCase!.id : DateTime.now().millisecondsSinceEpoch.toString().substring(7),
        caseIdNo: _caseIdController.text.trim(),
        firstParty: _firstPartyController.text.trim(),
        oppositeParty: _oppositePartyController.text.trim(),
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

      if (isEditing) {
        CaseService.instance.updateCase(caseModel);
      } else {
        CaseService.instance.addCase(caseModel);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Case "${caseModel.displayTitle}" ${isEditing ? "updated" : "created"} successfully!'),
          backgroundColor: const Color(0xFF00A980),
          duration: const Duration(seconds: 2),
        ),
      );

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
            (val) => setState(() => _selectedStatus = val!),
            isRequired: true,
          ),
          const SizedBox(height: AppSpacing.s16),

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
      value: validValue,
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
}
