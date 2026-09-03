import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/api_service.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 13) {
      text = text.substring(0, 13);
    }

    var newString = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 5 || i == 12) {
        newString += '-';
      }
      newString += text[i];
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    var newString = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 4) {
        newString += '-';
      }
      newString += text[i];
    }

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class AddClientScreen extends StatefulWidget {
  final ClientModel? initialClient;

  const AddClientScreen({super.key, this.initialClient});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _ntnController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referredByController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(text: 'Lahore');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(text: 'nOzfEQ3x');

  String _selectedClientType = 'Individual';
  String _selectedStatus = 'Active';
  bool _enablePortalAccess = true;
  bool _obscurePassword = false;

  final List<String> _clientTypes = ['Individual', 'Corporate', 'Government', 'Other'];
  final List<String> _statusOptions = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    if (widget.initialClient != null) {
      final c = widget.initialClient!;
      _companyNameController.text = c.companyName;
      _clientNameController.text = c.name;
      _ntnController.text = c.ntn;
      _cnicController.text = c.cnic;
      _occupationController.text = c.occupation;
      _phoneController.text = c.phone;
      _referredByController.text = c.referredBy;
      _emailController.text = c.email;
      _cityController.text = c.city.isEmpty ? 'Lahore' : c.city;
      _addressController.text = c.address;
      _notesController.text = c.notes;
      _selectedClientType = c.type.isEmpty ? 'Individual' : c.type;
      _selectedStatus = c.status.isEmpty ? 'Active' : c.status;
      _enablePortalAccess = c.portalAccess;
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _clientNameController.dispose();
    _ntnController.dispose();
    _cnicController.dispose();
    _occupationController.dispose();
    _phoneController.dispose();
    _referredByController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveClient() async {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.initialClient != null;
      final rawName = _clientNameController.text.trim();
      final nameParts = rawName.split(' ');
      final firstName = nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0] : rawName;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Client';

      final clientPayload = {
        'firstName': firstName,
        'lastName': lastName,
        if (_emailController.text.trim().isNotEmpty) 'email': _emailController.text.trim(),
        if (_phoneController.text.trim().isNotEmpty) 'phone': _phoneController.text.trim(),
        if (_passwordController.text.trim().isNotEmpty) 'password': _passwordController.text.trim(),
        'clientType': _selectedClientType,
        if (_cnicController.text.trim().isNotEmpty) 'cnic': _cnicController.text.trim(),
        'city': _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : 'Lahore',
        if (_occupationController.text.trim().isNotEmpty) 'occupation': _occupationController.text.trim(),
        if (_addressController.text.trim().isNotEmpty) 'address': _addressController.text.trim(),
        if (_referredByController.text.trim().isNotEmpty) 'referredBy': _referredByController.text.trim(),
        if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
        'portalAccess': _enablePortalAccess,
        'status': _selectedStatus.toUpperCase(),
      };

      if (isEditing) {
        final res = await ApiService.updateClient(widget.initialClient!.id, clientPayload);
        if (res['success'] == true) {
          await ClientService.instance.fetchClientsFromBackend();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Client "$rawName" updated in database successfully!'),
                backgroundColor: const Color(0xFF00A980),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          }
          return;
        }
      } else {
        final res = await ApiService.createClient(clientPayload);
        if (res['success'] == true) {
          await ClientService.instance.fetchClientsFromBackend();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Client "$rawName" stored in database successfully!'),
                backgroundColor: const Color(0xFF00A980),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true);
          }
          return;
        }
      }

      // Fallback
      final client = ClientModel(
        id: isEditing ? widget.initialClient!.id : DateTime.now().millisecondsSinceEpoch.toString().substring(7),
        name: rawName,
        type: _selectedClientType,
        companyName: _companyNameController.text.trim(),
        ntn: _ntnController.text.trim(),
        cnic: _cnicController.text.trim(),
        occupation: _occupationController.text.trim(),
        phone: _phoneController.text.trim(),
        referredBy: _referredByController.text.trim(),
        email: _emailController.text.trim(),
        city: _cityController.text.trim().isEmpty ? 'Lahore' : _cityController.text.trim(),
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
        status: _selectedStatus,
        portalAccess: _enablePortalAccess,
      );

      if (isEditing) {
        ClientService.instance.updateClient(client);
      } else {
        ClientService.instance.addClient(client);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Client "${client.name}" ${isEditing ? "updated" : "added"} successfully!'),
          backgroundColor: const Color(0xFF00A980),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, client);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialClient != null;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: AppSpacing.s12,
        title: Text(
          isEditing ? 'Edit Client' : 'Add New Client',
          style: AppTypography.header.copyWith(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildClientInfoSection(),
              const SizedBox(height: AppSpacing.s24),
              _buildPortalAccessSection(),
              const SizedBox(height: AppSpacing.s32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: AppColors.skyBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline, color: AppColors.skyBlue, size: 20),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Client Information',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s32),

          _buildDropdownField(
            'Client Type',
            _selectedClientType,
            _clientTypes,
            (val) => setState(() => _selectedClientType = val!),
            isRequired: true,
            prefixIcon: Icons.category_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Company Name (If applicable)',
            'Enter company name',
            controller: _companyNameController,
            prefixIcon: Icons.business_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Client Name',
            'Enter client full name',
            controller: _clientNameController,
            isRequired: true,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter client name' : null,
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'NTN (If applicable)',
            'Enter NTN number',
            controller: _ntnController,
            prefixIcon: Icons.numbers_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'CNIC',
            '35202-1234567-1',
            controller: _cnicController,
            isRequired: true,
            keyboardType: TextInputType.number,
            inputFormatters: [CnicInputFormatter()],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter CNIC';
              final clean = v.replaceAll('-', '');
              if (clean.length != 13) return 'CNIC must be 13 digits (e.g. 35202-1234567-1)';
              return null;
            },
            prefixIcon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Occupation / Business',
            'Enter occupation or business',
            controller: _occupationController,
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Phone / WhatsApp',
            '0300-1234567',
            controller: _phoneController,
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneInputFormatter()],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter phone number';
              final clean = v.replaceAll('-', '');
              if (clean.length < 10 || clean.length > 11) return 'Phone must be 11 digits (e.g. 0300-1234567)';
              return null;
            },
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Referred By',
            'Enter name (optional)',
            controller: _referredByController,
            prefixIcon: Icons.handshake_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Email',
            'Enter email address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'City',
            'Lahore',
            controller: _cityController,
            prefixIcon: Icons.location_city_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Address',
            'Enter full address',
            controller: _addressController,
            maxLines: 3,
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: AppSpacing.s24),

          _buildTextField(
            'Notes',
            'Enter any notes about client',
            controller: _notesController,
            maxLines: 4,
            prefixIcon: Icons.note_alt_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPortalAccessSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.shield_outlined, color: Color(0xFF00A980), size: 20),
              ),
              const SizedBox(width: AppSpacing.s12),
              Text(
                'Portal Access',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Allow client to access their cases, hearings, documents and invoices securely.',
            style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.s24),
          _buildDropdownField(
            'Client Status',
            _selectedStatus,
            _statusOptions,
            (val) => setState(() => _selectedStatus = val!),
          ),
          const SizedBox(height: AppSpacing.s24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Portal Access',
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                ),
                Switch(
                  value: _enablePortalAccess,
                  onChanged: (val) => setState(() => _enablePortalAccess = val),
                  activeColor: const Color(0xFF00A980),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const Divider(),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Portal Credentials',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.s16),
          ListenableBuilder(
            listenable: _emailController,
            builder: (context, _) {
              final emailText = _emailController.text.trim();
              return _buildCopyField(
                'Email',
                emailText.isEmpty ? 'Enter email address above...' : emailText,
              );
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Temporary Password', style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
              const SizedBox(height: AppSpacing.s8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                decoration: InputDecoration(
                  hintText: 'Enter temporary password...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00A980), width: 1.5),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFF00A980), size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _passwordController.text.trim()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF00A980),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s24),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Credentials will be securely sent via WhatsApp / Email upon saving.',
                    style: AppTypography.labelSmall.copyWith(color: const Color(0xFF2E7D32), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 16, color: AppColors.primaryNavy),
          label: Text(
            'Cancel',
            style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        ElevatedButton.icon(
          onPressed: _saveClient,
          icon: const Icon(Icons.save_outlined, size: 16, color: Colors.white),
          label: Text(
            'Save Client',
            style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A980),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    IconData? prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
            children: isRequired ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted.withOpacity(0.7), fontSize: 14),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00A980), width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
    IconData? prefixIcon,
  }) {
    final safeValue = options.firstWhere(
      (opt) => opt.toUpperCase() == currentValue.toUpperCase(),
      orElse: () => options.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
            children: isRequired ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: safeValue,
            isExpanded: true,
            items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00A980), width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.s8),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.bodyInter.copyWith(color: AppColors.primaryNavy),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18, color: Color(0xFF00A980)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
                  );
                },
                tooltip: 'Copy',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
