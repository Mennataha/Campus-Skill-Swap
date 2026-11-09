import 'package:flutter/material.dart';
import 'package:skillswap/presentation/login_screen.dart';
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
      home:LoginScreen()
    );
  }
}
