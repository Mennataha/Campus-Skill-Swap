import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

// -----------------------------------------------------------------------------
// Design tokens that are not part of AppColors (kept local to this page)
// -----------------------------------------------------------------------------
const Color _textMuted = Color(0xFF3D4947); // on-surface-variant
const Color _accentDark = Color(0xFF825100); // tertiary
const Color _accentFixed = Color(0xFFFFDDB8); // tertiary-fixed
const Color _onAccentFixed = Color(0xFF2A1700);
const Color _onAccentFixedVariant = Color(0xFF653E00);
const Color _errorLight = Color(0xFFFFDAD6); // error-container

// Text styles built on top of AppTextStyles (size / weight / line-height from the design)
final TextStyle _headlineMd =
    AppTextStyles.heading3.copyWith(fontSize: 20, height: 28 / 20);
final TextStyle _titleMd =
    AppTextStyles.heading3.copyWith(fontSize: 16, height: 24 / 16);
final TextStyle _bodyMd = AppTextStyles.bodyMedium.copyWith(height: 20 / 14);
final TextStyle _labelLg =
    AppTextStyles.label.copyWith(fontSize: 14, height: 20 / 14);
final TextStyle _labelMd = AppTextStyles.label
    .copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12);
final TextStyle _labelSm = AppTextStyles.caption
    .copyWith(fontSize: 11, fontWeight: FontWeight.w500, height: 14 / 11);

const double _headerHeight = 64;
const double _margin = 16;

class _TimeSlot {
  final String time;
  final String place;
  const _TimeSlot(this.time, this.place);
}

class _DurationOption {
  final String label;
  final int points;
  const _DurationOption(this.label, this.points);
}

const List<_TimeSlot> _slots = [
  _TimeSlot('2:00 PM', 'Library 2F'),
  _TimeSlot('3:30 PM', 'Study Rm 4'),
  _TimeSlot('5:00 PM', 'Virtual / Hub'),
];

const List<_DurationOption> _durations = [
  _DurationOption('30 min', 5),
  _DurationOption('1 hour', 10),
  _DurationOption('1.5 hours', 15),
];

enum _SubmitState { idle, sending, sent }

class RequestSessionPage extends StatefulWidget {
  const RequestSessionPage({super.key});

  @override
  State<RequestSessionPage> createState() => _RequestSessionPageState();
}

class _RequestSessionPageState extends State<RequestSessionPage> {
  static const String _tutorImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDtYTdwD0aceknLA-8uTCKdEmdbSuvkwucvnzW5RzuHZso0JJamrhkDYK4m7ryW38-6jAH9NCAB-OnI1pATE4QCvZWvp-oG6kBMsN_d-n2WukYJGM5X2_VZ9tV9KPV95zclouv4OvDSjh7E-Y_eK0yt_yBFjvdqVE1QLTG5oLkPN27WGZ6yX2OdqVrx8E4LT3nwzCasPzkKkkDjF6kI3ztB9NHvMhRY7T7qrLdfZ5R8iYe86I9tkFRP_w';

  static const int _currentBalance = 30;

  static const List<String> _skills = [
    'Python & Data Structures',
    'Flutter Development',
    'Data Analysis',
    'SQL & Databases',
    'Problem Solving',
  ];

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _selectedSkill = _skills.first;
  DateTime _selectedDate = DateTime(2024, 10, 26);
  int _selectedSlot = 1;
  int _selectedDuration = 1;
  bool _simulateLowBalance = false;
  _SubmitState _submitState = _SubmitState.idle;

  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _noteFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  int get _points => _durations[_selectedDuration].points;

  String get _dateText {
    final d = _selectedDate;
    return '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String get _dateBadge {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _selectedDate.difference(today).inDays < 7
        ? 'This Week'
        : 'Upcoming';
  }

  Future<void> _pickSkill() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            for (final skill in _skills)
              ListTile(
                leading: const Icon(Icons.terminal,
                    color: AppColors.primary, size: 20),
                title: Text(
                  skill,
                  style: _bodyMd.copyWith(fontWeight: FontWeight.w500),
                ),
                trailing: skill == _selectedSkill
                    ? const Icon(Icons.check,
                        color: AppColors.primary, size: 20)
                    : null,
                onTap: () => Navigator.pop(sheetContext, skill),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => _selectedSkill = selected);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  surface: AppColors.surface,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_submitState != _SubmitState.idle) return;
    setState(() => _submitState = _SubmitState.sending);

    // TODO: replace with the real request (Firestore / API).
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitState = _SubmitState.sent);

    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    setState(() => _submitState = _SubmitState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                _margin,
                padding.top + _headerHeight,
                _margin,
                24 + padding.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      _buildTutorCard(),
                      _buildBookingForm(),
                      _buildPointsSummary(),
                      _buildPreviewScenario(),
                      _buildActionArea(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: _Header()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tutor summary card
  // ---------------------------------------------------------------------------
  Widget _buildTutorCard() {
    return _SurfaceCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _TutorAvatar(imageUrl: _tutorImage),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Marcus Vance',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _titleMd,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("CS '25",
                              style: _labelMd.copyWith(color: _textMuted)),
                          Text('•',
                              style: _labelMd.copyWith(
                                  color: AppColors.textSecondary)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_border,
                                  size: 14, color: _accentDark),
                              const SizedBox(width: 2),
                              Text('4.9',
                                  style: _labelMd.copyWith(color: _accentDark)),
                            ],
                          ),
                          Text('(34 reviews)',
                              style: _labelMd.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _accentFixed.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.token_outlined, size: 16, color: _accentDark),
                const SizedBox(width: 4),
                Text('10 pts/hr',
                    style: _labelLg.copyWith(color: _onAccentFixed)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Booking form card
  // ---------------------------------------------------------------------------
  Widget _buildBookingForm() {
    final noteFocused = _noteFocus.hasFocus;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          // Skill or Topic
          _FormSection(
            icon: Icons.school_outlined,
            title: 'Skill or Topic',
            child: _FieldBox(
              leadingIcon: Icons.terminal,
              text: _selectedSkill,
              onTap: _pickSkill,
              trailing:
                  const Icon(Icons.expand_more, size: 20, color: _textMuted),
            ),
          ),

          // Proposed Date
          _FormSection(
            icon: Icons.calendar_today_outlined,
            title: 'Proposed Date',
            child: _FieldBox(
              leadingIcon: Icons.event_available_outlined,
              text: _dateText,
              onTap: _pickDate,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(_dateBadge,
                    style: _labelSm.copyWith(color: AppColors.primary)),
              ),
            ),
          ),

          // Time slots
          _FormSection(
            icon: Icons.schedule_outlined,
            title: 'Available Time Slots',
            trailing: Text('EDT (Campus Time)',
                style: _labelSm.copyWith(color: AppColors.textSecondary)),
            child: Row(
              children: [
                for (int i = 0; i < _slots.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: _TimeSlotChip(
                      slot: _slots[i],
                      selected: i == _selectedSlot,
                      onTap: () => setState(() => _selectedSlot = i),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Duration
          _FormSection(
            icon: Icons.timelapse_outlined,
            title: 'Session Duration',
            trailing: Text(
              'Rate: 10 pts = 1 hr',
              style: _labelSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < _durations.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    Expanded(
                      child: _DurationButton(
                        option: _durations[i],
                        selected: i == _selectedDuration,
                        onTap: () => setState(() => _selectedDuration = i),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Note
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LabelRow(
                icon: Icons.chat_bubble_outline,
                title: 'What do you need help with?',
                trailing: Text('Optional',
                    style: _labelSm.copyWith(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _noteController,
                focusNode: _noteFocus,
                onChanged: (_) => setState(() {}),
                maxLines: 3,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: _bodyMd,
                decoration: InputDecoration(
                  hintText:
                      'e.g., Working on recursive functions for Homework 3, need help understanding the base cases...',
                  hintStyle: _bodyMd.copyWith(color: AppColors.textHint),
                  counterText: '',
                  filled: true,
                  fillColor: noteFocused
                      ? Color.alphaBlend(
                          AppColors.primary.withValues(alpha: 0.06),
                          AppColors.surfaceLight,
                        )
                      : AppColors.surfaceLight,
                  contentPadding: const EdgeInsets.all(16),
                  border: _noBorder,
                  enabledBorder: _noBorder,
                  focusedBorder: _noBorder,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_noteController.text.length}/200',
                    style: _labelSm.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final OutlineInputBorder _noBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );

  // ---------------------------------------------------------------------------
  // Points summary card
  // ---------------------------------------------------------------------------
  Widget _buildPointsSummary() {
    final duration = _durations[_selectedDuration];

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text('Points Summary',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _titleMd),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _BalancePill(low: _simulateLowBalance),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                _SummaryRow(
                  label: 'Session Duration (${duration.label})',
                  value: '${duration.points} points',
                  valueWeight: FontWeight.w600,
                ),
                const _SummaryRow(
                  label: 'Your Current Balance',
                  value: '$_currentBalance points',
                  valueWeight: FontWeight.w500,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(height: 1, color: AppColors.divider),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Balance After Session', style: _labelLg),
                    Text(
                      '${_currentBalance - duration.points} points',
                      style: _labelLg.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Preview scenario card
  // ---------------------------------------------------------------------------
  Widget _buildPreviewScenario() {
    final low = _simulateLowBalance;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: _accentDark),
                  const SizedBox(width: 4),
                  Text('Preview Scenario',
                      style: _labelMd.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _simulateLowBalance = !low),
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      low ? 'Reset Preview' : 'Simulate Low Balance',
                      style: _labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(low ? Icons.refresh : Icons.swap_horiz,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: low ? _errorLight : _accentFixed.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    low ? Icons.error_outline : Icons.warning_amber_outlined,
                    size: 20,
                    color: low ? AppColors.error : _accentDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        low ? 'Low Balance Alert' : 'Low Balance Tip',
                        style: _labelLg.copyWith(
                          color: low ? AppColors.error : _onAccentFixed,
                        ),
                      ),
                      Text(
                        low
                            ? 'Simulated balance too low (4 pts). Host a 30m peer study session or verify peer homework to unlock points instantly!'
                            : 'If your balance drops below the required points, you can teach a peer session first to earn campus swap credits.',
                        style: _bodyMd.copyWith(
                          height: 1.25,
                          color: low ? _textMuted : _onAccentFixedVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom action area
  // ---------------------------------------------------------------------------
  Widget _buildActionArea() {
    final Widget? leading;
    final Widget? trailing;
    final String label;
    final Color color;

    switch (_submitState) {
      case _SubmitState.idle:
        leading = null;
        trailing = const Icon(Icons.arrow_forward, size: 18);
        label = 'Send Request ($_points Points)';
        color = AppColors.primary;
        break;
      case _SubmitState.sending:
        leading = const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
        trailing = null;
        label = 'Reserving Time Slot...';
        color = AppColors.primary;
        break;
      case _SubmitState.sent:
        leading = const Icon(Icons.check, size: 18);
        trailing = null;
        label = 'Request Sent to Marcus!';
        color = AppColors.primaryDark;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        spacing: 8,
        children: [
          _PrimaryButton(
            label: label,
            leading: leading,
            trailing: trailing,
            color: color,
            // With a (simulated) low balance the request can't be sent.
            onPressed: _simulateLowBalance ? null : _submit,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_reset,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Points are held in escrow and only deducted after session completion.',
                    textAlign: TextAlign.center,
                    style: _labelSm.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Private building blocks
// =============================================================================

/// Fixed top bar: 64dp, translucent surface + blur, soft shadow.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Material(
            color: AppColors.background.withValues(alpha: 0.8),
            child: Padding(
              padding: EdgeInsets.only(top: top),
              child: SizedBox(
                height: _headerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Navigator.maybePop(context),
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(Icons.arrow_back,
                                    size: 24, color: AppColors.textPrimary),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Request Session',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: _headlineMd,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White card: 12px radius, 16px padding, shadow-sm, no border.
class _SurfaceCard extends StatelessWidget {
  final Widget child;
  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _TutorAvatar extends StatelessWidget {
  final String imageUrl;
  const _TutorAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: AppColors.surfaceLight,
                child: const Icon(Icons.person,
                    size: 28, color: AppColors.primary),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.surface, spreadRadius: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const _LabelRow({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(title, style: _labelLg.copyWith(color: _textMuted)),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget child;

  const _FormSection({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        _LabelRow(icon: icon, title: title, trailing: trailing),
        child,
      ],
    );
  }
}

/// 48dp tinted field with leading icon, text and a trailing widget.
class _FieldBox extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final Widget trailing;
  final VoidCallback? onTap;

  const _FieldBox({
    required this.leadingIcon,
    required this.text,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(leadingIcon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _bodyMd.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final _TimeSlot slot;
  final bool selected;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return _PressScale(
      scale: 0.95,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: selected
              ? const [
                  // ring-2 ring-primary ring-offset-1
                  BoxShadow(color: AppColors.primary, spreadRadius: 3),
                  BoxShadow(color: AppColors.surface, spreadRadius: 1),
                  // shadow-sm
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: selected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slot.time,
                    style: _labelMd.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? Colors.white : _textMuted,
                    ),
                  ),
                  Text(
                    slot.place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 16 / 10,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? AppColors.primaryLight
                          : _textMuted.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final _DurationOption option;
  final bool selected;
  final VoidCallback onTap;

  const _DurationButton({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);
    final weight = selected ? FontWeight.w700 : FontWeight.w500;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: selected ? AppColors.surface : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.label,
                  style: _labelMd.copyWith(
                    fontWeight: weight,
                    color: selected ? AppColors.primary : _textMuted,
                  ),
                ),
                Text(
                  '${option.points} pts',
                  style: TextStyle(
                    fontSize: 10,
                    height: 16 / 10,
                    fontWeight: weight,
                    color: selected
                        ? AppColors.primary
                        : _textMuted.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  final bool low;
  const _BalancePill({required this.low});

  @override
  Widget build(BuildContext context) {
    final color = low ? AppColors.error : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: low ? _errorLight : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            low ? Icons.warning_amber_outlined : Icons.check_circle_outline,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            low ? 'Low Balance' : 'Sufficient balance',
            style: _labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final FontWeight valueWeight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label, style: _bodyMd.copyWith(color: _textMuted)),
        ),
        const SizedBox(width: 8),
        Text(value, style: _bodyMd.copyWith(fontWeight: valueWeight)),
      ],
    );
  }
}

/// Full-width 48dp button, 12px radius, shadow-md, press-scale 0.99.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final Color color;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);

    return _PressScale(
      scale: 0.99,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: onPressed == null
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: -1,
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textHint,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _labelLg.copyWith(
                    color: onPressed == null
                        ? AppColors.textHint
                        : Colors.white,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Scales the child down while pressed (`active:scale-*` in the design).
class _PressScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const _PressScale({required this.child, required this.scale});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}