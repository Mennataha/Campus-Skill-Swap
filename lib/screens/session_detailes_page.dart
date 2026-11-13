import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

// -----------------------------------------------------------------------------
// Design tokens that are not part of AppColors (kept local to this page).
// The "container" tints are derived from your own palette.
// -----------------------------------------------------------------------------
const Color _textMuted = Color(0xFF3D4947); // on-surface-variant
const Color _accentContainer = Color(0xFFA36700); // tertiary-container
const Color _onAccentFixed = Color(0xFF2A1700); // on-tertiary-fixed
const Color _inverseSurface = Color(0xFF213145);
const Color _inverseOnSurface = Color(0xFFEAF1FF);

final Color _surfaceContainer = Color.alphaBlend(
  AppColors.primary.withValues(alpha: 0.06),
  AppColors.surfaceLight,
);
final Color _surfaceContainerHigh = Color.alphaBlend(
  AppColors.primary.withValues(alpha: 0.12),
  AppColors.surfaceLight,
);

// Text styles built on top of AppTextStyles (size / weight / line-height from the design)
final TextStyle _titleMd =
    AppTextStyles.heading3.copyWith(fontSize: 16, height: 24 / 16);
final TextStyle _headlineMd =
    AppTextStyles.heading3.copyWith(fontSize: 20, height: 28 / 20);
final TextStyle _bodyMd = AppTextStyles.bodyMedium.copyWith(height: 20 / 14);
final TextStyle _labelLg =
    AppTextStyles.label.copyWith(fontSize: 14, height: 20 / 14);
final TextStyle _labelMd = AppTextStyles.label
    .copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12);
final TextStyle _labelSm = AppTextStyles.caption
    .copyWith(fontSize: 11, fontWeight: FontWeight.w500, height: 14 / 11);

const double _headerHeight = 64;
const double _margin = 16;

// Tailwind shadow-sm / shadow-xs
const List<BoxShadow> _shadowSm = [
  BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
];

class SessionDetailsPage extends StatefulWidget {
  const SessionDetailsPage({super.key});

  @override
  State<SessionDetailsPage> createState() => _SessionDetailsPageState();
}

class _SessionDetailsPageState extends State<SessionDetailsPage> {
  static const String _tutorImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAAOPXAv1uWGAmt5n71z8147MGLbBH1v38Ci6gjrqMuGGYPI1y2ws3RqTsKn_-EcBxddmVVPxk3Wv6b0s_0tyvvtlZHvm__BpJx50aaZNR3BEaR2AEOUYz24HFxKMCbOcU50kel4Aen_txqa1z1ZzEbhsoFZueUUFKTddQu3hN6OgB5RdzCxGBevyHA0-iLT2_6KWdlOEMgaNQB_NtStFewse19td7LQEtEaIm76Evj9kl618NJNQFQPw';

  String _meetingUrl = 'meet.google.com/qxy-wzrt-kmp';
  bool _copied = false;
  bool _editingLink = false;

  final TextEditingController _urlController =
      TextEditingController(text: 'https://meet.google.com/qxy-wzrt-kmp');

  // Toast
  bool _toastVisible = false;
  String _toastMessage = 'Action completed successfully.';
  IconData _toastIcon = Icons.check_circle_outline;
  Timer? _toastTimer;
  Timer? _copiedTimer;

  @override
  void dispose() {
    _urlController.dispose();
    _toastTimer?.cancel();
    _copiedTimer?.cancel();
    super.dispose();
  }

  void _showToast(String message, [IconData icon = Icons.check_circle_outline]) {
    _toastTimer?.cancel();
    setState(() {
      _toastMessage = message;
      _toastIcon = icon;
      _toastVisible = true;
    });
    _toastTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _meetingUrl));
    if (!mounted) return;
    setState(() => _copied = true);
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
    _showToast('Meeting link copied to clipboard!', Icons.content_copy_outlined);
  }

  void _toggleEdit() => setState(() => _editingLink = !_editingLink);

  void _saveLink() {
    final value = _urlController.text.trim();
    if (value.isEmpty) return;
    // TODO: persist the new link (Firestore / API).
    setState(() {
      _meetingUrl = value.replaceFirst(RegExp(r'^https?://'), '');
      _editingLink = false;
    });
    _showToast('Meeting link updated for this session!');
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          'Are you sure you want to cancel this tutoring session with Maya? Your 10 points will remain in your wallet.',
          style: _bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Keep Session',
                style: _labelLg.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Cancel Session',
                style: _labelLg.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: cancel the booking + refund escrow points.
      _showToast('Session cancelled. 10 escrow points restored.',
          Icons.cancel_outlined);
    }
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
              padding: EdgeInsets.only(
                top: padding.top + _headerHeight,
                bottom: 40 + padding.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(_margin, 16, _margin, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        _buildStatusBanner(),
                        _buildTutorRow(),
                        _buildMeetingCard(),
                        _buildDetailsCard(),
                        _buildManageCard(),
                        _buildHonorCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: _Header()),
          Positioned(
            left: _margin,
            right: _margin,
            bottom: 24 + padding.bottom,
            child: _Toast(
              visible: _toastVisible,
              message: _toastMessage,
              icon: _toastIcon,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status banner
  // ---------------------------------------------------------------------------
  Widget _buildStatusBanner() {
    final onBanner = AppColors.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _shadowSm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: AppColors.primaryLight,
          child: Stack(
            children: [
              // Subtle organic background decor
              Positioned(
                right: -16,
                bottom: -24,
                child: Opacity(
                  opacity: 0.15,
                  child: SizedBox(
                    width: 112,
                    height: 112,
                    child: Center(
                      child: Container(
                        width: 107.5,
                        height: 107.5,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: _shadowSm,
                      ),
                      child: const Icon(Icons.check_circle,
                          size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'STATUS CONFIRMED',
                                  style: _labelMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const _PulseDot(),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Session Confirmed',
                            style: _headlineMd.copyWith(
                              height: 1.25,
                              color: onBanner,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 16,
                                  color: onBanner.withValues(alpha: 0.8)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Tomorrow, Oct 24 • 3:30 PM EDT',
                                  style: _labelMd.copyWith(
                                    color: onBanner.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Peer tutor profile row
  // ---------------------------------------------------------------------------
  Widget _buildTutorRow() {
    return _SurfaceCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: ClipOval(
                    child: ColoredBox(
                      color: _surfaceContainer,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              _tutorImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                size: 28,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: _shadowSm,
                              ),
                              child: const Icon(Icons.verified,
                                  size: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Maya Lin',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _titleMd),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.school,
                                    size: 11, color: AppColors.primary),
                                const SizedBox(width: 2),
                                Text('Peer Tutor',
                                    style: _labelSm.copyWith(
                                        color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Stanford '25 • Math & CS Major",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _bodyMd.copyWith(color: _textMuted),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: AppColors.accent),
                              const SizedBox(width: 2),
                              Text('4.9',
                                  style: _labelSm.copyWith(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 2),
                              Text('(34 reviews)',
                                  style: _labelSm.copyWith(color: _textMuted)),
                            ],
                          ),
                          Text('•',
                              style: _labelSm.copyWith(
                                  color: AppColors.textHint)),
                          Text('Top 5% Tutor',
                              style:
                                  _labelSm.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // TODO: open chat with the tutor.
          _InkBox(
            color: _surfaceContainer,
            radius: BorderRadius.circular(9999),
            onTap: () {},
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.chat_outlined,
                  size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Meeting link card
  // ---------------------------------------------------------------------------
  Widget _buildMeetingCard() {
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
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.videocam_outlined,
                        size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Google Meet Video', style: _titleMd),
                      Text('Online Session Space',
                          style: _labelSm.copyWith(color: _textMuted)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text('Ready',
                    style: _labelSm.copyWith(color: AppColors.primary)),
              ),
            ],
          ),

          // Meeting URL preview
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.link, size: 16, color: _textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _meetingUrl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _bodyMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _InkBox(
                  color: _surfaceContainer,
                  radius: BorderRadius.circular(4),
                  onTap: _copyLink,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.content_copy_outlined,
                          size: 14, color: AppColors.textPrimary),
                      const SizedBox(width: 4),
                      Text(_copied ? 'Copied!' : 'Copy', style: _labelSm),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              const Icon(Icons.verified_user,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Link verified by tutor Maya Lin 2 hours ago',
                  style: _labelSm.copyWith(color: _textMuted),
                ),
              ),
            ],
          ),

          // Join button
          _PressScale(
            scale: 0.99,
            child: _InkBox(
              color: AppColors.primary,
              radius: BorderRadius.circular(12),
              shadows: _shadowSm,
              height: 48,
              // TODO: open the meeting URL (url_launcher).
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.video_call_outlined,
                      size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Join Meeting Room',
                      style: _labelLg.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Session details card
  // ---------------------------------------------------------------------------
  Widget _buildDetailsCard() {
    final tileLabel = _labelSm.copyWith(color: _textMuted, letterSpacing: 0.55);

    Widget chip(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _surfaceContainer,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(text, style: _labelSm.copyWith(color: _textMuted)),
        );

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session Details', style: _titleMd),
              Text('ID: #SKL-9402',
                  style: _labelSm.copyWith(color: _textMuted)),
            ],
          ),

          // Grid (2 columns, gap 8)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              // Topic tile (spans 2 columns)
              _Tile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COURSE & SUBJECT', style: tileLabel),
                    const SizedBox(height: 2),
                    Text('Calculus I (Derivatives & Integrals)',
                        style: _titleMd),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        chip('MATH 19'),
                        chip('Chain Rule'),
                        chip('Optimization'),
                      ],
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: _Tile(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DURATION', style: tileLabel),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Flexible(
                                    child: Text('60 minutes', style: _labelLg)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('1 credit hour',
                                style: _labelSm.copyWith(color: _textMuted)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: _Tile(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('POINTS IN ESCROW', style: tileLabel),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.monetization_on,
                                    size: 18, color: _accentContainer),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text('10 Points',
                                      style: _labelLg.copyWith(
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('Deducted upon wrap-up',
                                style: _labelSm.copyWith(color: _textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Student note
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sticky_note_2_outlined,
                        size: 16, color: _textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Your Study Goal Note',
                      style: _labelMd.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '“Need help reviewing chain rule homework and past midterm problems. Stuck on problem 4b parametric derivation.”',
                    style: _bodyMd.copyWith(
                      height: 1.625,
                      fontStyle: FontStyle.italic,
                      color: _textMuted,
                    ),
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
  // Manage booking card
  // ---------------------------------------------------------------------------
  Widget _buildManageCard() {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manage Booking', style: _titleMd),
                    Text(
                      'Contextual actions for peer session lifecycle',
                      style: _labelSm.copyWith(color: _textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text('Demo Actions',
                    style: _labelSm.copyWith(color: AppColors.primary)),
              ),
            ],
          ),

          // Tutor link controls
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_calendar_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Tutor Link Controls',
                            style: _labelLg.copyWith(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Text('Tutor Mode',
                        style: _labelSm.copyWith(
                            color: _textMuted, fontWeight: FontWeight.w400)),
                  ],
                ),
                Text(
                  'Need to update the room URL or switch to Zoom / Stanford Library study pod?',
                  style: _bodyMd.copyWith(color: _textMuted),
                ),
                if (_editingLink)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 8,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('New Meeting Room URL',
                                style: _labelSm.copyWith(
                                    color: _textMuted,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: _shadowSm,
                              ),
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _urlController,
                                  keyboardType: TextInputType.url,
                                  style: _bodyMd,
                                  decoration: InputDecoration(
                                    hintText: 'https://zoom.us/j/...',
                                    hintStyle: _bodyMd.copyWith(
                                        color: AppColors.textHint),
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.surface,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    border: _inputBorder(),
                                    enabledBorder: _inputBorder(),
                                    focusedBorder: _inputBorder(focused: true),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: _InkBox(
                                color: AppColors.primary,
                                radius: BorderRadius.circular(8),
                                height: 36,
                                onTap: _saveLink,
                                child: Text(
                                  'Save Room Link',
                                  style: _labelMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            _InkBox(
                              color: _surfaceContainer,
                              radius: BorderRadius.circular(8),
                              height: 36,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              onTap: _toggleEdit,
                              child: Text('Cancel', style: _labelMd),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  _InkBox(
                    color: _surfaceContainer,
                    radius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onTap: _toggleEdit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Add / Edit Meeting Link',
                            style: _labelMd.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Tutor response state preview
          _Tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'TUTOR RESPONSE STATE PREVIEW',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _labelSm.copyWith(
                          color: _textMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.275,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Simulate',
                        style: _labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: _PressScale(
                        scale: 0.95,
                        child: _InkBox(
                          color: AppColors.primary,
                          radius: BorderRadius.circular(9999),
                          height: 36,
                          onTap: () => _showToast(
                            'Tutor marked request accepted & lock updated!',
                            Icons.task_alt,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text('Accept Request',
                                  style: _labelMd.copyWith(
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _PressScale(
                        scale: 0.95,
                        child: _InkBox(
                          color: _surfaceContainer,
                          radius: BorderRadius.circular(9999),
                          height: 36,
                          onTap: () => _showToast(
                            'Session decline signal recorded for tutor.',
                            Icons.info_outline,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.close,
                                  size: 16, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text('Decline',
                                  style: _labelMd.copyWith(
                                      color: AppColors.error)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Post-session feedback
          _Tile(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Post-Session Feedback',
                          style: _labelLg.copyWith(
                              fontWeight: FontWeight.w600)),
                      Text('Available once meeting wraps up',
                          style: _labelSm.copyWith(color: _textMuted)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _InkBox(
                  color: AppColors.accent,
                  radius: BorderRadius.circular(8),
                  height: 36,
                  shadows: _shadowSm,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  onTap: () => _showToast(
                    'Rating modal will unlock immediately when call concludes.',
                    Icons.rate_review_outlined,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: _onAccentFixed),
                      const SizedBox(width: 6),
                      Text('Rate Session',
                          style: _labelMd.copyWith(
                            color: _onAccentFixed,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Cancel booking
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InkBox(
                  color: Colors.transparent,
                  radius: BorderRadius.circular(8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onTap: _confirmCancel,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cancel_outlined,
                          size: 18, color: AppColors.error),
                      const SizedBox(width: 6),
                      Text('Cancel Session Booking',
                          style: _labelMd.copyWith(color: AppColors.error)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Free cancellation up to 6 hours before start. Escrow refund is automatic.',
                  textAlign: TextAlign.center,
                  style: _labelSm.copyWith(color: _textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static OutlineInputBorder _inputBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: focused
          ? const BorderSide(color: AppColors.primary, width: 1)
          : BorderSide.none,
    );
  }

  // ---------------------------------------------------------------------------
  // Campus honor code card
  // ---------------------------------------------------------------------------
  Widget _buildHonorCard() {
    const tips = [
      'Peer tutors guide understanding; they cannot complete graded assignments on your behalf.',
      'Sessions are held in approved digital rooms or designated library quiet pods.',
      'Have lecture slides, syllabus questions, and problem sets open before joining.',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            children: [
              const Icon(Icons.local_library_outlined,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text('Campus Honor Code & Tips', style: _titleMd),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              for (final tip in tips)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.check,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(tip,
                          style: _bodyMd.copyWith(color: _textMuted)),
                    ),
                  ],
                ),
            ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                'Session Details',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: _titleMd,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.more_vert,
                              size: 22, color: _textMuted),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
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
        boxShadow: _shadowSm,
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

/// Tinted inner tile: low surface, 8px radius, 12px padding.
class _Tile extends StatelessWidget {
  final Widget child;
  const _Tile({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

/// Tappable filled box (buttons, chips) that keeps its ink visible.
class _InkBox extends StatelessWidget {
  final Color color;
  final BorderRadius radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final List<BoxShadow>? shadows;
  final Widget child;

  const _InkBox({
    required this.color,
    required this.radius,
    required this.child,
    this.onTap,
    this.padding,
    this.height,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: Material(
        color: color,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            height: height,
            padding: padding,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 6px dot that pulses (Tailwind `animate-pulse`).
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Bottom toast (inverse surface, slides up + fades in).
class _Toast extends StatelessWidget {
  final bool visible;
  final String message;
  final IconData icon;

  const _Toast({
    required this.visible,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 2.2),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 384),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _inverseSurface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 10),
                      blurRadius: 15,
                      spreadRadius: -3,
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 20, color: AppColors.primaryLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: _bodyMd.copyWith(color: _inverseOnSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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