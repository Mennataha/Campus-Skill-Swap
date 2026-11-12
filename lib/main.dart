import 'package:flutter/material.dart';
import 'package:skillswap/screens/request_session_page.dart';
import 'package:skillswap/screens/session_dashboard_page.dart';
import 'package:skillswap/screens/session_detailes_page.dart';
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
      home: const Scaffold(
        body: Center(
          child: Text(
            'Welcome to SkillSwap!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
