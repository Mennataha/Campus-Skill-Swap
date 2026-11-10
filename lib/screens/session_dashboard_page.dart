import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

// -----------------------------------------------------------------------------
// Design tokens that are not part of AppColors (kept local to this page).
// The "container" tints are derived from your own palette.
// -----------------------------------------------------------------------------
const Color _textMuted = Color(0xFF3D4947); // on-surface-variant
const Color _accentDark = Color(0xFF825100); // tertiary
const Color _accentFixed = Color(0xFFFFDDB8); // tertiary-fixed
const Color _onAccentFixed = Color(0xFF2A1700); // on-tertiary-fixed
const Color _onAccentFixedVariant = Color(0xFF653E00);

final Color _surfaceContainer = Color.alphaBlend(
  AppColors.primary.withValues(alpha: 0.06),
  AppColors.surfaceLight,
);

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
const double _navHeight = 64;
const double _gutter = 16;

// Tailwind shadow-sm
const List<BoxShadow> _shadowSm = [
  BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
];

enum _SessionTab { upcoming, pending, past }

class SessionsDashboardPage extends StatefulWidget {
  const SessionsDashboardPage({super.key});

  @override
  State<SessionsDashboardPage> createState() => _SessionsDashboardPageState();
}

class _SessionsDashboardPageState extends State<SessionsDashboardPage> {
  static const String _mayaImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCoeRcz4XWZyASuOSxPKzIAwJCxd33kuVc-zGPxpxZNxBhMwLquQiFHc6TUSKwj5TSSkwnMdaBokzQslKRgA0oUTkVUN9Q2hX4rtacWJQ3bNhtjuW-yl31r2yPYsNDu69Rs3OuWhgI6TDYhNKehMwnH4qMUyad6gOTt2cZB2zq1ssEQlOUSkP8eJitnQx56hoAtUcl4shHUt-i3dCd8hk3c_3cxSntlQTWZshi71TIKBGgjKYZCcC31Yw';
  static const String _alexImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAXZetKvEYWYB7tNCVZzXCtvGoriq7bNjwv7QThlcao8AgQ_UcFXb8LtsTNnHsPf020vJnAD_B125Mq5ex6G0246x8fV2L7SmGb3B-1mPeWp22B83JikJvuDrB38OfE6IUPpRXtY69C24AZWR1Xh8PnrTdYxCPFjVNHvBMhxF6omHg0b8etxZufW0TokpuFUpKN2nHfuq84w9XM1-wSwfbMoj0KML2raQSi4BzMN8iHDkQTfZCZwwGgMA';
  static const String _marcusImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAsOQvPuBMDdmc6XggtB9XZIUDEVpvrdCxFxmbBMWynlfraGu4RJyR7XKcqWA1vq1DeDA_9o1eTU8ZWb7XVL3waEqoJn7NhjMe6-maHVHTMygZAIZoJbcz5gelv-acQTiwO_bHVXzza2988oUoXrdsC2SH7zHhNjXKPqu4U4iFklG_KIGIRbA0lOREE5wxeSQ-RS11_XqAAcmLhdvII6Hf6lsojtQ9IDw1lz6UFtpZLLXER0Fom3W87QA';

  _SessionTab _tab = _SessionTab.upcoming;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: padding.top + _headerHeight,
                bottom: 96 + padding.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _gutter),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        _buildTabs(),
                        if (_tab == _SessionTab.upcoming) _buildUpcoming(),
                        if (_tab == _SessionTab.pending) _buildPending(),
                        if (_tab == _SessionTab.past) _buildPast(),
                        _buildPlayground(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: _Header()),
          const Positioned(bottom: 0, left: 0, right: 0, child: _BottomNav()),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Segmented tabs
  // ---------------------------------------------------------------------------
  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _shadowSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Upcoming',
              badge: '2',
              badgeColor: AppColors.primary,
              badgeTextColor: Colors.white,
              selected: _tab == _SessionTab.upcoming,
              onTap: () => setState(() => _tab = _SessionTab.upcoming),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Pending',
              badge: '1',
              badgeColor: _accentFixed,
              badgeTextColor: _onAccentFixed,
              selected: _tab == _SessionTab.pending,
              onTap: () => setState(() => _tab = _SessionTab.pending),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Past',
              selected: _tab == _SessionTab.past,
              onTap: () => setState(() => _tab = _SessionTab.past),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Upcoming view
  // ---------------------------------------------------------------------------
  Widget _buildUpcoming() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        // Next session alert spotlight
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _shadowSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: _shadowSm,
                      ),
                      child: const Icon(Icons.videocam_outlined,
                          size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your calculus meetup is ready',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _labelMd.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Starts in 18 hours • Link generated',
                            style: _bodyMd.copyWith(color: _textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _PressScale(
                scale: 0.95,
                child: _InkBox(
                  color: AppColors.primary,
                  radius: BorderRadius.circular(9999),
                  shadows: _shadowSm,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  // TODO: open the meeting link.
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Join',
                          style: _labelMd.copyWith(color: Colors.white)),
                      const SizedBox(width: 4),
                      const Icon(Icons.open_in_new,
                          size: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Card 1: Maya Lin (learning)
        _SessionCard(
          name: 'Maya Lin',
          subtitle: 'Calculus I • Derivatives & Integrals',
          imageUrl: _mayaImage,
          dotColor: AppColors.primary,
          statusPill: const _Pill(
            color: AppColors.primaryLight,
            textColor: AppColors.primary,
            icon: Icons.check_circle_outline,
            iconSize: 14,
            text: 'Accepted',
            semibold: true,
            gap: 4,
          ),
          badges: [
            _Pill(
              color: AppColors.surfaceLight,
              textColor: AppColors.primary,
              icon: Icons.school_outlined,
              iconSize: 16,
              text: 'You are learning',
              gap: 6,
            ),
            const _Pill(
              color: _accentFixed,
              textColor: _onAccentFixed,
              icon: Icons.token_outlined,
              iconColor: _accentDark,
              iconSize: 14,
              text: '15 Swap Pts',
              gap: 4,
            ),
          ],
          infoBlock: const _InfoBlock(
            color: AppColors.surfaceLight,
            rows: [
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.primary,
                text: 'Tomorrow, Oct 24 • 3:30 PM - 4:30 PM',
                primary: true,
              ),
              _InfoRow(
                icon: Icons.videocam_outlined,
                iconColor: AppColors.primary,
                text: 'Google Meet ready (link unlocks automatically)',
                truncate: true,
              ),
            ],
          ),
          actions: Row(
            spacing: 8,
            children: [
              Expanded(
                child: _CardButton(
                  label: 'View Details',
                  color: _surfaceContainer,
                  textColor: AppColors.textPrimary,
                  // TODO: open Session Details page.
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _CardButton(
                  label: 'Join Meet',
                  icon: Icons.video_call_outlined,
                  color: AppColors.primary,
                  textColor: Colors.white,
                  // TODO: open the meeting link.
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),

        // Card 2: Alex Chen (teaching)
        _SessionCard(
          name: 'Alex Chen',
          subtitle: 'UI Design & Figma Masterclass',
          imageUrl: _alexImage,
          dotColor: AppColors.primary,
          statusPill: const _Pill(
            color: AppColors.primaryLight,
            textColor: AppColors.primary,
            icon: Icons.check_circle_outline,
            iconSize: 14,
            text: 'Accepted',
            semibold: true,
            gap: 4,
          ),
          badges: [
            _Pill(
              color: _surfaceContainer,
              textColor: AppColors.primary,
              icon: Icons.co_present_outlined,
              iconSize: 16,
              text: 'You are teaching',
              gap: 6,
            ),
            const _Pill(
              color: _accentFixed,
              textColor: _onAccentFixed,
              icon: Icons.add_circle_outline,
              iconColor: _accentDark,
              iconSize: 14,
              text: 'Earn +20 Pts',
              gap: 4,
            ),
          ],
          infoBlock: const _InfoBlock(
            color: AppColors.surfaceLight,
            rows: [
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.primary,
                text: 'Friday, Oct 25 • 2:00 PM - 3:00 PM',
                primary: true,
              ),
              _InfoRow(
                icon: Icons.place_outlined,
                iconColor: AppColors.primary,
                text: 'Library Floor 3 • Study Room 304',
                truncate: true,
              ),
            ],
          ),
          actions: _CardButton(
            label: 'View Session & Prep Notes',
            trailingIcon: Icons.arrow_forward,
            color: _surfaceContainer,
            textColor: AppColors.textPrimary,
            horizontalPadding: 16,
            // TODO: open the session + prep notes.
            onTap: () {},
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Pending view
  // ---------------------------------------------------------------------------
  Widget _buildPending() {
    return _SessionCard(
      name: 'Marcus Vance',
      subtitle: 'Python & Data Structures',
      imageUrl: _marcusImage,
      dotColor: AppColors.accent,
      statusPill: const _Pill(
        color: _accentFixed,
        textColor: _onAccentFixed,
        icon: Icons.hourglass_top_outlined,
        iconSize: 14,
        text: 'Pending',
        semibold: true,
        gap: 4,
      ),
      badges: [
        _Pill(
          color: AppColors.surfaceLight,
          textColor: AppColors.primary,
          icon: Icons.school_outlined,
          iconSize: 16,
          text: 'You are learning',
          gap: 6,
        ),
        _Pill(
          color: _surfaceContainer,
          textColor: _textMuted,
          icon: Icons.schedule_outlined,
          iconSize: 14,
          text: 'Requested 2h ago',
          gap: 4,
        ),
      ],
      infoBlock: _InfoBlock(
        color: _accentFixed.withValues(alpha: 0.3),
        rows: const [
          _InfoRow(
            icon: Icons.event_outlined,
            iconColor: _accentDark,
            text: 'Saturday, Oct 26 • 11:00 AM',
            primary: true,
          ),
          _InfoRow(
            icon: Icons.info_outline,
            iconColor: _accentDark,
            text: 'Waiting for tutor confirmation',
            textColor: _onAccentFixedVariant,
          ),
        ],
      ),
      actions: Row(
        spacing: 8,
        children: [
          Expanded(
            child: _CardButton(
              label: 'Cancel Request',
              color: _surfaceContainer,
              textColor: AppColors.textPrimary,
              small: true,
              // TODO: cancel the pending request.
              onTap: () {},
            ),
          ),
          Expanded(
            child: _CardButton(
              label: 'Message Tutor',
              color: AppColors.primary,
              textColor: Colors.white,
              small: true,
              // TODO: open chat with the tutor.
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Past view (empty state)
  // ---------------------------------------------------------------------------
  Widget _buildPast() {
    return _SurfaceCard(
      padding: 32,
      child: Column(
        spacing: 8,
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: _surfaceContainer,
              shape: BoxShape.circle,
              boxShadow: _shadowSm,
            ),
            child: const Icon(Icons.history_edu_outlined,
                size: 40, color: AppColors.primary),
          ),
          Text('No past sessions yet', style: _headlineMd),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              'Once you complete study sessions with your campus peers, your session notes and reviews will appear right here.',
              textAlign: TextAlign.center,
              style: _bodyMd.copyWith(color: _textMuted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: _PressScale(
                scale: 0.95,
                child: _InkBox(
                  color: AppColors.primary,
                  radius: BorderRadius.circular(12),
                  shadows: _shadowSm,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // TODO: navigate to Find Tutors.
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Find a Tutor',
                          style: _labelLg.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty tab playground
  // ---------------------------------------------------------------------------
  Widget _buildPlayground() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.preview_outlined,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text('Empty Tab Playground',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _labelLg),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _surfaceContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text('Interactive Preview',
                      style: _labelSm.copyWith(color: _textMuted)),
                ),
              ],
            ),
            Text(
              'Switch tabs above to test full dashboard cards or preview empty state messaging for zero-state scenarios.',
              style: _bodyMd.copyWith(color: _textMuted),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _shadowSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_outlined,
                        size: 24, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need tutoring in a new subject?',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _labelMd.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Explore peer mentors ready to swap skills.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _bodyMd.copyWith(color: _textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _PressScale(
                    scale: 0.95,
                    child: _InkBox(
                      color: AppColors.primary,
                      radius: BorderRadius.circular(8),
                      shadows: _shadowSm,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      // TODO: navigate to Find Tutors.
                      onTap: () {},
                      child: Text('Browse',
                          style: _labelSm.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: _gutter),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Sessions Dashboard',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _headlineMd.copyWith(letterSpacing: -0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accentFixed,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.token_outlined,
                                    size: 16, color: _accentDark),
                                const SizedBox(width: 6),
                                Text('30 pts',
                                    style: _labelMd.copyWith(
                                        color: _onAccentFixed)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // TODO: open notifications.
                          InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {},
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(Icons.notifications_outlined,
                                  size: 22, color: _textMuted),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                        ],
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

/// Fixed bottom navigation: 64dp, translucent surface + blur.
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, -1),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Material(
            color: AppColors.background.withValues(alpha: 0.85),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: const SizedBox(
                height: _navHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      // TODO: wire these to your navigation.
                      _NavItem(
                          icon: Icons.home_outlined, label: 'Home'),
                      _NavItem(icon: Icons.search, label: 'Find Tutors'),
                      _NavItem(
                        icon: Icons.event_available_outlined,
                        label: 'Sessions',
                        active: true,
                      ),
                      _NavItem(
                        icon: Icons.account_circle_outlined,
                        label: 'Profile',
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : _textMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 2),
                Text(label, style: _labelSm.copyWith(color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// White card: 12px radius, shadow-sm, no border.
class _SurfaceCard extends StatelessWidget {
  final Widget child;
  final double padding;
  const _SurfaceCard({required this.child, this.padding = 16});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _shadowSm,
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}

/// One session card (header + badges + info block + actions).
class _SessionCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;
  final Color dotColor;
  final Widget statusPill;
  final List<Widget> badges;
  final Widget infoBlock;
  final Widget actions;

  const _SessionCard({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.dotColor,
    required this.statusPill,
    required this.badges,
    required this.infoBlock,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: _shadowSm,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 48,
                                  height: 48,
                                  color: AppColors.surfaceLight,
                                  child: const Icon(Icons.person,
                                      size: 24, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -4,
                            bottom: -4,
                            child: Container(
                              width: 16,
                              height: 16,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _titleMd),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _bodyMd.copyWith(color: _textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              statusPill,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: badges,
            ),
          ),
          infoBlock,
          Padding(padding: const EdgeInsets.only(top: 8), child: actions),
        ],
      ),
    );
  }
}

/// Capsule: icon + label (status, meta badges).
class _Pill extends StatelessWidget {
  final Color color;
  final Color textColor;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final String text;
  final bool semibold;
  final double gap;

  const _Pill({
    required this.color,
    required this.textColor,
    required this.icon,
    required this.iconSize,
    required this.text,
    required this.gap,
    this.iconColor,
    this.semibold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? textColor),
          SizedBox(width: gap),
          Text(
            text,
            style: _labelSm.copyWith(
              color: textColor,
              fontWeight: semibold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tinted block holding the time / location rows.
class _InfoBlock extends StatelessWidget {
  final Color color;
  final List<Widget> rows;
  const _InfoBlock({required this.color, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: rows,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  /// First row style (label-md, on-surface) vs. secondary row (body-md, muted).
  final bool primary;
  final bool truncate;
  final Color? textColor;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.primary = false,
    this.truncate = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = primary
        ? _labelMd.copyWith(color: AppColors.textPrimary)
        : _bodyMd.copyWith(color: textColor ?? _textMuted);

    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: truncate ? 1 : null,
            overflow: truncate ? TextOverflow.ellipsis : TextOverflow.clip,
            style: style,
          ),
        ),
      ],
    );
  }
}

/// Card action button (active:scale-[0.98], shadow-sm, 8px radius).
class _CardButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final Color color;
  final Color textColor;
  final bool small;
  final double horizontalPadding;
  final VoidCallback? onTap;

  const _CardButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.horizontalPadding = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      scale: 0.98,
      child: _InkBox(
        color: color,
        radius: BorderRadius.circular(8),
        shadows: _shadowSm,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: small ? 8 : 10,
        ),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: (small ? _labelMd : _labelLg).copyWith(color: textColor),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: 18, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? AppColors.surface : Colors.transparent,
        borderRadius: radius,
        boxShadow: selected ? _shadowSm : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _labelMd.copyWith(
                      color: selected ? AppColors.primary : _textMuted,
                    ),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(badge!,
                        style: _labelSm.copyWith(color: badgeTextColor)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tappable filled box (buttons, chips) that keeps its ink visible.
class _InkBox extends StatelessWidget {
  final Color color;
  final BorderRadius radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? shadows;
  final Widget child;

  const _InkBox({
    required this.color,
    required this.radius,
    required this.child,
    this.onTap,
    this.padding,
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
            padding: padding,
            alignment: Alignment.center,
            child: child,
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