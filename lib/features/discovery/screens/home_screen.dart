import 'package:flutter/material.dart';

import '../data/home_mock_data.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _background = Color(0xFFF7F9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HomeHeader(points: HomeMockData.pointsBalance),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CampusPointsCard(
                      points: HomeMockData.pointsBalance,
                      pointsPerHour: HomeMockData.pointsPerTeachingHour,
                      levelLabel: HomeMockData.scholarLevel,
                    ),
                    SizedBox(height: 20),
                    UpcomingSessionSection(
                      session: HomeMockData.upcomingSession,
                      totalCount: HomeMockData.totalSessionsLabel,
                    ),
                    SizedBox(height: 20),
                    RecommendedTutorsSection(tutors: HomeMockData.tutors),
                    SizedBox(height: 20),
                    BrowseBySkillSection(
                      categories: HomeMockData.skillCategories,
                    ),
                    SizedBox(height: 20),
                    OfferHelpBanner(
                      title: HomeMockData.offerTitle,
                      subtitle: HomeMockData.offerSubtitle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(child: HomeBottomNav()),
    );
  }
}
