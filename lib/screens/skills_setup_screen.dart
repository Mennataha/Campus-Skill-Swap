import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_card.dart';
import 'package:skillswap/models/user_profile_model.dart';
import 'package:skillswap/screens/my_profile_screen.dart';

/// What the screen returns when it is opened from Edit profile.
typedef SkillsResult = ({List<String> teach, List<String> learn});

class SkillsSetupScreen extends StatefulWidget {
  const SkillsSetupScreen({
    super.key,
    this.isEditing = false,
    this.initialTeachSkills = const [],
    this.initialLearnSkills = const [],
  });

  /// false: first-time setup after sign up. true: opened from Edit profile.
  final bool isEditing;

  /// Skills already chosen, shown as chips when editing.
  final List<String> initialTeachSkills;
  final List<String> initialLearnSkills;

  @override
  State<SkillsSetupScreen> createState() => _SkillsSetupScreenState();
}

class _SkillsSetupScreenState extends State<SkillsSetupScreen> {
  final TextEditingController _teachController = TextEditingController();
  final TextEditingController _learnController = TextEditingController();
  late final List<String> _teachSkills =
  List<String>.of(widget.initialTeachSkills);
  late final List<String> _learnSkills =
  List<String>.of(widget.initialLearnSkills);

  // Temporary list. Later this can come from the skills collection.
  final List<String> _suggestions = const [
    'Programming',
    'Math',
    'Physics',
    'Languages',
    'Study skills',
    'Economics',
  ];

  @override
  void dispose() {
    _teachController.dispose();
    _learnController.dispose();
    super.dispose();
  }

  void _addSkill(
      List<String> skills,
      TextEditingController controller, [
        String? value,
      ]) {
    final String skill = (value ?? controller.text).trim();
    if (skill.isEmpty || skills.contains(skill)) return;
    setState(() {
      skills.add(skill);
      controller.clear();
    });
  }

  void _finish() {
    // TODO: save both skill lists to Firestore here.
    final List<String> teach = List<String>.of(_teachSkills);
    final List<String> learn = List<String>.of(_learnSkills);

    if (widget.isEditing) {
      // Send the lists back to Edit profile.
      Navigator.pop(context, (teach: teach, learn: learn));
      return;
    }

    // First-time setup: open the profile with the chosen skills.
    // The sample profile is a stand-in until the real user is loaded.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MyProfileScreen(
          profile: UserProfile.sample.copyWith(
            teachSkills: teach,
            learnSkills: learn,
          ),
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit skills' : 'Skills setup',
          style: AppTextStyles.heading3,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            spacing: 16,
            children: [
              if (!widget.isEditing) ...[
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: _progressSegment(true)),
                    Expanded(child: _progressSegment(true)),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Step 2 of 2: Set up your profile',
                      style: AppTextStyles.bodySmall),
                ),
                _buildWelcomeGift(),
              ],
              _buildSkillSection(
                icon: Icons.school_outlined,
                title: 'Skills I can teach',
                subtitle: 'Share what you are great at and earn points',
                hint: 'Search or add a skill...',
                controller: _teachController,
                skills: _teachSkills,
              ),
              _buildSkillSection(
                icon: Icons.menu_book_outlined,
                title: 'Skills I want to learn',
                subtitle: 'What subjects do you need help with?',
                hint: 'Search subjects or courses...',
                controller: _learnController,
                skills: _learnSkills,
              ),
              if (!widget.isEditing) _buildPointsInfo(),
              CustomButton(
                label: widget.isEditing ? 'Save changes' : 'Finish setup',
                trailingIcon: widget.isEditing ? null : Icons.arrow_forward,
                onPressed: _finish,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressSegment(bool filled) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWelcomeGift() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Icon(Icons.card_giftcard, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Text('Welcome gift', style: AppTextStyles.heading3),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+10 pts',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'You get 10 welcome points to start learning right away. Teach peers to keep refilling your balance.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required String hint,
    required TextEditingController controller,
    required List<String> skills,
  }) {
    final List<String> availableSuggestions =
    _suggestions.where((s) => !skills.contains(s)).toList();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.heading3),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addSkill(skills, controller),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textHint),
              fillColor: AppColors.textFieldBackground,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () => _addSkill(skills, controller),
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.primary),
              ),
            ),
          ),
          if (skills.isNotEmpty)
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
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => setState(() => skills.remove(skill)),
                ),
              )
                  .toList(),
            ),
          if (availableSuggestions.isNotEmpty) ...[
            Text('SUGGESTED', style: AppTextStyles.caption),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSuggestions
                  .map(
                    (s) => ActionChip(
                  label: Text('+ $s', style: AppTextStyles.bodySmall),
                  backgroundColor: AppColors.background,
                  side: const BorderSide(color: AppColors.border),
                  onPressed: () => _addSkill(skills, controller, s),
                ),
              )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPointsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 12,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.surface,
            child: Icon(Icons.swap_horiz, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1 hour taught = 2 points earned',
                    style: AppTextStyles.label),
                Text(
                  'No real money required. Build connections while mastering your major.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}