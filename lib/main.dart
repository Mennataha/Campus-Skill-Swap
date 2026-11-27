import 'package:flutter/material.dart';
import 'package:skillswap/screens/login_screen.dart';
import 'package:skillswap/screens/onboarding_screen.dart';
import 'package:skillswap/screens/signup_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,

      // App Theme
      theme: AppTheme.lightTheme,

      // Temporary Home Screen
      home:OnboardingScreen()
    );
  }
}
