import 'package:flutter/material.dart';
import 'package:skillswap/core/theme/app_colors.dart';
import 'package:skillswap/core/theme/app_text_styles.dart';
import 'package:skillswap/core/widgets/custom_button.dart';
import 'package:skillswap/core/widgets/custom_card.dart';
import 'package:skillswap/core/widgets/custom_text_field.dart';
import 'package:skillswap/screens/skills_setup_screen.dart';
import 'package:skillswap/models/user_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  /// The profile being edited. Saving pops an updated copy of it.
  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> _times = ['Morning', 'Afternoon', 'Evening'];

  late final TextEditingController _nameController;
  late final TextEditingController _universityController;
  late final TextEditingController _majorController;
  late final TextEditingController _bioController;
  late final Set<int> _selectedDays;
  late final Set<String> _selectedTimes;
  late List<String> _teachSkills;
  late List<String> _learnSkills;

  @override
  void initState() {
    super.initState();
    final UserProfile profile = widget.profile;
    _nameController = TextEditingController(text: profile.fullName);
    _universityController = TextEditingController(text: profile.university);
    _majorController = TextEditingController(text: profile.major);
    _bioController = TextEditingController(text: profile.bio);
    _selectedDays = Set<int>.of(profile.availableDayIndexes);
    _selectedTimes = Set<String>.of(profile.availableTimeLabels);
    _teachSkills = List<String>.of(profile.teachSkills);
    _learnSkills = List<String>.of(profile.learnSkills);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleDay(int index) {
    setState(() {
      if (_selectedDays.contains(index)) {
        _selectedDays.remove(index);
      } else {
        _selectedDays.add(index);
      }
    });
  }

  Future<void> _editSkills() async {
    // The skills screen returns both lists when the user saves.
    final SkillsResult? result = await Navigator.push<SkillsResult>(
      context,
      MaterialPageRoute(
        builder: (_) => SkillsSetupScreen(
          isEditing: true,
          initialTeachSkills: _teachSkills,
          initialLearnSkills: _learnSkills,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _teachSkills = result.teach;
      _learnSkills = result.learn;
    });
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    final UserProfile updated = widget.profile.copyWith(
      fullName: _nameController.text.trim(),
      university: _universityController.text.trim(),
      major: _majorController.text.trim(),
      bio: _bioController.text.trim(),
      teachSkills: _teachSkills,
      learnSkills: _learnSkills,
      availability: UserProfile.buildAvailability(
        days: _selectedDays,
        times: _selectedTimes,
      ),
    );

    // TODO: save updated.toMap() to the user's document in Firestore here.
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile', style: AppTextStyles.heading3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              _buildAvatar(),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text('Personal information', style: AppTextStyles.heading3),
                    CustomTextField(
                      label: 'Full name',
                      hint: 'Your full name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline,
                          color: AppColors.primaryDark),
                    ),
                    CustomTextField(
                      label: 'University',
                      hint: 'Your university',
                      controller: _universityController,
                      prefixIcon: const Icon(Icons.school_outlined,
                          color: AppColors.primaryDark),
                    ),
                    CustomTextField(
                      label: 'Major',
                      hint: 'Your major',
                      controller: _majorController,
                      prefixIcon: const Icon(Icons.menu_book_outlined,
                          color: AppColors.primaryDark),
                    ),
                    // CustomTextField has no maxLines yet, so the bio uses a
                    // plain TextField with the same label style.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bio', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _bioController,
                          maxLines: 4,
                          maxLength: 240,
                          decoration: const InputDecoration(
                            hintText: 'Tell other students about yourself',
                            hintStyle: TextStyle(color: AppColors.textHint),
                            fillColor: AppColors.textFieldBackground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text('Availability', style: AppTextStyles.heading3),
                    Text('Select your days and preferred times',
                        style: AppTextStyles.bodySmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _days.length,
                            (i) => GestureDetector(
                          onTap: () => _toggleDay(i),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: _selectedDays.contains(i)
                                ? AppColors.primary
                                : AppColors.surfaceLight,
                            child: Text(
                              _days[i],
                              style: AppTextStyles.label.copyWith(
                                color: _selectedDays.contains(i)
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _times
                          .map(
                            (time) => FilterChip(
                          label: Text(time, style: AppTextStyles.bodySmall),
                          selected: _selectedTimes.contains(time),
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: AppColors.primaryDark,
                          backgroundColor: AppColors.background,
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              _selectedTimes.add(time);
                            } else {
                              _selectedTimes.remove(time);
                            }
                          }),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text('Skills', style: AppTextStyles.heading3),
                    Text(
                      'Teaching ${_teachSkills.length}  |  Learning ${_learnSkills.length}',
                      style: AppTextStyles.bodySmall,
                    ),
                    CustomButton(
                      label: 'Edit my skills',
                      variant: CustomButtonVariant.secondary,
                      leading: const Icon(Icons.tune, size: 18),
                      onPressed: _editSkills,
                    ),
                  ],
                ),
              ),
              CustomButton(
                label: 'Save changes',
                leading: const Icon(Icons.save_outlined, size: 18),
                onPressed: _save,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Discard changes',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final bool hasPhoto = widget.profile.photoUrl.isNotEmpty;

    return Column(
      spacing: 8,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surfaceLight,
              backgroundImage:
              hasPhoto ? NetworkImage(widget.profile.photoUrl) : null,
              child: hasPhoto
                  ? null
                  : const Icon(Icons.person,
                  size: 52, color: AppColors.primary),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // TODO: pick a photo here.
                  },
                  icon: const Icon(Icons.camera_alt_outlined,
                      size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Text('Change photo',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
      ],
    );
  }
}