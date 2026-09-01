import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/image_picker_helper.dart';
import '../../../core/widgets/qanomy_app_bar.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedCase = 'Ali vs Ahmed';
  String _selectedFolder = 'All';
  bool _isMobileViewingFiles = false;

  final List<Map<String, String>> _cases = [
    {'title': 'Ali vs Ahmed', 'type': 'Family'},
    {'title': 'Ejaz vs Adnan', 'type': 'Civil'},
    {'title': 'Alia vs Adnan', 'type': 'NAB / Cybercrime'},
    {'title': 'Sajida vs Fahad', 'type': 'NAB / Cybercrime'},
    {'title': 'Ali vs Babar', 'type': 'NAB / Cybercrime'},
    {'title': 'Momina vs Muheeb', 'type': 'NAB / Cybercrime'},
  ];

  final List<Map<String, String>> _documents = [
    {
      'case': 'Ali vs Ahmed',
      'folder': 'Court Order',
      'name': 'ChatGPT Image Aug 12, 2026, 02:30 pm.png',
      'type': 'Court Order',
      'uploadedBy': 'Haris khan',
      'date': '13-Aug-2026, 03:20 pm',
      'size': '1.6 MB',
    },
  ];

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadDocumentDialog(
          cases: _cases.map((c) => c['title']!).toList(),
          onUpload: (newDoc) {
            setState(() {
              _documents.add(newDoc);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document uploaded successfully')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final appBar = QanomyAppBar(
      title: 'Documents',
      leading: (isMobile && _isMobileViewingFiles)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isMobileViewingFiles = false;
                });
              },
            )
          : null,
      actions: [
        QanomyAppBarButton(
          label: 'Upload Document',
          icon: Icons.upload_file_rounded,
          onPressed: _showUploadDialog,
          color: const Color(0xFF00A980),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: isMobile
                ? _isMobileViewingFiles
                    ? _buildMainContent(isMobile)
                    : _buildCasesSidebar()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 320, child: _buildCasesSidebar()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildMainContent(isMobile)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCasesSidebar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
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
                'Cases',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.textSecondary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _cases.length,
              itemBuilder: (context, index) {
                final c = _cases[index];
                final isSelected = c['title'] == _selectedCase;
                
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCase = c['title']!;
                          _selectedFolder = 'All';
                          if (Responsive.isMobile(context)) {
                            _isMobileViewingFiles = true;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                              color: isSelected ? const Color(0xFF10B981) : AppColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['title']!,
                                    style: AppTypography.bodyInterMedium.copyWith(
                                      color: isSelected ? const Color(0xFF10B981) : AppColors.primaryNavy,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    c['type']!,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 36, top: 4, bottom: 8),
                        child: Column(
                          children: [
                            _buildFolderRow('All', Icons.folder_open_outlined),
                            const SizedBox(height: 4),
                            _buildFolderRow('Court Order', Icons.folder_outlined),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderRow(String folderName, IconData icon) {
    final isSelected = _selectedFolder == folderName;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFolder = folderName;
          if (Responsive.isMobile(context)) {
            _isMobileViewingFiles = true;
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E0) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF8A00) : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              folderName,
              style: AppTypography.bodyInter.copyWith(
                color: isSelected ? const Color(0xFFFF8A00) : AppColors.primaryNavy,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    final filteredDocs = _documents.where((doc) {
      if (doc['case'] != _selectedCase) return false;
      if (_selectedFolder != 'All' && doc['folder'] != _selectedFolder) return false;
      return true;
    }).toList();

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
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDropdownFilter('All Types')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildDropdownFilter('Newest First')),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildSearchField()),
                    const SizedBox(width: 16),
                    _buildDropdownFilter('All Document Types'),
                    const SizedBox(width: 12),
                    _buildDropdownFilter('Newest First'),
                  ],
                ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.folder_open_rounded, color: Color(0xFFFF8A00), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '$_selectedCase > $_selectedFolder',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.pageBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${filteredDocs.length} Document${filteredDocs.length == 1 ? '' : 's'}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                Expanded(
                  child: filteredDocs.isEmpty
                      ? Center(
                          child: Text(
                            'No documents uploaded for this section.',
                            style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                          ),
                        )
                      : isMobile
                          ? _buildMobileFileList(filteredDocs)
                          : _buildDesktopTable(filteredDocs),
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  'Showing ${filteredDocs.length} document${filteredDocs.length == 1 ? '' : 's'}',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search documents...',
          hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String label) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
        ],
      ),
    );
  }

  Widget _buildMobileFileList(List<Map<String, String>> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.border.withOpacity(0.4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyInterMedium.copyWith(
                          color: AppColors.primaryNavy,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildMobileMetaRow('Type', doc['type']!),
                _buildMobileMetaRow('By', doc['uploadedBy']!),
                _buildMobileMetaRow('Date', doc['date']!),
                _buildMobileMetaRow('Size', doc['size']!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
          Text(value, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(List<Map<String, String>> docs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 36,
          headingRowHeight: 40,
          columns: const [
            DataColumn(label: Text('FILE NAME', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
            DataColumn(label: Text('TYPE', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
            DataColumn(label: Text('UPLOADED BY', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
            DataColumn(label: Text('DATE', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
            DataColumn(label: Text('SIZE', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
          ],
          rows: docs.map((doc) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.insert_drive_file_outlined, color: AppColors.textSecondary, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(doc['name']!, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 13)),
                    ],
                  ),
                ),
                DataCell(Text(doc['type']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
                DataCell(Text(doc['uploadedBy']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
                DataCell(Text(doc['date']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
                DataCell(Text(doc['size']!, style: AppTypography.bodyInter.copyWith(color: AppColors.textSecondary, fontSize: 13))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class UploadDocumentDialog extends StatefulWidget {
  final List<String> cases;
  final Function(Map<String, String>) onUpload;

  const UploadDocumentDialog({super.key, required this.cases, required this.onUpload});

  @override
  State<UploadDocumentDialog> createState() => _UploadDocumentDialogState();
}

class _UploadDocumentDialogState extends State<UploadDocumentDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCase;
  String _selectedType = 'Petition / Plaint';
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  String? _pickedFileName;
  String? _pickedFileSize;
  bool _isPicking = false;

  final List<String> _types = ['Petition / Plaint', 'Court Order', 'Vakalatnama', 'Evidence / Document'];

  @override
  void initState() {
    super.initState();
    _selectedCase = widget.cases.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDocument() async {
    setState(() {
      _isPicking = true;
    });
    try {
      final doc = await pickDocumentFromDevice();
      if (doc != null) {
        setState(() {
          _pickedFileName = doc.name;
          final kb = doc.size / 1024;
          if (kb >= 1024) {
            _pickedFileSize = "${(kb / 1024).toStringAsFixed(1)} MB";
          } else {
            _pickedFileSize = "${kb.toStringAsFixed(0)} KB";
          }
          if (_nameController.text.isEmpty) {
            _nameController.text = doc.name;
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking document: $e");
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 24,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Static Dialog Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Document',
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
            ),
            const Divider(height: 1),

            // Scrollable Dialog Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildUploadDropzone(),
                            const SizedBox(height: 24),
                            _buildFormFields(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 4, child: _buildUploadDropzone()),
                            const SizedBox(width: 24),
                            Expanded(flex: 5, child: _buildFormFields()),
                          ],
                        ),
                ),
              ),
            ),
            const Divider(height: 1),

            // Static Dialog Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
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
                        final fileName = _pickedFileName ?? _nameController.text;
                        if (fileName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select or name a file first')),
                          );
                          return;
                        }
                        
                        final newDoc = {
                          'case': _selectedCase,
                          'folder': _selectedType == 'Evidence / Document' ? 'All' : _selectedType,
                          'name': fileName,
                          'type': _selectedType,
                          'uploadedBy': 'Haris khan',
                          'date': '13-Aug-2026, 03:20 pm',
                          'size': _pickedFileSize ?? '1.6 MB',
                        };
                        widget.onUpload(newDoc);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A980),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      'Upload',
                      style: AppTypography.bodyInterMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  Widget _buildUploadDropzone() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_pickedFileName != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF1E88E5), size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  _pickedFileName!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyInterMedium.copyWith(
                    color: AppColors.primaryNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pickedFileSize ?? 'Unknown size',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _selectDocument,
                  child: Text(
                    'Change File',
                    style: AppTypography.bodyInterMedium.copyWith(
                      color: const Color(0xFF00A980),
                      fontSize: 12,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFF10B981), size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  'Drag & drop files here',
                  style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'or',
                  style: AppTypography.bodyInter.copyWith(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _selectDocument,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00A980)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    _isPicking ? 'Opening...' : 'Browse Files',
                    style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF00A980)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Max file size: 25 MB',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Case *',
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCase,
          items: widget.cases.map((c) {
            return DropdownMenuItem(value: c, child: Text(c));
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedCase = val!;
            });
          },
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 16),

        Text(
          'Document Type *',
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedType,
          items: _types.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedType = val!;
            });
          },
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 16),

        Text(
          'Display Name (optional)',
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration(hint: 'Override file name...'),
        ),
        const SizedBox(height: 16),

        Text(
          'Description (optional)',
          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryNavy, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descController,
          maxLines: 3,
          decoration: _inputDecoration(hint: 'Add a brief description...'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}
