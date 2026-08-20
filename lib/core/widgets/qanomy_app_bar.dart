import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../features/navigation/main_layout.dart';
import '../utils/responsive.dart';

/// A premium, reusable AppBar for all Qanomy screens.
/// Features a dark navy gradient background, optional breadcrumb subtitle,
/// hamburger menu for mobile, and trailing action widgets.
class QanomyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showMenuButton;
  final bool showBackButton;
  final Color? backgroundColor;

  const QanomyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showMenuButton = true,
    this.showBackButton = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final bool canPop = showBackButton && Navigator.of(context).canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor != null
                ? [backgroundColor!, backgroundColor!]
                : [
                    const Color(0xFF0D1B2A),
                    const Color(0xFF1B263B),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: preferredSize.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Row(
                children: [
                  // Leading: menu or back button
                  if (canPop)
                    _NavButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    )
                  else if (showMenuButton && isMobile)
                    _NavButton(
                      icon: Icons.menu_rounded,
                      onTap: () => MainLayout.scaffoldKey.currentState?.openDrawer(),
                    )
                  else
                    const SizedBox(width: 16),

                  const SizedBox(width: 16),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTypography.header.copyWith(
                            color: Colors.white,
                            fontSize: isMobile ? 17 : 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF8A00),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  subtitle!,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 11,
                                    letterSpacing: 0.1,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing actions
                  if (actions != null) ...[
                    const SizedBox(width: 8),
                    ...actions!.map((a) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: a,
                        )),
                  ] else
                    const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon button for nav actions
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// An outlined action button for use inside QanomyAppBar actions.
class QanomyAppBarButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const QanomyAppBarButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final c = color ?? Colors.white;
    
    if (isMobile) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: c.withOpacity(0.25)),
          ),
          child: Icon(icon, color: c, size: 18),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: c),
      label: Text(label, style: AppTypography.labelSmall.copyWith(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: c.withOpacity(0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
