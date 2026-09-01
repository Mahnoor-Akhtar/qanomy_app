import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/qanomy_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';
import 'add_client_screen.dart';
import 'client_details_screen.dart';

enum ClientActionMode { none, edit, delete }

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  ClientActionMode _actionMode = ClientActionMode.none;

  String _selectedStatusFilter = 'All Status';
  String _selectedTypeFilter = 'All Client Types';
  String _selectedCityFilter = 'All Cities';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFabMenu() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _closeFabMenu() {
    if (_animationController.isCompleted || _animationController.isAnimating) {
      _animationController.reverse();
    }
  }

  void _openAddClientScreen() async {
    _closeFabMenu();
    setState(() {
      _actionMode = ClientActionMode.none;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClientScreen()),
    );
  }

  void _navigateToEditScreen(ClientModel client) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddClientScreen(initialClient: client)),
    );
  }

  void _toggleEditMode() {
    _closeFabMenu();
    setState(() {
      if (_actionMode == ClientActionMode.edit) {
        _actionMode = ClientActionMode.none;
      } else {
        _actionMode = ClientActionMode.edit;
      }
    });
  }

  void _toggleDeleteMode() {
    _closeFabMenu();
    setState(() {
      if (_actionMode == ClientActionMode.delete) {
        _actionMode = ClientActionMode.none;
      } else {
        _actionMode = ClientActionMode.delete;
      }
    });
  }

  void _confirmDeleteClient(ClientModel client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete client "${client.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ClientService.instance.deleteClient(client.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Client "${client.name}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<ClientModel> _filterClients(List<ClientModel> clients) {
    final query = _searchController.text.toLowerCase().trim();
    return clients.where((client) {
      final matchesSearch = query.isEmpty ||
          client.name.toLowerCase().contains(query) ||
          client.cnic.toLowerCase().contains(query) ||
          client.phone.toLowerCase().contains(query) ||
          client.email.toLowerCase().contains(query);

      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          client.status.toLowerCase() == _selectedStatusFilter.toLowerCase();

      final matchesType = _selectedTypeFilter == 'All Client Types' ||
          client.type.toLowerCase() == _selectedTypeFilter.toLowerCase();

      final matchesCity = _selectedCityFilter == 'All Cities' ||
          client.city.toLowerCase() == _selectedCityFilter.toLowerCase();

      return matchesSearch && matchesStatus && matchesType && matchesCity;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const QanomyAppBar(
        title: 'Clients',
      ),
      floatingActionButton: _buildExpandableFab(),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
            color: Colors.white,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by client name, CNIC',
                          hintStyle: AppTypography.bodyInter.copyWith(color: AppColors.textMuted),
                          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  _buildFilterDropdown(
                    _selectedStatusFilter,
                    ['All Status', 'Active', 'Inactive'],
                    (val) => setState(() => _selectedStatusFilter = val!),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  _buildFilterDropdown(
                    _selectedTypeFilter,
                    ['All Client Types', 'Individual', 'Corporate', 'Government', 'Other'],
                    (val) => setState(() => _selectedTypeFilter = val!),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  _buildFilterDropdown(
                    _selectedCityFilter,
                    ['All Cities', 'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi'],
                    (val) => setState(() => _selectedCityFilter = val!),
                  ),
                ],
              ),
            ),
          ),

          // Mode Active Banner Indicator
          if (_actionMode != ClientActionMode.none) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _actionMode == ClientActionMode.edit
                      ? const Color(0xFFFF8A00).withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _actionMode == ClientActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _actionMode == ClientActionMode.edit ? Icons.edit_outlined : Icons.delete_outline,
                      color: _actionMode == ClientActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _actionMode == ClientActionMode.edit
                            ? 'Edit Mode Active — tap pencil on any client'
                            : 'Delete Mode Active — tap trash on any client',
                        style: AppTypography.bodyInterMedium.copyWith(
                          fontSize: 13,
                          color: _actionMode == ClientActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _actionMode = ClientActionMode.none),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _actionMode == ClientActionMode.edit ? const Color(0xFFFF8A00) : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Data Table / List
          Expanded(
            child: ValueListenableBuilder<List<ClientModel>>(
              valueListenable: ClientService.instance,
              builder: (context, allClients, _) {
                final filteredClients = _filterClients(allClients);

                if (filteredClients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No clients found',
                          style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  itemCount: filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = filteredClients[index];
                    return _buildClientRow(context, client)
                        .animate(delay: Duration(milliseconds: index * 50))
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.1, duration: 300.ms);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableFab() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double progress = _expandAnimation.value;

        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (progress > 0.01) ...[
                // 1. Add Client (Directly Above main button)
                Positioned(
                  bottom: 60 * progress,
                  right: 0,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Add Client',
                        icon: Icons.add,
                        onPressed: _openAddClientScreen,
                      ),
                    ),
                  ),
                ),

                // 2. Edit Client (Top-Left Diagonal)
                Positioned(
                  bottom: 50 * progress,
                  right: 50 * progress,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Edit Client',
                        icon: Icons.edit_outlined,
                        onPressed: _toggleEditMode,
                      ),
                    ),
                  ),
                ),

                // 3. Delete Client (Directly Left)
                Positioned(
                  bottom: 0,
                  right: 60 * progress,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.scale(
                      scale: progress,
                      child: _buildActionIconButton(
                        label: 'Delete Client',
                        icon: Icons.delete_outline,
                        onPressed: _toggleDeleteMode,
                      ),
                    ),
                  ),
                ),
              ],

              // Main Trigger Button (Bottom-Right corner)
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: FloatingActionButton(
                    heroTag: 'main_client_fab',
                    onPressed: _toggleFabMenu,
                    backgroundColor: const Color(0xFFFF8A00),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: AnimatedRotation(
                      turns: progress * 0.25,
                      duration: Duration.zero,
                      child: Icon(
                        progress > 0.5 ? Icons.close : Icons.menu,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionIconButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FloatingActionButton(
        heroTag: label,
        onPressed: onPressed,
        tooltip: label,
        backgroundColor: const Color(0xFFFF8A00),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildFilterDropdown(String value, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(value) ? value : options.first,
          style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy),
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          onChanged: onChanged,
          icon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
          ),
        ),
      ),
    );
  }

  Widget _buildClientRow(BuildContext context, ClientModel client) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientDetailsScreen(
                  name: client.name,
                  type: client.type,
                  cnic: client.cnic,
                  phone: client.phone,
                  email: client.email,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFE8F5E9),
                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(Icons.category_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(client.type, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.tag, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text('ID: ${client.id}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_actionMode == ClientActionMode.edit) ...[
                  InkWell(
                    onTap: () => _navigateToEditScreen(client),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8A00).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFFF8A00),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (_actionMode == ClientActionMode.delete) ...[
                  InkWell(
                    onTap: () => _confirmDeleteClient(client),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryNavy),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
