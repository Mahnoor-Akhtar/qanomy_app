import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class CourtlineIllustration extends StatelessWidget {
  const CourtlineIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double dynamicHeight = (screenHeight * 0.15).clamp(80.0, 150.0);

    return SizedBox(
      height: dynamicHeight,
      width: double.infinity,
      child: CustomPaint(
        painter: _CourtlinePainter(),
      ),
    ).animate(delay: 2000.ms).fadeIn(
          duration: 800.ms,
          curve: Curves.easeIn,
        ).slideY(
          begin: 0.2,
          end: 0,
          duration: 800.ms,
          curve: Curves.easeOut,
        );
  }
}

class _CourtlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.skyBlue.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // A subtle, geometric approximation of a court building and city skyline
    final path = Path();
    
    // Base line
    path.moveTo(0, size.height - 10);
    path.lineTo(size.width, size.height - 10);

    // Center Court Building
    final double center = size.width / 2;
    // Steps
    path.addRect(Rect.fromLTWH(center - 60, size.height - 20, 120, 10));
    path.addRect(Rect.fromLTWH(center - 50, size.height - 30, 100, 10));
    
    // Pillars
    for (int i = 0; i < 4; i++) {
      path.addRect(Rect.fromLTWH(center - 40 + (i * 25), size.height - 80, 10, 50));
    }
    
    // Roof / Pediment
    path.moveTo(center - 55, size.height - 80);
    path.lineTo(center, size.height - 110);
    path.lineTo(center + 55, size.height - 80);
    path.close();

    // Side Buildings (Skyline)
    // Left side
    path.addRect(Rect.fromLTWH(center - 120, size.height - 60, 30, 50));
    path.addRect(Rect.fromLTWH(center - 160, size.height - 90, 25, 80));
    
    // Right side
    path.addRect(Rect.fromLTWH(center + 80, size.height - 70, 20, 60));
    path.addRect(Rect.fromLTWH(center + 110, size.height - 100, 35, 90));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
