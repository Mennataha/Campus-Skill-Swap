import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_text_field.dart';
import 'package:skillswap/screens/login_screen.dart';
import 'package:skillswap/screens/skills_setup_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    // Rebuild while typing, so the strength bar and the mismatch message update.
    _passwordController.addListener(_refresh);
    _confirmController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  // 0 to 4: one point each for length, capital letter, number and symbol.
  int get _strength {
    final String p = _passwordController.text;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    return score;
  }

  String get _strengthLabel => ['Weak', 'Weak', 'Fair', 'Good', 'Strong'][_strength];

  Color get _strengthColor {
    if (_strength <= 1) return AppColors.error;
    if (_strength == 2) return AppColors.warning;
    return AppColors.success;
  }

  bool get _passwordsMismatch =>
      _confirmController.text.isNotEmpty &&
      _confirmController.text != _passwordController.text;

  void _createAccount() {
    final bool hasEmptyField = _nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty;

    if (hasEmptyField || _passwordsMismatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return;
    }

    // TODO: create the account with Firebase Auth here.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SkillsSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(child: _progressSegment(true)),
                        Expanded(child: _progressSegment(false)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('STEP 1 OF 2', style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text('Create your account', style: AppTextStyles.heading1),
              const SizedBox(height: 5),
              Text('Join your campus peer learning community',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 25),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      CustomTextField(
                        label: 'Full name',
                        hint: 'Your full name',
                        controller: _nameController,
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.primaryDark),
                      ),
                      CustomTextField(
                        label: 'University email',
                        hint: 'name@university.edu',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.primaryDark),
                      ),
                      Column(
                        spacing: 8,
                        children: [
                          CustomTextField(
                            label: 'Password',
                            hint: 'Create a password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppColors.primaryDark),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                          ),
                          if (_passwordController.text.isNotEmpty)
                            Row(
                              spacing: 6,
                              children: [
                                ...List.generate(
                                  4,
                                  (i) => Expanded(
                                    child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: i < _strength
                                            ? _strengthColor
                                            : AppColors.border,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _strengthLabel,
                                  style: AppTextStyles.caption
                                      .copyWith(color: _strengthColor),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          CustomTextField(
                            label: 'Confirm password',
                            hint: 'Repeat your password',
                            controller: _confirmController,
                            obscureText: _obscureConfirm,
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppColors.primaryDark),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              icon: Icon(_obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                          ),
                          if (_passwordsMismatch)
                            Row(
                              spacing: 6,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 14, color: AppColors.error),
                                Text(
                                  'Passwords do not match',
                                  style: AppTextStyles.caption
                                      .copyWith(color: AppColors.error),
                                ),
                              ],
                            ),
                        ],
                      ),
                      CustomButton(
                        label: 'Create account',
                        trailingIcon: Icons.arrow_forward,
                        onPressed: _createAccount,
                      ),
                      Text(
                        'By continuing, you agree to the terms of use',
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          const Expanded(
                              child: Divider(
                                  color: AppColors.border, thickness: 1)),
                          Text('or continue with',
                              style: AppTextStyles.bodySmall),
                          const Expanded(
                              child: Divider(
                                  color: AppColors.border, thickness: 1)),
                        ],
                      ),
                      CustomButton(
                        leading: Image.asset('assets/images/google_logo.png',
                            height: 20),
                        label: 'Continue with Google',
                        onPressed: () {},
                        variant: CustomButtonVariant.secondary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.surface,
                      child:
                          Icon(Icons.swap_horiz, color: AppColors.primary),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('One account, two modes',
                              style: AppTextStyles.label),
                          Text('Swap freely between teaching and learning.',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: AppTextStyles.bodyMedium),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      'Log in',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressSegment(bool filled) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
