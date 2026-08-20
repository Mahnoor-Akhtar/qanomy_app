import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../navigation/main_layout.dart';
import 'add_client_screen.dart';
import 'client_details_screen.dart';
class ClientsScreen extends StatelessWidget {

  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.sidebarNavy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 90,
        leading: Responsive.isMobile(context)
            ? IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  MainLayout.scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
        titleSpacing: 0,
        title: Text(
          'Clients',
          style: AppTypography.header.copyWith(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClientScreen()),
          );
        },
        backgroundColor: const Color(0xFFFF8A00),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // Filter Bar (Horizontally scrollable for mobile)
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
                  _buildFilterDropdown('All Status'),
                  const SizedBox(width: AppSpacing.s12),
                  _buildFilterDropdown('All Client Types'),
                  const SizedBox(width: AppSpacing.s12),
                  _buildFilterDropdown('All Cities'),
                ],
              ),
            ),
          ),
          
          // Data Table / List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.s24),
              children: [
                _buildClientRow(context, '1', 'Hamad Client', 'Individual', '34201-8787378-2', '03087878228', 'lioness99999999@gmail.com')
                    .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms),
                const SizedBox(height: 12),
                _buildClientRow(context, '2', 'Arooj Client', 'Individual', '34989-2989898-9', '03098383388', 'mhamadansari228@gmail.com')
                    .animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms),
                const SizedBox(height: 12),
                _buildClientRow(context, '3', 'Muhammad Ali', 'Individual', '35202-1234567-1', '03087676667', 'mahnoorakhtaransari999@gmail.com')
                    .animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String hint) {
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
          hint: Text(hint, style: AppTypography.bodyInterMedium.copyWith(color: AppColors.primaryNavy)),
          items: const [],
          onChanged: (val) {},
          icon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryNavy),
          ),
        ),
      ),
    );
  }

  Widget _buildClientRow(BuildContext context, String id, String name, String type, String cnic, String phone, String email) {
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
                  name: name,
                  type: type,
                  cnic: cnic,
                  phone: phone,
                  email: email,
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
                      Text(name, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryNavy, fontSize: 16)),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(Icons.category_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(type, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.tag, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text('ID: $id', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
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
