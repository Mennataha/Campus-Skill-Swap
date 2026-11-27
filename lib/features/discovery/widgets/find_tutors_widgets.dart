import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/find_tutors_mock_data.dart';
import 'home_widgets.dart' show PersonAvatar;

const List<BoxShadow> _softShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
];

/// ---------------------------------------------------------------
/// Header
/// ---------------------------------------------------------------
class FindTutorsHeader extends StatelessWidget {
  final int points;

  const FindTutorsHeader({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Find Tutors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'SkillSwap Campus',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 18,
                  color: AppColors.accentDark,
                ),
                const SizedBox(width: 6),
                Text(
                  '$points pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.accentDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {}, // شكلي - مفيش Notifications فعلية
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColors.textPrimary,
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Search Bar
/// ---------------------------------------------------------------
class TutorSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const TutorSearchBar({
    super.key,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.tune_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Filter Chips
/// ---------------------------------------------------------------
class TutorFilterChips extends StatelessWidget {
  final bool allSelected;
  final bool ratingSelected;
  final bool availableSelected;
  final VoidCallback onAllTap;
  final VoidCallback onRatingTap;
  final VoidCallback onAvailableTap;

  const TutorFilterChips({
    super.key,
    required this.allSelected,
    required this.ratingSelected,
    required this.availableSelected,
    required this.onAllTap,
    required this.onRatingTap,
    required this.onAvailableTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipItem(
            label: 'All Subjects',
            icon: Icons.check_rounded,
            selected: allSelected,
            onTap: onAllTap,
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: 'Rating 4.0+',
            icon: Icons.star_border_rounded,
            selected: ratingSelected,
            onTap: onRatingTap,
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: 'Available This Week',
            icon: Icons.calendar_today_outlined,
            selected: availableSelected,
            onTap: onAvailableTap,
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? Colors.white : AppColors.textPrimary;
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Section Header (Recommended Peer Tutors + 3 Nearby + Sort by)
/// ---------------------------------------------------------------
class TutorsListHeader extends StatelessWidget {
  final int nearbyCount;
  final TutorSort sort;
  final ValueChanged<TutorSort> onSortChanged;

  const TutorsListHeader({
    super.key,
    required this.nearbyCount,
    required this.sort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: Text(
            'Recommended Peer Tutors',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$nearbyCount Nearby',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const Spacer(),
        PopupMenuButton<TutorSort>(
          initialValue: sort,
          onSelected: onSortChanged,
          itemBuilder: (_) => TutorSort.values
              .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
              .toList(),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------
/// Tutor Card
/// ---------------------------------------------------------------
class TutorListCard extends StatelessWidget {
  final TutorListItem tutor;
  final VoidCallback? onViewProfile;

  const TutorListCard({super.key, required this.tutor, this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  PersonAvatar(
                    name: tutor.name,
                    imageUrl: tutor.imageUrl,
                    radius: 28,
                  ),
                  if (tutor.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tutor.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (tutor.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_rounded,
                          size: 16,
                          color: AppColors.accentDark,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          tutor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${tutor.reviewsCount} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 14,
                      color: AppColors.accentDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tutor.pricePerHour} pts/hr',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tutor.skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      s,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onViewProfile ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Profile',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Preview UI States (Empty State / Loading Skeleton)
/// ---------------------------------------------------------------
enum PreviewMode { emptyState, loadingSkeleton }

class PreviewStatesSection extends StatelessWidget {
  final PreviewMode mode;
  final ValueChanged<PreviewMode> onModeChanged;
  final String emptyQuery;
  final VoidCallback onReset;

  const PreviewStatesSection({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.emptyQuery,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'PREVIEW UI STATES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.textSecondary,
              ),
            ),
            Spacer(),
            Text(
              'Tap to inspect UX',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _SegmentItem(
                label: 'Empty State',
                selected: mode == PreviewMode.emptyState,
                onTap: () => onModeChanged(PreviewMode.emptyState),
              ),
              _SegmentItem(
                label: 'Loading Skeleton',
                selected: mode == PreviewMode.loadingSkeleton,
                onTap: () => onModeChanged(PreviewMode.loadingSkeleton),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (mode == PreviewMode.emptyState)
          TutorsEmptyState(query: emptyQuery, onReset: onReset)
        else
          const TutorsLoadingSkeleton(),
      ],
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? _softShadow : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class TutorsEmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onReset;

  const TutorsEmptyState({
    super.key,
    required this.query,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.surfaceBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tutors found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No peer matches for “$query” in this department yet.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text(
              'Reset filters & view all',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class TutorsLoadingSkeleton extends StatelessWidget {
  const TutorsLoadingSkeleton({super.key});

  Widget _bar(double w, double h) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: AppColors.surfaceBlue,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (i) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: i == 1 ? 0 : 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.surfaceBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bar(120, 16),
                        const SizedBox(height: 8),
                        _bar(170, 12),
                        const SizedBox(height: 8),
                        _bar(90, 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _bar(64, 26),
                  const SizedBox(width: 8),
                  _bar(96, 26),
                  const SizedBox(width: 8),
                  _bar(48, 26),
                ],
              ),
              const SizedBox(height: 14),
              _bar(double.infinity, 48),
            ],
          ),
        );
      }),
    );
  }
}
