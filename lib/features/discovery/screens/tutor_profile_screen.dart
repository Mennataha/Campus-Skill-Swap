import 'package:flutter/material.dart';

import '../data/home_mock_data.dart';
import '../data/tutor_profile_mock_data.dart';
import '../widgets/tutor_profile_widgets.dart';

class TutorProfileScreen extends StatelessWidget {
  /// لحد ما نربط البيانات الحقيقية، الشاشة بتعرض Marcus Vance كـ Mock Data.
  final TutorProfileData tutor;

  const TutorProfileScreen({
    super.key,
    this.tutor = TutorProfileMockData.marcus,
  });

  static const Color _background = Color(0xFFF7F9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const TutorProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    ProfileHeroCard(tutor: tutor),
                    const SizedBox(height: 16),
                    AboutSection(tutor: tutor),
                    const SizedBox(height: 16),
                    SkillsSection(skills: tutor.skills),
                    const SizedBox(height: 16),
                    AvailabilitySection(tutor: tutor),
                    const SizedBox(height: 16),
                    ReviewsSection(tutor: tutor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: RequestSessionBar(
          pricePerHour: tutor.pricePerHour,
          balance: HomeMockData.pointsBalance,
        ),
      ),
    );
  }
}
