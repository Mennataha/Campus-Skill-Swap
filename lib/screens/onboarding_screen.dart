import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_card.dart';
import 'package:skillswap/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Temporary content. Replace the icons with the illustrations from the design.
  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.menu_book_rounded,
      title: 'Learn what you need',
      description:
          'Stuck on calculus, Python, or economics? Book a session with a classmate who has been there.',
      tip: 'Spend points to unlock study help',
      tipIcon: Icons.bolt_rounded,
    ),
    _OnboardingPage(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Teach what you know',
      description:
          'Share a skill you are good at, help your classmates, and earn points for every hour you teach.',
      tip: 'Earn 2 points per hour taught',
      tipIcon: Icons.stars_rounded,
    ),
    _OnboardingPage(
      icon: Icons.swap_horiz_rounded,
      title: 'Exchange skills freely',
      description:
          'One account, two modes. Switch between teaching and learning whenever you like.',
      tip: 'Learn and teach with one account',
      tipIcon: Icons.people_outline_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _goToSignUp();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset('assets/images/skill_link_logo.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skill link', style: AppTextStyles.heading3),
                      Text('Peer knowledge exchange',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('10 pts free', style: AppTextStyles.label),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 8,
                children: List.generate(
                  _pages.length,
                  (i) => Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentPage
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) =>
                      _buildPage(_pages[index], index),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _goToSignUp,
                    child: Text('Skip',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.primary)),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      label: isLast ? 'Get started' : 'Next',
                      trailingIcon: Icons.arrow_forward,
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CustomCard(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(page.icon, size: 72, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Step ${index + 1} of ${_pages.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  page.title,
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  page.description,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Icon(page.tipIcon, size: 18, color: AppColors.primary),
                      Text(page.tip, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final String tip;
  final IconData tipIcon;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.tip,
    required this.tipIcon,
  });
}
