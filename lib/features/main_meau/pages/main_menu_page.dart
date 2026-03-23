import 'dart:async';

import 'package:flutter/material.dart';

import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';

const _pageBackgroundTop = Color(0xFF14080D);
const _pageBackgroundBottom = Color(0xFF3A131C);
const _goldAccent = Color(0xFFE8C98D);

String _sectionCaption(String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return PyramidPokerStrings.get('mainMenuSectionStarterCaption');
    case 'gameLevelClassic':
      return PyramidPokerStrings.get('mainMenuSectionClassicCaption');
    default:
      return PyramidPokerStrings.get('mainMenuSectionChallengeCaption');
  }
}

/// 依據遊戲 key 回傳估算的遊玩時間字串（i18n key）
String _homeGameDurationLabel(String titleKey) {
  switch (titleKey) {
    case 'gameCompareTitle':
      // 比大小：規則最簡單，1 局約 3-5 分鐘
      return PyramidPokerStrings.get('gameCompareDuration');
    case 'gameHorseRaceTitle':
      // 賽馬：節奏快，1 局約 5-8 分鐘
      return PyramidPokerStrings.get('gameHorseRaceDuration');
    case 'gameTitle':
      // 金字塔撲克牌：流程較長，1 局約 10-15 分鐘
      return PyramidPokerStrings.get('gamePyramidDuration');
    case 'gameChallengeReservedTitle':
      // 預留挑戰模式，暫估 12-20 分鐘
      return PyramidPokerStrings.get('gameChallengeReservedDuration');
    default:
      return '';
  }
}

String _sectionSupportCopy(String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return PyramidPokerStrings.get('mainMenuSectionStarterSupport');
    case 'gameLevelClassic':
      return PyramidPokerStrings.get('mainMenuSectionClassicSupport');
    default:
      return PyramidPokerStrings.get('mainMenuSectionChallengeSupport');
  }
}

String _gameSummaryCopy(String titleKey) {
  switch (titleKey) {
    case 'gameCompareTitle':
      return PyramidPokerStrings.get('gameCompareSubtitle');
    case 'gameHorseRaceTitle':
      return PyramidPokerStrings.get('gameHorseRaceSubtitle');
    case 'gameTitle':
      return PyramidPokerStrings.get('gameTitleSubtitle');
    case 'gameChallengeReservedTitle':
      return PyramidPokerStrings.get('gameChallengeReservedSubtitle');
    default:
      return '';
  }
}

String _gameMetaCopy(String titleKey) {
  switch (titleKey) {
    case 'gameCompareTitle':
      return PyramidPokerStrings.get('gameCompareMeta');
    case 'gameHorseRaceTitle':
      return PyramidPokerStrings.get('gameHorseRaceMeta');
    case 'gameTitle':
      return PyramidPokerStrings.get('gameTitleMeta');
    default:
      return '';
  }
}

class _GameEntry {
  final String titleKey;
  final String playerCountKey;
  final bool featured;
  final VoidCallback? onTap;

  const _GameEntry({
    required this.titleKey,
    required this.playerCountKey,
    this.featured = false,
    this.onTap,
  });

  bool get isAvailable => onTap != null;
}

class _GameSection {
  final String levelKey;
  final List<_GameEntry> entries;

  const _GameSection({required this.levelKey, required this.entries});
}

class _SectionStyle {
  final Color accent;
  final Color tint;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color mutedText;

  const _SectionStyle({
    required this.accent,
    required this.tint,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.mutedText,
  });
}

_SectionStyle _styleForLevel(String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return const _SectionStyle(
        accent: Color(0xFFD6A66A),
        tint: Color(0xFF3A231A),
        surface: Color(0xFF241419),
        surfaceAlt: Color(0xFF2A1818),
        border: Color(0xFF8D6138),
        text: Color(0xFFF7EBD9),
        mutedText: Color(0xFFD3BEA1),
      );
    case 'gameLevelClassic':
      return const _SectionStyle(
        accent: Color(0xFFD88E7C),
        tint: Color(0xFF341922),
        surface: Color(0xFF26121A),
        surfaceAlt: Color(0xFF2D151F),
        border: Color(0xFF915A56),
        text: Color(0xFFF8E6E2),
        mutedText: Color(0xFFD8BCB8),
      );
    default:
      return const _SectionStyle(
        accent: Color(0xFFE8C98D),
        tint: Color(0xFF4B1420),
        surface: Color(0xFF2A0E16),
        surfaceAlt: Color(0xFF35101B),
        border: Color(0xFFC59079),
        text: Color(0xFFFFEEF0),
        mutedText: Color(0xFFE0B8BE),
      );
  }
}

IconData _sectionIconForLevel(String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return Icons.sports_bar_rounded;
    case 'gameLevelClassic':
      return Icons.local_fire_department_rounded;
    default:
      return Icons.workspace_premium_rounded;
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredEntry = _GameEntry(
      titleKey: 'gameTitle',
      playerCountKey: 'gamePyramidPlayers',
      featured: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const PyramidMenuPage(),
          ),
        );
      },
    );

    final sections = <_GameSection>[
      const _GameSection(
        levelKey: 'gameLevelStarter',
        entries: [
          _GameEntry(
            titleKey: 'gameCompareTitle',
            playerCountKey: 'gameComparePlayers',
          ),
        ],
      ),
      const _GameSection(
        levelKey: 'gameLevelClassic',
        entries: [
          _GameEntry(
            titleKey: 'gameHorseRaceTitle',
            playerCountKey: 'gameHorseRacePlayers',
          ),
        ],
      ),
      _GameSection(levelKey: 'gameLevelChallenge', entries: [featuredEntry]),
    ];

    return Scaffold(
      backgroundColor: _pageBackgroundTop,
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_pageBackgroundTop, _pageBackgroundBottom],
            ),
          ),
          child: Stack(
            children: [
              const _MainMenuBackgroundDecor(),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _MainMenuHeaderRow(),
                        const SizedBox(height: 12),
                        const _MainMenuIntroBlock(),
                        const SizedBox(height: 8),
                        for (
                          var index = 0;
                          index < sections.length;
                          index++
                        ) ...[
                          _StaggeredReveal(
                            delay: Duration(milliseconds: 140 + (index * 120)),
                            child: _GameSectionBlock(section: sections[index]),
                          ),
                          if (index != sections.length - 1)
                            const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainMenuBackgroundDecor extends StatefulWidget {
  const _MainMenuBackgroundDecor();

  @override
  State<_MainMenuBackgroundDecor> createState() =>
      _MainMenuBackgroundDecorState();
}

class _MainMenuBackgroundDecorState extends State<_MainMenuBackgroundDecor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final intensity = 0.88 + (_controller.value * 0.12);

          return Opacity(
            opacity: intensity,
            child: _CurtainGlow(
              accent: const Color(0xFFF0CD8D),
              intensity: intensity,
            ),
          );
        },
      ),
    );
  }
}

class _MainMenuHeaderRow extends StatelessWidget {
  const _MainMenuHeaderRow();

  @override
  Widget build(BuildContext context) {
    return _MainMenuBrandHeader(
      onSettingsTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const AppSettingsPage(),
          ),
        );
      },
    );
  }
}

class _MainMenuBrandHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  const _MainMenuBrandHeader({this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34111A), Color(0xFF17080D)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x55F0CD8D)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x12FFE3B1), Color(0x03FFFFFF)],
              ),
              border: Border.all(color: const Color(0x1AFFE3B1)),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            top: 0,
            child: Container(height: 1, color: const Color(0x44FFE3B1)),
          ),
          Row(
            children: [
              const _PlayingCardsMark(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'POKER DRINKER',
                        maxLines: 1,
                        softWrap: false,
                        style: textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFFFE3B1),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.05,
                          height: 0.96,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      PyramidPokerStrings.get('mainMenuBrandTagline'),
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFF0CD8D).withValues(alpha: 0.82),
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
              if (onSettingsTap != null) ...[
                const SizedBox(width: 10),
                _AnimatedSettingsButton(onTap: onSettingsTap!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedSettingsButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedSettingsButton({required this.onTap});

  @override
  State<_AnimatedSettingsButton> createState() =>
      _AnimatedSettingsButtonState();
}

class _AnimatedSettingsButtonState extends State<_AnimatedSettingsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.08);
        return Transform.scale(
          scale: scale,
          child: IconButton(
            icon: const Icon(
              Icons.settings_rounded,
              color: _goldAccent,
              size: 24,
            ),
            onPressed: widget.onTap,
            tooltip: '設定',
          ),
        );
      },
    );
  }
}

class _MainMenuIntroBlock extends StatelessWidget {
  const _MainMenuIntroBlock();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PyramidPokerStrings.get('mainMenuSectionPrompt'),
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            PyramidPokerStrings.get('mainMenuIntroSubtitle'),
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsFloatingButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SettingsFloatingButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF34111A), Color(0xFF17080D)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x66F0CD8D)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.settings_rounded,
            color: _goldAccent,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _PlayingCardsMark extends StatelessWidget {
  const _PlayingCardsMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: Transform.rotate(
              angle: -0.28,
              child: const _MiniCard(suit: '♥', width: 23, height: 31),
            ),
          ),
          Positioned(
            left: 15,
            top: 0,
            child: const _MiniCard(
              suit: '♠',
              width: 24,
              height: 34,
              highlighted: true,
            ),
          ),
          Positioned(
            right: 0,
            top: 8,
            child: Transform.rotate(
              angle: 0.28,
              child: const _MiniCard(suit: '♦', width: 23, height: 31),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String suit;
  final double width;
  final double height;
  final bool highlighted;

  const _MiniCard({
    required this.suit,
    required this.width,
    required this.height,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted
        ? const Color(0xFFFFE3B1)
        : const Color(0xFFF0CD8D);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF14080D),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: foreground.withValues(alpha: highlighted ? 0.92 : 0.72),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 1, 2, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'A',
                    style: TextStyle(
                      color: foreground,
                      fontSize: highlighted ? 6.4 : 5.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    suit,
                    style: TextStyle(
                      color: foreground,
                      fontSize: highlighted ? 6.4 : 5.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  suit,
                  style: TextStyle(
                    color: foreground,
                    fontSize: highlighted ? 12.5 : 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameSectionBlock extends StatelessWidget {
  final _GameSection section;

  const _GameSectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _styleForLevel(section.levelKey);
    final isChallenge = section.levelKey == 'gameLevelChallenge';
    final isStarter = section.levelKey == 'gameLevelStarter';
    final isClassic = section.levelKey == 'gameLevelClassic';
    final sectionShadow = isChallenge
        ? [
            BoxShadow(
              color: style.accent.withValues(alpha: 0.14),
              blurRadius: 24,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: Color(0x24000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ]
        : [
            BoxShadow(
              color: style.accent.withValues(alpha: isClassic ? 0.08 : 0.05),
              blurRadius: isClassic ? 16 : 12,
              offset: const Offset(0, 8),
            ),
          ];

    // 決定 emoji 與動畫
    String emoji = '';
    switch (section.levelKey) {
      case 'gameLevelStarter':
        emoji = '🍻';
        break;
      case 'gameLevelClassic':
        emoji = '🎉';
        break;
      case 'gameLevelChallenge':
        emoji = '🔥';
        break;
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            style.accent.withValues(
              alpha: isChallenge
                  ? 0.24
                  : isClassic
                  ? 0.14
                  : 0.09,
            ),
            const Color(0xFF2A1015).withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: style.border.withValues(
            alpha: isChallenge
                ? 0.34
                : isClassic
                ? 0.18
                : 0.12,
          ),
        ),
        boxShadow: sectionShadow,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14,
          isChallenge ? 16 : 14,
          14,
          isStarter ? 13 : 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _SectionHeaderBadge(
                  icon: _sectionIconForLevel(section.levelKey),
                  style: style,
                ),
                const SizedBox(width: 8),
                _AnimatedEmoji(emoji: emoji),
                const SizedBox(width: 4),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    _sectionCaption(section.levelKey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: style.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _GameMetaPill(
                      label: PyramidPokerStrings.get(section.levelKey),
                      accent: style.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _sectionSupportCopy(section.levelKey),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(
                  alpha: isChallenge
                      ? 0.70
                      : isClassic
                      ? 0.66
                      : 0.60,
                ),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            for (final entry in section.entries) ...[
              _GameMenuCard(entry: entry, levelKey: section.levelKey),
              if (entry != section.entries.last) const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeaderBadge extends StatelessWidget {
  final IconData icon;
  final _SectionStyle style;

  const _SectionHeaderBadge({required this.icon, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: style.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: style.border.withValues(alpha: 0.36)),
        boxShadow: [
          BoxShadow(
            color: style.accent.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 12, color: style.accent),
    );
  }
}

class _CurtainGlow extends StatelessWidget {
  final Color accent;
  final double intensity;

  const _CurtainGlow({required this.accent, this.intensity = 1});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CurtainGlowPainter(accent, intensity));
  }
}

class _CurtainGlowPainter extends CustomPainter {
  final Color accent;
  final double intensity;

  _CurtainGlowPainter(this.accent, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accent.withValues(alpha: 0.14 * intensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));

    final path1 = Path()
      ..moveTo(size.width * 0.10, 0)
      ..lineTo(size.width * 0.30, 0)
      ..lineTo(size.width * 0.18, size.height * 0.62)
      ..lineTo(size.width * 0.02, size.height * 0.62)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.62, 0)
      ..lineTo(size.width * 0.88, 0)
      ..lineTo(size.width * 0.98, size.height * 0.72)
      ..lineTo(size.width * 0.74, size.height * 0.72)
      ..close();

    canvas.drawPath(path1, beamPaint);
    canvas.drawPath(path2, beamPaint);
  }

  @override
  bool shouldRepaint(covariant _CurtainGlowPainter oldDelegate) {
    return oldDelegate.accent != accent || oldDelegate.intensity != intensity;
  }
}

class _GameMenuCard extends StatelessWidget {
  final _GameEntry entry;
  final String levelKey;

  const _GameMenuCard({required this.entry, required this.levelKey});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _styleForLevel(levelKey);
    final available = entry.isAvailable;
    final accent = style.accent;
    final labelColor = const Color(0xFFE8C98D);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              accent.withValues(alpha: available ? 0.08 : 0.03),
              const Color(0xFF1F0B11),
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    PyramidPokerStrings.get(entry.titleKey),
                    style: textTheme.titleMedium?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 17.5,
                      height: 1.08,
                      letterSpacing: 0.08,
                    ),
                  ),
                ),
                _PlayerPill(
                  label: _homeGameDurationLabel(entry.titleKey),
                  accent: accent,
                  dimmed: !available,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameMetaPill extends StatelessWidget {
  final String label;
  final Color accent;

  const _GameMetaPill({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: accent,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

class _ArrowBadge extends StatelessWidget {
  final Color color;
  final Color accent;
  final bool highlighted;

  const _ArrowBadge({
    required this.color,
    required this.accent,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: highlighted ? 34 : 32,
      height: highlighted ? 34 : 32,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: highlighted ? 0.14 : 0.10),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: highlighted ? 0.16 : 0.08),
            blurRadius: highlighted ? 12 : 8,
            spreadRadius: highlighted ? 0.5 : 0,
          ),
        ],
      ),
      child: Icon(Icons.arrow_forward_rounded, size: 18, color: color),
    );
  }
}

class _StaggeredReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggeredReveal({required this.child, required this.delay});

  @override
  State<_StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<_StaggeredReveal> {
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.06),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOut,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

class _FeaturedSparkle extends StatefulWidget {
  final Color color;

  const _FeaturedSparkle({required this.color});

  @override
  State<_FeaturedSparkle> createState() => _FeaturedSparkleState();
}

class _FeaturedSparkleState extends State<_FeaturedSparkle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final eased = Curves.easeInOut.transform(_controller.value);
        final scale = 1 + (eased * 0.14);
        final glow = 4 + (eased * 8);

        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.18 + (eased * 0.16)),
                  blurRadius: glow,
                  spreadRadius: eased * 0.6,
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: widget.color.withValues(alpha: 0.84 + (eased * 0.16)),
            ),
          ),
        );
      },
    );
  }
}

class _PlayerPill extends StatelessWidget {
  final String label;
  final Color accent;
  final bool dimmed;

  const _PlayerPill({
    required this.label,
    required this.accent,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: dimmed ? 0.03 : 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: accent.withValues(alpha: dimmed ? 0.7 : 1),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}

// 微動 emoji
class _AnimatedEmoji extends StatefulWidget {
  final String emoji;
  const _AnimatedEmoji({required this.emoji});
  @override
  State<_AnimatedEmoji> createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<_AnimatedEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.13);
        return Transform.scale(
          scale: scale,
          child: Text(widget.emoji, style: const TextStyle(fontSize: 18)),
        );
      },
    );
  }
}
