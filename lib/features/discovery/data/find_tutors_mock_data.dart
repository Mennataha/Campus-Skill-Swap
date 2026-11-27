class TutorListItem {
  final String name;
  final String university;
  final String major;
  final double rating;
  final int reviewsCount;
  final int pricePerHour; // Tutor session price (points per hour)
  final List<String> skills;
  final bool isVerified;
  final bool isOnline;
  final bool availableThisWeek;
  final String? imageUrl; // صورة تجريبية - لو null بنعرض الحروف الأولى

  const TutorListItem({
    required this.name,
    required this.university,
    required this.major,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerHour,
    required this.skills,
    this.isVerified = false,
    this.isOnline = false,
    this.availableThisWeek = true,
    this.imageUrl,
  });

  String get subtitle => '$university • $major';
}

enum TutorSort { topRated, mostReviewed, lowestPrice }

extension TutorSortLabel on TutorSort {
  String get label {
    switch (this) {
      case TutorSort.topRated:
        return 'Top rated';
      case TutorSort.mostReviewed:
        return 'Most reviewed';
      case TutorSort.lowestPrice:
        return 'Lowest price';
    }
  }
}

class FindTutorsMockData {
  FindTutorsMockData._();

  static const String searchHint = 'Search for a skill or tutor (e.g. Python)';
  static const String sampleEmptyQuery = 'Quantum Computing';
  static const int nearbyCount = 3;

  static const List<TutorListItem> tutors = [
    TutorListItem(
      name: 'Marcus Vance',
      university: 'Stanford',
      major: 'B.S. Computer Science',
      rating: 4.9,
      reviewsCount: 32,
      pricePerHour: 10,
      skills: ['Python', 'Data Structures', 'Git'],
      isOnline: true,
    ),
    TutorListItem(
      name: 'Sophia Patel',
      university: 'Stanford',
      major: 'Cognitive Science',
      rating: 5.0,
      reviewsCount: 41,
      pricePerHour: 10,
      skills: ['UI Design', 'Figma', 'User Research'],
      isVerified: true,
      isOnline: true,
    ),
    TutorListItem(
      name: 'David Kim',
      university: 'Stanford',
      major: 'Mechanical Engineering',
      rating: 4.8,
      reviewsCount: 18,
      pricePerHour: 10,
      skills: ['Physics I', 'Calculus II', 'MATLAB'],
      availableThisWeek: false,
    ),
  ];
}
