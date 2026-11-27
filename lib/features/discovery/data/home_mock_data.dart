import 'package:flutter/material.dart';

/// بيانات تجريبية للـ Home - هتتبدل ببيانات حقيقية من Firebase/API بعدين.

class Tutor {
  final String name;
  final String major;
  final String skill;
  final double rating;
  final int reviewsCount;
  final int pricePerHour; // Tutor session price (points per hour)
  final String? imageUrl; // صورة تجريبية - لو null بنعرض الحروف الأولى

  const Tutor({
    required this.name,
    required this.major,
    required this.skill,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerHour,
    this.imageUrl,
  });
}

enum SkillTone { mint, blue, orange }

class SkillCategory {
  final String name;
  final int tutorsCount;
  final IconData icon;
  final SkillTone tone;

  const SkillCategory({
    required this.name,
    required this.tutorsCount,
    required this.icon,
    required this.tone,
  });
}

class UpcomingSession {
  final String personName;
  final String subject;
  final String topic;
  final String roleLabel;
  final String date;
  final String time;
  final String meetingNote;
  final String? imageUrl;

  const UpcomingSession({
    required this.personName,
    required this.subject,
    required this.topic,
    required this.roleLabel,
    required this.date,
    required this.time,
    required this.meetingNote,
    this.imageUrl,
  });
}

class HomeMockData {
  HomeMockData._();

  // Campus Points
  static const int pointsBalance = 30;
  static const int pointsPerTeachingHour = 2; // Teaching points
  static const String scholarLevel = 'Active Scholar';

  static const String studentName = 'Student';

  // Upcoming Session
  static const int totalSessionsLabel = 3; // مجرد عنصر ظاهر في التصميم
  static const UpcomingSession upcomingSession = UpcomingSession(
    personName: 'Maya Lin',
    subject: 'Calculus I',
    topic: 'Derivatives & Integrals',
    roleLabel: 'You are learning',
    date: 'Tomorrow, Oct 24',
    time: '3:30 PM - 4:30 PM',
    meetingNote: 'Google Meet link will appear 15m before',
  );

  // Recommended Tutors
  static const List<Tutor> tutors = [
    Tutor(
      name: 'Marcus Vance',
      major: "Computer Science '25",
      skill: 'Python & Algorithms',
      rating: 4.9,
      reviewsCount: 28,
      pricePerHour: 10,
    ),
    Tutor(
      name: 'Elena Rostova',
      major: "Applied Mathematics '24",
      skill: 'Linear Algebra',
      rating: 5.0,
      reviewsCount: 19,
      pricePerHour: 10,
    ),
    Tutor(
      name: 'Jordan Lee',
      major: "Design & HCI '26",
      skill: 'UI/UX Design & Figma',
      rating: 4.8,
      reviewsCount: 14,
      pricePerHour: 10,
    ),
  ];

  // Browse by Skill
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      name: 'Programming',
      tutorsCount: 24,
      icon: Icons.code_rounded,
      tone: SkillTone.mint,
    ),
    SkillCategory(
      name: 'Mathematics',
      tutorsCount: 18,
      icon: Icons.functions_rounded,
      tone: SkillTone.mint,
    ),
    SkillCategory(
      name: 'Physics',
      tutorsCount: 12,
      icon: Icons.science_outlined,
      tone: SkillTone.blue,
    ),
    SkillCategory(
      name: 'Languages',
      tutorsCount: 16,
      icon: Icons.language_rounded,
      tone: SkillTone.mint,
    ),
    SkillCategory(
      name: 'Design',
      tutorsCount: 9,
      icon: Icons.palette_outlined,
      tone: SkillTone.orange,
    ),
    SkillCategory(
      name: 'Study Skills',
      tutorsCount: 15,
      icon: Icons.lightbulb_outline_rounded,
      tone: SkillTone.blue,
    ),
  ];

  // Offer Help Banner
  static const String offerTitle = 'Want to earn campus points?';
  static const String offerSubtitle =
      'List your strongest subject & help a peer today.';
}
