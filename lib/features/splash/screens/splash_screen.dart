import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../navigation/main_layout.dart';
import '../../auth/screens/login_screen.dart';
import '../widgets/courtline_illustration.dart';
import '../widgets/minimal_loader.dart';
import '../widgets/qanomy_animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 4800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final bool isShortScreen = screenHeight < 550;

          return Stack(
            children: [
              // Subtle glowing background effect behind the logo
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.skyBlue.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: isShortScreen ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: screenHeight - (isShortScreen ? 20.0 : 60.0),
                        maxHeight: screenHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 3),
                            // Step 2 & 3: Logo Build and Tail Reveal
                            Center(child: QanomyAnimatedLogo()),
                            
                            SizedBox(height: isShortScreen ? 16 : 32),
                            
                            // Step 4: Brand Name Fade In
                            Text(
                              'QANOMY',
                              style: AppTypography.header.copyWith(
                                color: Colors.white,
                                fontSize: isShortScreen ? 36 : 48,
                                letterSpacing: 4,
                              ),
                            ).animate(delay: 1000.ms).fadeIn(duration: 600.ms).slideY(
                                  begin: 0.5,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                            
                            SizedBox(height: isShortScreen ? 8 : 16),
                            
                            // Step 5: Tagline Fade In
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: AppTypography.bodyInter.copyWith(
                                      fontSize: isShortScreen ? 15 : 18,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Qanoon',
                                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'economy,',
                                        style: AppTypography.bodyInterMedium.copyWith(color: AppColors.princetonOrange),
                                      ),
                                    ],
                                  ),
                                ).animate(delay: 1400.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                                
                                const SizedBox(height: 4),
                                
                                Text(
                                  'held in balance.',
                                  style: AppTypography.bodyInter.copyWith(
                                    fontSize: isShortScreen ? 15 : 18,
                                    color: Colors.white,
                                  ),
                                ).animate(delay: 1600.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                              ],
                            ),
                            
                            const Spacer(flex: 2),
                            
                            // Step 7: Loader Appear
                            const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                color: AppColors.princetonOrange,
                                strokeWidth: 3,
                              ),
                            ).animate(delay: 2000.ms).fadeIn(duration: 400.ms),
                            SizedBox(height: isShortScreen ? 16 : 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Step 6: Illustration Fade In (at the bottom)
              if (screenHeight > 400)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CourtlineIllustration(),
                ),
            ],
          );
        },
      ),
    );
  }
}
