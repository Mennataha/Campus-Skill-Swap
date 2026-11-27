import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/tutor_profile_mock_data.dart';
import 'home_widgets.dart' show PersonAvatar;

const List<BoxShadow> _softShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
];

/// كارت أبيض عام بنستخدمه لكل قسم
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

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
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final double fontSize;

  const _Pill({
    required this.text,
    required this.background,
    required this.foreground,
    this.icon,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

/// عنوان القسم: أيقونة + عنوان (+ عنوان فرعي) وعلى اليمين Badge أو نص
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SectionTitle({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// ---------------------------------------------------------------
/// Header: ← Tutor Profile + أيقونة البروفايل
/// ---------------------------------------------------------------
class TutorProfileHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const TutorProfileHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          const Expanded(
            child: Text(
              'Tutor Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Hero Card
/// ---------------------------------------------------------------
class ProfileHeroCard extends StatelessWidget {
  final TutorProfileData tutor;

  const ProfileHeroCard({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _softShadow,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surfaceMint, Colors.white],
          stops: [0.0, 0.55],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: PersonAvatar(
                  name: tutor.name,
                  imageUrl: tutor.imageUrl,
                  radius: 48,
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Pill(
            text: tutor.verifiedLabel,
            background: AppColors.primaryLight,
            foreground: AppColors.primaryDark,
            icon: Icons.verified_user_outlined,
            fontSize: 12,
          ),
          const SizedBox(height: 10),
          Text(
            tutor.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tutor.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(
                background: AppColors.accentLight,
                foreground: AppColors.accentDark,
                icon: Icons.star_border_rounded,
                bold: tutor.rating.toStringAsFixed(1),
                regular: '(${tutor.reviewsCount} reviews)',
              ),
              _StatChip(
                background: AppColors.surfaceBlue,
                foreground: AppColors.textPrimary,
                icon: Icons.school_outlined,
                bold: '${tutor.hoursTaught} hrs taught',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final Color background;
  final Color foreground;
  final IconData icon;
  final String bold;
  final String? regular;

  const _StatChip({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.bold,
    this.regular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 5),
          Text(
            bold,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
          if (regular != null) ...[
            const SizedBox(width: 5),
            Text(regular!, style: TextStyle(fontSize: 12, color: foreground)),
          ],
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// About
/// ---------------------------------------------------------------
class AboutSection extends StatelessWidget {
  final TutorProfileData tutor;

  const AboutSection({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.badge_outlined,
            title: 'About ${tutor.firstName}',
            trailing: _Pill(
              text: tutor.aboutBadge,
              background: AppColors.primaryLight,
              foreground: AppColors.primaryDark,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tutor.about,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Skills They Teach
/// ---------------------------------------------------------------
class SkillsSection extends StatelessWidget {
  final List<TutorSkill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.psychology_alt_outlined,
            title: 'Skills They Teach',
            trailing: Text(
              '${skills.length} topics',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) => _SkillChip(skill: s)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final TutorSkill skill;

  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    final bool expert = skill.isExpert;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: expert ? 10 : 8),
      decoration: BoxDecoration(
        color: expert ? AppColors.primaryLight : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            skill.icon,
            size: 16,
            color: expert ? AppColors.primaryDark : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              skill.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: expert ? FontWeight.w800 : FontWeight.w600,
                color: expert ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          if (expert) ...[
            const SizedBox(width: 8),
            const Text(
              'EXPERT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Availability
/// ---------------------------------------------------------------
class AvailabilitySection extends StatelessWidget {
  final TutorProfileData tutor;

  const AvailabilitySection({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.calendar_month_outlined,
            title: 'Availability',
            trailing: Text(
              tutor.timezone,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: AppColors.accentDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tutor.responseNote,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...tutor.availability.map(
            (slot) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AvailabilityRow(slot: slot),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  final AvailabilitySlot slot;

  const _AvailabilityRow({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(slot.icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.day,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  slot.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _Pill(
            text: slot.isAvailable ? 'Available' : 'Busy',
            background: slot.isAvailable
                ? AppColors.primaryLight
                : AppColors.surfaceBlue,
            foreground: slot.isAvailable
                ? AppColors.primaryDark
                : AppColors.textSecondary,
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Student Reviews
/// ---------------------------------------------------------------
class ReviewsSection extends StatelessWidget {
  final TutorProfileData tutor;

  const ReviewsSection({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.rate_review_outlined,
            title: 'Student Reviews',
            subtitle: 'Real feedback from verified peers',
            trailing: _Pill(
              text: '${tutor.rating.toStringAsFixed(1)} / 5.0',
              background: AppColors.accentLight,
              foreground: AppColors.accentDark,
              icon: Icons.star_border_rounded,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ...tutor.reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReviewCard(review: r),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final StudentReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PersonAvatar(
                name: review.name,
                imageUrl: review.imageUrl,
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      review.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < review.stars
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 14,
                        color: AppColors.star,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    review.timeAgo,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------
/// Bottom Bar: السعر + الرصيد + زر Request Session
/// ---------------------------------------------------------------
class RequestSessionBar extends StatelessWidget {
  final int pricePerHour;
  final int balance;
  final VoidCallback? onRequest;

  const RequestSessionBar({
    super.key,
    required this.pricePerHour,
    required this.balance,
    this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0x14000000))),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    size: 18,
                    color: AppColors.accentDark,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$pricePerHour pts',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    ' / hr',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Your balance: $balance pts',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: onRequest ?? () {}, // شكلي - الحجز مع Member C
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
                      'Request Session',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
