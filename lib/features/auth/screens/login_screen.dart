import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/responsive.dart';
import '../../splash/widgets/qanomy_animated_logo.dart';
import '../../navigation/main_layout.dart';
import '../../super_admin/screens/super_admin_main_layout.dart';
import '../../client_portal/screens/client_portal_main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Toggle between Sign In and Sign Up screens
  bool _isSignUp = false;

  // Sign In Controllers
  final _loginEmailController = TextEditingController(text: 'mahnoor@gmail.com');
  final _loginPasswordController = TextEditingController(text: 'Mahnoor123');

  // Sign Up Controllers
  final _signUpNameController = TextEditingController();
  final _signUpFirmController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPhoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _showEmailConfirmation = false;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpFirmController.dispose();
    _signUpEmailController.dispose();
    _signUpPhoneController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  // Handle mock authentication flow
  Future<void> _handleSubmit() async {
    if (_isSignUp && !_agreeToTerms) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please agree to the Terms of Service and Privacy Policy.',
                  style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate validation latency
      await Future.delayed(const Duration(milliseconds: 1200));
      
      if (mounted) {
        setState(() => _isLoading = false);

        if (_isSignUp) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Account created successfully!',
                      style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.primaryNavy,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
              duration: const Duration(seconds: 2),
            ),
          );
          setState(() {
            _showEmailConfirmation = true;
          });
        } else {
          final email = _loginEmailController.text.trim();
          final password = _loginPasswordController.text.trim();

          if (email == 'haris@gmail.com' && password == 'Mahnoor123') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Logged in successfully as $email',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primaryNavy,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SuperAdminMainLayout(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          } else if (email == 'mahnoor@gmail.com' && password == 'Mahnoor123') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Logged in successfully as $email',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primaryNavy,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const MainLayout(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          } else if (email == 'beerus@gmail.com' && password == 'Mahnoor123') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Logged in successfully as $email (Client Portal)',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primaryNavy,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const ClientPortalMainLayout(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Invalid credentials! Use mahnoor@gmail.com / Mahnoor123 or haris@gmail.com / Mahnoor123.',
                        style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    }
  }

  void _showMockRedirect(String url) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.open_in_new, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Redirecting to $url...',
                style: AppTypography.bodyInterMedium.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.princetonOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.inputs),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Exact dark background color from your screenshots
    const Color darkBgColor = Color(0xFF0C1625);

    return Scaffold(
      backgroundColor: darkBgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _showEmailConfirmation 
                    ? 460 
                    : (_isSignUp ? 500 : 420),
              ),
              child: Form(
                key: _formKey,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.05),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showEmailConfirmation
                      ? _buildEmailConfirmationView()
                      : (_isSignUp ? _buildSignUpView() : _buildSignInView()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- SIGN IN VIEW ---
  Widget _buildSignInView() {
    return Column(
      key: const ValueKey('SignInView'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Custom Logo Container
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.skyBlue.withOpacity(0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const QanomyAnimatedLogo(customSize: 72.0),
          ),
        ),
        const SizedBox(height: 24),

        // Welcome back divider line
        _buildDivider('WELCOME BACK', const Color(0xFFFB8500)),
        const SizedBox(height: 20),

        // Title Header
        Center(
          child: Text(
            'Sign in to Qanomy',
            style: AppTypography.header.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'YOUR DIGITAL CASE DIARY',
            style: AppTypography.bodyInterSemiBold.copyWith(
              fontSize: 12,
              color: const Color(0xFF8296A4),
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 36),

        // Email field
        _buildInputLabel('EMAIL'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _loginEmailController,
          style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF023047), fontSize: 15),
          decoration: _buildSignInInputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: Icons.mail_outline_rounded,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Password field
        _buildInputLabel('PASSWORD'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _loginPasswordController,
          obscureText: _obscurePassword,
          style: AppTypography.bodyInterMedium.copyWith(color: const Color(0xFF023047), fontSize: 15),
          decoration: _buildSignInInputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline_rounded,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF8296A4),
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Checkbox & Forgot Password Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Circular custom checkbox for Remember me
            GestureDetector(
              onTap: () => setState(() => _rememberMe = !_rememberMe),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _rememberMe ? const Color(0xFFFB8500) : const Color(0xFF5D7290),
                        width: 1.5,
                      ),
                      color: _rememberMe ? const Color(0xFFFB8500) : Colors.transparent,
                    ),
                    child: _rememberMe
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Remember me',
                    style: AppTypography.bodyInterMedium.copyWith(
                      color: const Color(0xFF8296A4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Forgot Password
            TextButton(
              onPressed: () => _showMockRedirect('https://qanomy.com/forgot-password'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
              child: Text(
                'Forgot password?',
                style: AppTypography.bodyInterSemiBold.copyWith(
                  color: const Color(0xFFFB8500),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Sign In Button
        _buildPrimaryButton(
          text: 'Sign in',
          onPressed: _handleSubmit,
        ),
        const SizedBox(height: 32),

        // New to Qanomy divider line
        _buildDivider('NEW TO QANOMY', const Color(0xFF3E5066)),
        const SizedBox(height: 24),

        // Create free account outlined button
        OutlinedButton(
          onPressed: () => setState(() {
            _isSignUp = true;
            _formKey.currentState?.reset();
          }),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1B2B3E), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.transparent,
          ),
          child: Text(
            'Create a free account',
            style: AppTypography.bodyInterSemiBold.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // --- SIGN UP VIEW ---
  Widget _buildSignUpView() {
    return Column(
      key: const ValueKey('SignUpView'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Custom Logo Container
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.skyBlue.withOpacity(0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const QanomyAnimatedLogo(customSize: 72.0),
          ),
        ),
        const SizedBox(height: 24),

        // Start free trial divider line
        _buildDivider('START FREE TRIAL', const Color(0xFFFB8500)),
        const SizedBox(height: 20),

        // Title Header
        Center(
          child: Text(
            'Create your account',
            style: AppTypography.header.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            '30 DAYS FREE · NO CARD REQUIRED',
            style: AppTypography.bodyInterSemiBold.copyWith(
              fontSize: 12,
              color: const Color(0xFF8296A4),
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Name & Firm (Row on Desktop, Column on Mobile)
        Responsive(
          mobile: Column(
            children: [
              _buildSignUpField(
                label: 'FULL NAME',
                controller: _signUpNameController,
                hintText: 'Ayesha Khan',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),
              _buildSignUpField(
                label: 'FIRM / CHAMBER',
                controller: _signUpFirmController,
                hintText: 'Khan & Associates',
                prefixIcon: Icons.business_outlined,
              ),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSignUpField(
                  label: 'FULL NAME',
                  controller: _signUpNameController,
                  hintText: 'Ayesha Khan',
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSignUpField(
                  label: 'FIRM / CHAMBER',
                  controller: _signUpFirmController,
                  hintText: 'Khan & Associates',
                  prefixIcon: Icons.business_outlined,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Email & Phone (Row on Desktop, Column on Mobile)
        Responsive(
          mobile: Column(
            children: [
              _buildSignUpField(
                label: 'EMAIL ADDRESS',
                controller: _signUpEmailController,
                hintText: 'ayesha@khanlaw.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildSignUpField(
                label: 'PHONE NUMBER',
                controller: _signUpPhoneController,
                hintText: '03001234567',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSignUpField(
                  label: 'EMAIL ADDRESS',
                  controller: _signUpEmailController,
                  hintText: 'ayesha@khanlaw.com',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSignUpField(
                  label: 'PHONE NUMBER',
                  controller: _signUpPhoneController,
                  hintText: '03001234567',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Password field
        _buildSignUpField(
          label: 'PASSWORD',
          controller: _signUpPasswordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF8296A4),
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 20),

        // White Square Checkbox & Terms of Service text
        GestureDetector(
          onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: _agreeToTerms
                    ? const Icon(Icons.check, size: 14, color: Color(0xFF0C1625))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyInter.copyWith(
                      color: const Color(0xFF8296A4),
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _showMockRedirect('Terms of Service'),
                          child: Text(
                            'Terms of Service',
                            style: AppTypography.bodyInterSemiBold.copyWith(
                              color: const Color(0xFFFB8500),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _showMockRedirect('Privacy Policy'),
                          child: Text(
                            'Privacy Policy',
                            style: AppTypography.bodyInterSemiBold.copyWith(
                              color: const Color(0xFFFB8500),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Create Account Button
        _buildPrimaryButton(
          text: 'CREATE TRIAL ACCOUNT',
          onPressed: _handleSubmit,
        ),
        const SizedBox(height: 28),

        // Footer transition back to Sign In
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: AppTypography.bodyInter.copyWith(
                color: const Color(0xFF8296A4),
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                _isSignUp = false;
                _formKey.currentState?.reset();
              }),
              child: Text(
                'Sign in',
                style: AppTypography.bodyInterSemiBold.copyWith(
                  color: const Color(0xFFFB8500),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- REUSABLE UI BUILDERS ---

  Widget _buildInputLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTypography.bodyInterSemiBold.copyWith(
          fontSize: 11,
          color: const Color(0xFF8296A4),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Divider with short elegant lines on both sides
  Widget _buildDivider(String text, Color color) {
    return Center(
      child: SizedBox(
        width: 320,
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: color.withOpacity(0.4),
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                text,
                style: AppTypography.bodyInterSemiBold.copyWith(
                  fontSize: 10,
                  color: color,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: color.withOpacity(0.4),
                thickness: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // The custom light blue-white input decoration for Sign In
  InputDecoration _buildSignInInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTypography.bodyInter.copyWith(color: const Color(0xFF8296A4), fontSize: 15),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Icon(prefixIcon, color: const Color(0xFFFB8500), size: 20),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFEAF2FF),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFFB8500), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  // Reusable component builder for Sign Up dark fields
  Widget _buildSignUpField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyInterMedium.copyWith(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.bodyInter.copyWith(color: const Color(0xFF3E5066), fontSize: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Icon(prefixIcon, color: const Color(0xFFFB8500), size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFF0F223A).withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1B355A), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFB8500), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  // The premium orange button with a trailing arrow icon
  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFB8500),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFB8500).withOpacity(0.5),
          disabledForegroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppTypography.bodyInterSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmailConfirmationView() {
    return Column(
      key: const ValueKey('EmailConfirmationView'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF162539),
            ),
            child: const Center(
              child: Icon(
                Icons.mail_outline_rounded,
                color: Color(0xFFFB8500),
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            'Confirm your email address',
            textAlign: TextAlign.center,
            style: AppTypography.header.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.bodyInter.copyWith(
              color: const Color(0xFF8296A4),
              fontSize: 15,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: "We've sent a verification link to "),
              TextSpan(
                text: _signUpEmailController.text.isNotEmpty 
                    ? _signUpEmailController.text 
                    : 'mahnoor0999@gmail.com',
                style: AppTypography.bodyInterSemiBold.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ". Please click the link in that email to confirm and activate your account."),
            ],
          ),
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showEmailConfirmation = false;
                _isSignUp = false;
                _formKey.currentState?.reset();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB8500),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Text(
              'Go to Sign In',
              style: AppTypography.bodyInterSemiBold.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _showEmailConfirmation = false;
                _isSignUp = true;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Back to Sign Up',
              style: AppTypography.bodyInterSemiBold.copyWith(
                color: const Color(0xFF8296A4),
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
