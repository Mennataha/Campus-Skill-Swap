import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_text_field.dart';
import 'package:skillswap/screens/my_profile_screen.dart';
import 'package:skillswap/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: sign in with Firebase Auth using the two controllers above.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyProfileScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Center keeps the form in the middle when it fits, and the scroll
        // view lets it scroll on small screens or when the keyboard opens.
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                if (Navigator.canPop(context))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Card(
                    elevation: 4.0,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset('assets/images/skill_link_logo.png'),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Text('Welcome back!', style: AppTextStyles.heading1),
                    const Icon(Icons.auto_awesome,
                        size: 16, color: AppColors.accent),
                  ],
                ),
                const SizedBox(height: 5),
                Text('Log in to pick up where you left off',
                    style: AppTextStyles.bodyMedium),
                const SizedBox(height: 25),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 16,
                      children: [
                        CustomTextField(
                          label: 'University email',
                          hint: 'name@university.edu',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: AppColors.primaryDark),
                        ),
                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
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
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary,
                              onChanged: (bool? newValue) =>
                                  setState(() => _rememberMe = newValue ?? false),
                            ),
                            Expanded(
                              child: Text(
                                'Remember this device',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: open the reset password flow.
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot password?',
                                style: AppTextStyles.label
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        CustomButton(
                          label: 'Log In',
                          onPressed: _login,
                          variant: CustomButtonVariant.primary,
                          trailingIcon: Icons.arrow_forward,
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            const Expanded(
                                child: Divider(
                                    color: AppColors.border, thickness: 1)),
                            Text(
                              'OR CONTINUE WITH',
                              style: AppTextStyles.caption
                                  .copyWith(letterSpacing: 1),
                            ),
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New here?', style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()),
                      ),
                      child: Text(
                        'Sign up',
                        style: AppTextStyles.label.copyWith(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}