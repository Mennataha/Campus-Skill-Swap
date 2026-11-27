import 'package:flutter/material.dart';

/// بيانات تجريبية لشاشة Tutor Profile - هتتبدل ببيانات حقيقية من Firebase/API بعدين.

class TutorSkill {
  final String name;
  final IconData icon;
  final bool isExpert;

  const TutorSkill({
    required this.name,
    required this.icon,
    this.isExpert = false,
  });
}

class AvailabilitySlot {
  final String day;
  final String time;
  final IconData icon;
  final bool isAvailable;

  const AvailabilitySlot({
    required this.day,
    required this.time,
    required this.icon,
    this.isAvailable = true,
  });
}

class StudentReview {
  final String name;
  final String subtitle;
  final int stars; // من 1 إلى 5
  final String timeAgo;
  final String comment;
  final String? imageUrl;

  const StudentReview({
    required this.name,
    required this.subtitle,
    required this.stars,
    required this.timeAgo,
    required this.comment,
    this.imageUrl,
  });
}

class TutorProfileData {
  final String name;
  final String university;
  final String major;
  final String verifiedLabel;
  final double rating;
  final int reviewsCount;
  final int hoursTaught;
  final String aboutBadge;
  final String about;
  final List<TutorSkill> skills;
  final String timezone;
  final String responseNote;
  final List<AvailabilitySlot> availability;
  final List<StudentReview> reviews;
  final int pricePerHour; // Tutor session price (points per hour)
  final String? imageUrl;

  const TutorProfileData({
    required this.name,
    required this.university,
    required this.major,
    required this.verifiedLabel,
    required this.rating,
    required this.reviewsCount,
    required this.hoursTaught,
    required this.aboutBadge,
    required this.about,
    required this.skills,
    required this.timezone,
    required this.responseNote,
    required this.availability,
    required this.reviews,
    required this.pricePerHour,
    this.imageUrl,
  });

  String get subtitle => '$university • $major';
  String get firstName => name.split(' ').first;
}

class TutorProfileMockData {
  TutorProfileMockData._();

  static const TutorProfileData marcus = TutorProfileData(
    name: 'Marcus Vance',
    university: 'Stanford University',
    major: "Computer Science '25",
    verifiedLabel: 'Verified Stanford Student',
    rating: 4.9,
    reviewsCount: 32,
    hoursTaught: 48,
    aboutBadge: 'CS106B TA',
    about:
        "Hey! I'm a junior majoring in CS. I've been a TA for CS106B and love "
        'helping students debug tricky pointers, master algorithmic thinking, '
        'and build confidence in Python and C++. Let\'s connect and ace your '
        'midterms!',
    skills: [
      TutorSkill(name: 'Python', icon: Icons.terminal_rounded, isExpert: true),
      TutorSkill(
        name: 'Data Structures & Algorithms',
        icon: Icons.account_tree_outlined,
      ),
      TutorSkill(name: 'C++', icon: Icons.code_rounded),
      TutorSkill(
        name: 'Object-Oriented Programming',
        icon: Icons.integration_instructions_outlined,
      ),
      TutorSkill(name: 'Git & GitHub', icon: Icons.fork_right_rounded),
    ],
    timezone: 'PST Timezone',
    responseNote: 'Quick responder (usually within 2 hours)',
    availability: [
      AvailabilitySlot(
        day: 'Wednesdays',
        time: '4:00 PM – 7:00 PM',
        icon: Icons.event_available_outlined,
      ),
      AvailabilitySlot(
        day: 'Thursdays',
        time: '2:00 PM – 6:00 PM',
        icon: Icons.event_available_outlined,
      ),
      AvailabilitySlot(
        day: 'Saturdays',
        time: '10:00 AM – 2:00 PM',
        icon: Icons.weekend_outlined,
      ),
    ],
    reviews: [
      StudentReview(
        name: 'Emily T.',
        subtitle: 'CS106B Student',
        stars: 5,
        timeAgo: '2 days ago',
        comment:
            '“Marcus explained binary search trees so clearly! We solved two '
            'past exam problems together and he walked me through recursive '
            'thinking patiently.”',
      ),
      StudentReview(
        name: 'Liam R.',
        subtitle: 'Intro to Python',
        stars: 5,
        timeAgo: '1 week ago',
        comment:
            '“Great tutor. Super patient with debugging my Python assignments. '
            'Made sure I actually understood list comprehensions instead of '
            'just feeding me answers.”',
      ),
    ],
    pricePerHour: 10,
  );
}
