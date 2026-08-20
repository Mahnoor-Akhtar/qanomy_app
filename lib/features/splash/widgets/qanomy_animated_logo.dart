import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class QanomyAnimatedLogo extends StatelessWidget {
  const QanomyAnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic sizing based on screen width, bounded by constraints
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double size = (screenWidth * 0.35).clamp(100.0, 180.0); 
    final double strokeWidth = (size * 0.2); // Proportional stroke width

    return Stack(
      alignment: Alignment.center,
      children: [
        // Left Half (Orange)
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ArcPainter(
              color: AppColors.princetonOrange,
              startAngle: 1.5708, // 90 degrees in radians (bottom)
              sweepAngle: 3.14159, // 180 degrees
              strokeWidth: strokeWidth,
            ),
          ),
        ).animate().slideX(
              begin: -1.0,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ).fadeIn(duration: 600.ms),

        // Right Half (Light Blue)
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ArcPainter(
              color: AppColors.skyBlue,
              startAngle: -1.5708, // -90 degrees in radians (top)
              sweepAngle: 3.14159, // 180 degrees
              strokeWidth: strokeWidth,
            ),
          ),
        ).animate().slideX(
              begin: 1.0,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ).fadeIn(duration: 600.ms),

        // Q Tail (Orange)
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            width: 36,
            height: strokeWidth,
            decoration: BoxDecoration(
              color: AppColors.princetonOrange,
              borderRadius: BorderRadius.circular(4),
            ),
          )
              // Rotate to match the Q tail angle
              .animate()
              .custom(
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: 0.785398, // 45 degrees
                    child: child,
                  );
                },
              )
              // Reveal animation
              .slide(
                begin: const Offset(-1.0, -1.0),
                end: Offset.zero,
                delay: 600.ms,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(delay: 600.ms, duration: 400.ms),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;

  _ArcPainter({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width - strokeWidth,
        height: size.height - strokeWidth,
      ),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
