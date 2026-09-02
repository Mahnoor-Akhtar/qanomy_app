import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/image_picker_helper.dart';

class AddHearingDialog extends StatefulWidget {
  final Function(Map<String, dynamic> hearingData) onSave;

  const AddHearingDialog({super.key, required this.onSave});

  @override
  State<AddHearingDialog> createState() => _AddHearingDialogState();
}

class _AddHearingDialogState extends State<AddHearingDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCase;
  DateTime? _selectedDateTime;
  final TextEditingController _locationController = TextEditingController();
  String? _selectedDocument;
  String? _uploadedDocName;
  bool _isUploading = false;

  Future<void> _handleDocumentUpload() async {
    setState(() => _isUploading = true);
    try {
      final doc = await pickDocumentFromDevice();
      if (!mounted) return;
      if (doc != null) {
        setState(() {
          _uploadedDocName = doc.name;
          if (!_documents.contains(doc.name)) {
            _documents.add(doc.name);
          }
          _selectedDocument = doc.name;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document attached: ${doc.name}')),
        );
      } else {
        final mockName = 'Hearing_Brief_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.pdf';
        setState(() {
          _uploadedDocName = mockName;
          if (!_documents.contains(mockName)) {
            _documents.add(mockName);
          }
          _selectedDocument = mockName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded document: $mockName')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  final List<String> _cases = [
    'Ali vs Ahmed',
    'Ejaz vs Adnan',
    'Alia vs Adnan',
    'Ali vs Babar',
    'State vs Usman',
    'Rehman vs Malik',
  ];

  final List<String> _documents = [
    'Select an existing case document...',
    'Vakalatnama_Signed.pdf',
    'evidence_photos.zip',
    'atc_order_copy.pdf',
    'reply_statement.docx',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.princetonOrange,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : const TimeOfDay(hour: 10, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.princetonOrange,
                onPrimary: Colors.white,
                onSurface: AppColors.primaryNavy,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDateTimeString(DateTime? dt) {
    if (dt == null) return 'mm/dd/yyyy --:-- --';
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hourNum = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final hour = hourNum.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$month/$day/$year $hour:$minute $period';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCase == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a case')),
        );
        return;
      }
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select hearing date & time')),
        );
        return;
      }

      final doc = _uploadedDocName ??
          (_selectedDocument != null &&
                  _selectedDocument != 'Select an existing case document...'
              ? _selectedDocument!
              : 'hearing_brief.pdf');

      widget.onSave({
        'caseTitle': _selectedCase!,
        'dateTime': _selectedDateTime!,
        'location': _locationController.text.trim(),
        'docName': doc,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Hearing',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Select Case *
                      _buildFieldLabel('Select Case', isRequired: true),
                      const SizedBox(height: AppSpacing.s8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCase,
                        isExpanded: true,
                        hint: Text(
                          'Select a case...',
                          style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                        decoration: _getInputDecoration(),
                        dropdownColor: Colors.white,
                        items: _cases.map((c) {
                          return DropdownMenuItem<String>(
                            value: c,
                            child: Text(
                              c,
                              style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedCase = val),
                        validator: (val) => val == null ? 'Case is required' : null,
                      ),
                      const SizedBox(height: AppSpacing.s20),

                      // Hearing Date & Time *
                      _buildFieldLabel('Hearing Date & Time', isRequired: true),
                      const SizedBox(height: AppSpacing.s8),
                      InkWell(
                        onTap: _pickDateTime,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDateTimeString(_selectedDateTime),
                                style: AppTypography.bodyInter.copyWith(
                                  color: _selectedDateTime != null
                                      ? AppColors.primaryNavy
                                      : AppColors.textMuted,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s20),

                      // Location (Court Room) *
                      _buildFieldLabel('Location (Court Room)', isRequired: true),
                      const SizedBox(height: AppSpacing.s8),
                      TextFormField(
                        controller: _locationController,
                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
                        decoration: _getInputDecoration(
                          hintText: 'e.g. Court Room 3, High Court',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Location is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.s20),

                      // Attach Brief Document (Optional)
                      _buildFieldLabel('Attach Brief Document (Optional)', isRequired: false),
                      const SizedBox(height: AppSpacing.s8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDocument ?? _documents.first,
                        isExpanded: true,
                        decoration: _getInputDecoration(),
                        dropdownColor: Colors.white,
                        items: _documents.map((doc) {
                          return DropdownMenuItem<String>(
                            value: doc,
                            child: Text(
                              doc,
                              style: AppTypography.bodyInter.copyWith(
                                color: doc == _documents.first
                                    ? AppColors.textMuted
                                    : AppColors.primaryNavy,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedDocument = val),
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // OR Divider
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // Upload New Document Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _isUploading ? null : _handleDocumentUpload,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _uploadedDocName != null
                                  ? const Color(0xFF00A980)
                                  : AppColors.border,
                              width: _uploadedDocName != null ? 1.5 : 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: _uploadedDocName != null
                                ? const Color(0xFF00A980).withValues(alpha: 0.08)
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isUploading) ...[
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 10),
                              ] else ...[
                                Icon(
                                  _uploadedDocName != null
                                      ? Icons.check_circle_rounded
                                      : Icons.upload_outlined,
                                  color: _uploadedDocName != null
                                      ? const Color(0xFF00A980)
                                      : AppColors.primaryNavy,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  _uploadedDocName != null
                                      ? 'Attached: $_uploadedDocName'
                                      : (_isUploading ? 'Selecting document...' : 'Upload a new document'),
                                  style: AppTypography.bodyInterMedium.copyWith(
                                    color: _uploadedDocName != null
                                        ? const Color(0xFF00A980)
                                        : AppColors.primaryNavy,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_uploadedDocName != null) ...[
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _uploadedDocName = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.princetonOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Save Hearing',
                      style: AppTypography.bodyInterSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        style: AppTypography.bodyInterSemiBold.copyWith(
          color: AppColors.primaryNavy,
          fontSize: 14,
        ),
        children: [
          TextSpan(text: text),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
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
        borderSide: const BorderSide(color: AppColors.princetonOrange, width: 1.5),
      ),
    );
  }
}
