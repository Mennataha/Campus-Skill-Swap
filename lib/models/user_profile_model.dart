/// One user profile. It matches the `users` collection in the database design,
/// so the same class can be filled from Firestore later with [fromMap].
class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String university;
  final String major;
  final String bio;
  final String photoUrl;
  final List<String> teachSkills;
  final List<String> learnSkills;

  /// Day key to time ranges, for example {'mon': ['17:00-21:00']}.
  final Map<String, List<String>> availability;

  final int pointsBalance;
  final double ratingAverage;
  final int ratingCount;

  const UserProfile({
    required this.uid,
    required this.fullName,
    this.email = '',
    this.university = '',
    this.major = '',
    this.bio = '',
    this.photoUrl = '',
    this.teachSkills = const [],
    this.learnSkills = const [],
    this.availability = const {},
    this.pointsBalance = 0,
    this.ratingAverage = 0,
    this.ratingCount = 0,
  });

  // ---------------------------------------------------------------------
  // Availability helpers. The screens show days and time-of-day chips, the
  // database stores day keys and time ranges. These convert between the two.
  // ---------------------------------------------------------------------

  /// Monday is index 0. The same order is used by the day circles in the UI.
  static const List<String> dayKeys = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];

  /// Chip label to the time range stored in the database.
  static const Map<String, String> timeRanges = {
    'Morning': '08:00-12:00',
    'Afternoon': '12:00-17:00',
    'Evening': '17:00-21:00',
  };

  /// Indexes (0 to 6) of the days the user is available.
  Set<int> get availableDayIndexes => {
    for (final String key in availability.keys)
      if (dayKeys.contains(key)) dayKeys.indexOf(key),
  };

  /// Chip labels (Morning, Afternoon, Evening) used on any day.
  Set<String> get availableTimeLabels {
    final Set<String> labels = {};
    for (final List<String> ranges in availability.values) {
      for (final String range in ranges) {
        for (final MapEntry<String, String> slot in timeRanges.entries) {
          if (slot.value == range) labels.add(slot.key);
        }
      }
    }
    return labels;
  }

  /// Builds the availability map from what the user picked on screen.
  static Map<String, List<String>> buildAvailability({
    required Set<int> days,
    required Set<String> times,
  }) {
    final List<String> ranges = [
      for (final String label in times)
        if (timeRanges.containsKey(label)) timeRanges[label]!,
    ];
    return {
      for (final int index in days) dayKeys[index]: List<String>.of(ranges),
    };
  }

  // ---------------------------------------------------------------------
  // Copy, Firestore conversion, and sample data
  // ---------------------------------------------------------------------

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? university,
    String? major,
    String? bio,
    String? photoUrl,
    List<String>? teachSkills,
    List<String>? learnSkills,
    Map<String, List<String>>? availability,
    int? pointsBalance,
    double? ratingAverage,
    int? ratingCount,
  }) {
    return UserProfile(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      university: university ?? this.university,
      major: major ?? this.major,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      teachSkills: teachSkills ?? this.teachSkills,
      learnSkills: learnSkills ?? this.learnSkills,
      availability: availability ?? this.availability,
      pointsBalance: pointsBalance ?? this.pointsBalance,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  /// Reads a Firestore document. [uid] is the document id.
  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    final Map<String, dynamic> rawAvailability =
        (map['availability'] as Map<String, dynamic>?) ?? {};

    return UserProfile(
      uid: uid,
      fullName: (map['fullName'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      university: (map['university'] as String?) ?? '',
      major: (map['major'] as String?) ?? '',
      bio: (map['bio'] as String?) ?? '',
      photoUrl: (map['photoUrl'] as String?) ?? '',
      teachSkills: List<String>.from((map['teachSkills'] as List?) ?? []),
      learnSkills: List<String>.from((map['learnSkills'] as List?) ?? []),
      availability: rawAvailability.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
      pointsBalance: ((map['pointsBalance'] as num?) ?? 0).toInt(),
      ratingAverage: ((map['ratingAverage'] as num?) ?? 0).toDouble(),
      ratingCount: ((map['ratingCount'] as num?) ?? 0).toInt(),
    );
  }

  /// The fields a user may change when saving the profile.
  /// pointsBalance and the rating are left out on purpose: the database
  /// design says they are changed only by the points logic.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'university': university,
      'major': major,
      'bio': bio,
      'photoUrl': photoUrl,
      'teachSkills': teachSkills,
      'learnSkills': learnSkills,
      'availability': availability,
    };
  }

  /// Fake data for building the screens before Firebase is connected.
  static const UserProfile sample = UserProfile(
    uid: 'sample-user',
    fullName: 'Alex Chen',
    email: 'alex.chen@university.edu',
    university: 'Stanford University',
    major: 'Cognitive Science',
    bio:
    'Junior studying human-computer interaction and algorithms. Passionate about helping students master Figma, frontend design systems, and introductory Python.',
    teachSkills: ['UI/UX Design', 'Figma', 'Python'],
    learnSkills: ['Calculus II', 'Spanish B1'],
    availability: {
      'mon': ['17:00-21:00'],
      'wed': ['17:00-21:00'],
      'sun': ['17:00-21:00'],
    },
    pointsBalance: 10,
    ratingAverage: 4.9,
    ratingCount: 18,
  );
}