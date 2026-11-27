import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_card.dart';
import 'package:skillswap/models/user_profile_model.dart';
import 'package:skillswap/screens/edit_profile_screen.dart';
import 'package:skillswap/screens/login_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key, this.profile = UserProfile.sample});

  /// The profile to show. Until Firebase is connected it defaults to the
  /// sample data. Later it will be loaded from the users collection.
  final UserProfile profile;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  Future<void> _openEditProfile() async {
    // The edit screen returns the updated profile when the user saves.
    final UserProfile? updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: _profile)),
    );
    if (!mounted || updated == null) return;
    setState(() => _profile = updated);
  }

  @override
  Widget build(BuildContext context) {
    final String ratingText = _profile.ratingCount == 0
        ? '-'
        : _profile.ratingAverage.toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('My profile', style: AppTextStyles.heading2),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              spacing: 4,
              children: [
                const Icon(Icons.toll_rounded,
                    size: 16, color: AppColors.warning),
                Text('${_profile.pointsBalance} pts',
                    style: AppTextStyles.label),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              _buildProfileCard(),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildStat(
                        Icons.star_rounded, ratingText, 'Tutor rating'),
                  ),
                  Expanded(
                    child: _buildStat(Icons.rate_review_outlined,
                        '${_profile.ratingCount}', 'Reviews'),
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildStat(Icons.toll_rounded,
                        '${_profile.pointsBalance} pts', 'Balance'),
                  ),
                  Expanded(
                    child: _buildStat(Icons.school_outlined,
                        '${_profile.teachSkills.length}', 'Skills taught'),
                  ),
                ],
              ),
              _buildWalletCard(),
              _buildSkillsCard('Skills I teach', _profile.teachSkills),
              _buildSkillsCard('Skills I want to learn', _profile.learnSkills),
              _buildAvailabilityCard(),
              CustomButton(
                label: 'Edit profile',
                leading: const Icon(Icons.edit_outlined, size: 18),
                onPressed: _openEditProfile,
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: sign out with Firebase Auth here.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text(
                  'Log out',
                  style: AppTextStyles.label.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final bool hasPhoto = _profile.photoUrl.isNotEmpty;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.surfaceLight,
                backgroundImage:
                hasPhoto ? NetworkImage(_profile.photoUrl) : null,
                child: hasPhoto
                    ? null
                    : const Icon(Icons.person,
                    size: 40, color: AppColors.primary),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_profile.fullName, style: AppTextStyles.heading2),
                    Text(_profile.university, style: AppTextStyles.bodyMedium),
                    Text(
                      _profile.major,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            _profile.bio.isEmpty ? 'No bio yet' : _profile.bio,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceLight,
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.heading3),
                Text(label, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Material(
      color: AppColors.accentLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: open the points wallet screen (screen 12).
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.accent,
                child: Icon(Icons.toll_rounded, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Points wallet', style: AppTextStyles.heading3),
                    Text('${_profile.pointsBalance} points available',
                        style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsCard(String title, List<String> skills) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(title, style: AppTextStyles.heading3),
          if (skills.isEmpty)
            Text('No skills added yet', style: AppTextStyles.bodySmall)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map(
                    (skill) => Chip(
                  label: Text(
                    skill,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primaryDark),
                  ),
                  backgroundColor: AppColors.surfaceLight,
                  side: BorderSide.none,
                ),
              )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    final Set<int> availableDays = _profile.availableDayIndexes;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('Weekly availability', style: AppTextStyles.heading3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _days.length,
                  (i) => CircleAvatar(
                radius: 18,
                backgroundColor: availableDays.contains(i)
                    ? AppColors.primary
                    : AppColors.surfaceLight,
                child: Text(
                  _days[i],
                  style: AppTextStyles.label.copyWith(
                    color: availableDays.contains(i)
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}