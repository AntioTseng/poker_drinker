import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';

const _pageBackgroundTop = Color(0xFF12070C);
const _pageBackgroundBottom = Color(0xFF31101A);
const _goldAccent = Color(0xFFE8C98D);

class _GameEntry {
  final String titleKey;
  final String playerCountKey;
  final String? subtitleKey;
  final String? subtitleFallbackZh;
  final String? subtitleFallbackEn;
  final bool featured;
  final VoidCallback? onTap;

  const _GameEntry({
    required this.titleKey,
    required this.playerCountKey,
    this.subtitleKey,
    this.subtitleFallbackZh,
    this.subtitleFallbackEn,
    this.featured = false,
    this.onTap,
  });

  bool get isAvailable => onTap != null;
}

class _GameSection {
  final String levelKey;
  final String hintKey;
  final String hintFallbackZh;
  final String hintFallbackEn;
  final List<_GameEntry> entries;

  const _GameSection({
    required this.levelKey,
    required this.hintKey,
    required this.hintFallbackZh,
    required this.hintFallbackEn,
    required this.entries,
  });
}

class _SectionStyle {
  final Color accent;
  final Color tint;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color glow;
  final Color text;
  final Color mutedText;
  final IconData icon;

  const _SectionStyle({
    required this.accent,
    required this.tint,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.glow,
    required this.text,
    required this.mutedText,
    required this.icon,
  });
}

_SectionStyle _styleForLevel(String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return const _SectionStyle(
        accent: Color(0xFFD09D62),
        tint: Color(0xFF3A231A),
        surface: Color(0xFF241419),
        surfaceAlt: Color(0xFF2A1818),
        border: Color(0xFF8D6138),
        glow: Color(0xFFD7A15C),
        text: Color(0xFFF7EBD9),
        mutedText: Color(0xFFD3BEA1),
        icon: Icons.local_bar_rounded,
      );
    case 'gameLevelClassic':
      return const _SectionStyle(
        accent: Color(0xFFD08D77),
        tint: Color(0xFF341922),
        surface: Color(0xFF26121A),
        surfaceAlt: Color(0xFF2D151F),
        border: Color(0xFF915A56),
        glow: Color(0xFFC7867A),
        text: Color(0xFFF8E6E2),
        mutedText: Color(0xFFD8BCB8),
        icon: Icons.sports_bar_rounded,
      );
    default:
      return const _SectionStyle(
        accent: Color(0xFF6E1625),
        tint: Color(0xFF4B1420),
        surface: Color(0xFF2A0E16),
        surfaceAlt: Color(0xFF35101B),
        border: Color(0xFFC59079),
        glow: Color(0xFF9A3245),
        text: Color(0xFFFFEEF0),
        mutedText: Color(0xFFE0B8BE),
        icon: Icons.liquor_rounded,
      );
  }
}

String _menuText(
  BuildContext context,
  String key, {
  required String zh,
  required String en,
}) {
  final value = PyramidPokerStrings.get(key);
  if (value != key) {
    return value;
  }

  return Localizations.localeOf(context).languageCode == 'en' ? en : zh;
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_GameSection>[
      const _GameSection(
        levelKey: 'gameLevelStarter',
        hintKey: 'gameLevelStarterHint',
        hintFallbackZh: '暖場最快，先把桌子炒熱。',
        hintFallbackEn: 'The fastest warm-up tier to get the table moving.',
        entries: [
          _GameEntry(
            titleKey: 'gameCompareTitle',
            playerCountKey: 'gameComparePlayers',
          ),
          _GameEntry(
            titleKey: 'gameHorseRaceTitle',
            playerCountKey: 'gameHorseRacePlayers',
          ),
        ],
      ),
      const _GameSection(
        levelKey: 'gameLevelClassic',
        hintKey: 'gameLevelClassicHint',
        hintFallbackZh: '酒意開始上來，節奏也更穩。',
        hintFallbackEn: 'The room is loose, and the pace settles in.',
        entries: [
          _GameEntry(
            titleKey: 'gameClassicReservedTitle',
            playerCountKey: 'gameClassicReservedPlayers',
          ),
        ],
      ),
      _GameSection(
        levelKey: 'gameLevelChallenge',
        hintKey: 'gameLevelChallengeHint',
        hintFallbackZh: '今晚的主桌，懲罰與壓力都會拉滿。',
        hintFallbackEn: 'The headline table where pressure and penalties peak.',
        entries: [
          _GameEntry(
            titleKey: 'gameTitle',
            playerCountKey: 'gamePyramidPlayers',
            subtitleKey: 'gameCardPyramidSubtitle',
            subtitleFallbackZh: '疊得越高，喝得越多，最適合做今晚主打的一局。',
            subtitleFallbackEn:
                'The higher the pyramid climbs, the harder the whole table pays.',
            featured: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const PyramidMenuPage(),
                ),
              );
            },
          ),
          const _GameEntry(
            titleKey: 'gameChallengeReservedTitle',
            playerCountKey: 'gameChallengeReservedPlayers',
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: _pageBackgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: _goldAccent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          _menuText(
            context,
            'appTitle',
            zh: 'POKER DRINKER',
            en: 'POKER DRINKER',
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _goldAccent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AppSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 420;
            final horizontalPadding = compact ? 12.0 : 20.0;
            final topPadding = compact ? 6.0 : 12.0;
            final bottomPadding = compact ? 16.0 : 28.0;
            final sectionGap = compact ? 8.0 : 14.0;

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_pageBackgroundTop, _pageBackgroundBottom],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: compact ? -52 : -40,
                  right: compact ? -68 : -44,
                  child: IgnorePointer(
                    child: Container(
                      width: compact ? 180 : 240,
                      height: compact ? 180 : 240,
                      decoration: BoxDecoration(
                        color: _goldAccent.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -56,
                  bottom: compact ? 40 : 18,
                  child: IgnorePointer(
                    child: Container(
                      width: compact ? 156 : 220,
                      height: compact ? 156 : 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C2741).withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final section in sections) ...[
                            _GameSectionBlock(
                              section: section,
                              compact: compact,
                            ),
                            if (section != sections.last)
                              SizedBox(height: sectionGap),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GameSectionBlock extends StatelessWidget {
  final _GameSection section;
  final bool compact;

  const _GameSectionBlock({required this.section, required this.compact});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _styleForLevel(section.levelKey);
    final isChallenge = section.levelKey == 'gameLevelChallenge';
    final isStarter = section.levelKey == 'gameLevelStarter';
    final outerRadius = compact
        ? (isChallenge ? 23.0 : 20.0)
        : (isChallenge ? 28.0 : 26.0);
    final blockPadding = compact
        ? (isChallenge ? 13.0 : 10.0)
        : (isChallenge ? 16.0 : 15.0);
    final headerGap = compact ? (isChallenge ? 9.0 : 6.0) : 12.0;
    final entryGap = compact ? 6.0 : 10.0;
    final labelText = isChallenge
        ? (Localizations.localeOf(context).languageCode == 'en'
              ? 'Headline table'
              : '主桌等級')
        : isStarter
        ? (Localizations.localeOf(context).languageCode == 'en'
              ? 'Warm-up'
              : '暖場局')
        : (Localizations.localeOf(context).languageCode == 'en'
              ? 'Steady pace'
              : '進場局');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isChallenge
              ? [const Color(0xFF2D0F18), const Color(0xFF3A1220)]
              : [style.surface, style.surfaceAlt],
        ),
        borderRadius: BorderRadius.circular(outerRadius),
        border: Border.all(
          color: style.border.withValues(alpha: isChallenge ? 0.82 : 0.34),
        ),
        boxShadow: [
          BoxShadow(
            color: style.glow.withValues(alpha: isChallenge ? 0.3 : 0.12),
            blurRadius: isChallenge ? 34 : 18,
            offset: Offset(0, isChallenge ? 16 : 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: isChallenge ? 5 : 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (isChallenge ? _goldAccent : style.accent).withValues(
                      alpha: isChallenge ? 0.96 : 0.82,
                    ),
                    style.accent.withValues(alpha: 0.36),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(outerRadius),
                ),
              ),
            ),
          ),
          Positioned(
            top: compact ? -16 : -22,
            right: compact ? -24 : -18,
            child: IgnorePointer(
              child: Container(
                width: compact ? (isChallenge ? 96 : 78) : 108,
                height: compact ? (isChallenge ? 96 : 78) : 108,
                decoration: BoxDecoration(
                  color: (isChallenge ? _goldAccent : style.glow).withValues(
                    alpha: isChallenge ? 0.28 : 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              blockPadding,
              compact ? (isChallenge ? 12 : 10) : 16,
              blockPadding,
              blockPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TierIcon(style: style, compact: compact),
                    SizedBox(width: compact ? 9 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labelText,
                            style: textTheme.labelSmall?.copyWith(
                              color: isChallenge
                                  ? _goldAccent
                                  : style.mutedText.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                          SizedBox(height: compact ? 1 : 3),
                          Text(
                            PyramidPokerStrings.get(section.levelKey),
                            style:
                                (compact
                                        ? textTheme.titleMedium
                                        : textTheme.titleLarge)
                                    ?.copyWith(
                                      color: style.text,
                                      fontWeight: FontWeight.w800,
                                      fontSize: compact
                                          ? (isChallenge ? 19 : 16.5)
                                          : null,
                                    ),
                          ),
                          SizedBox(height: compact ? 1 : 4),
                          Text(
                            _menuText(
                              context,
                              section.hintKey,
                              zh: section.hintFallbackZh,
                              en: section.hintFallbackEn,
                            ),
                            maxLines: compact ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: style.mutedText,
                              fontWeight: FontWeight.w600,
                              fontSize: compact
                                  ? (isChallenge ? 11.2 : 10.5)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: headerGap),
                for (final entry in section.entries) ...[
                  _GameMenuCard(
                    entry: entry,
                    levelKey: section.levelKey,
                    compact: compact,
                  ),
                  if (entry != section.entries.last) SizedBox(height: entryGap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameMenuCard extends StatelessWidget {
  final _GameEntry entry;
  final String levelKey;
  final bool compact;

  const _GameMenuCard({
    required this.entry,
    required this.levelKey,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = _styleForLevel(levelKey);
    final isChallenge = levelKey == 'gameLevelChallenge';
    final available = entry.isAvailable;
    final accent = available ? style.accent : AppTheme.secondaryAccent;
    final cardColor = available
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.04);
    final padding = entry.featured
        ? EdgeInsets.fromLTRB(
            compact ? 12 : 18,
            compact ? 12 : 18,
            compact ? 12 : 18,
            compact ? 12 : 18,
          )
        : EdgeInsets.fromLTRB(
            compact ? 10 : 14,
            compact ? 9 : 14,
            compact ? 10 : 14,
            compact ? 9 : 14,
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(compact ? 20 : 22),
        child: Ink(
          decoration: BoxDecoration(
            color: entry.featured ? null : cardColor,
            gradient: entry.featured
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isChallenge
                        ? [const Color(0xFF5A1626), const Color(0xFF2B0F16)]
                        : [style.tint.withValues(alpha: 0.94), style.surface],
                  )
                : null,
            borderRadius: BorderRadius.circular(compact ? 20 : 22),
            border: Border.all(
              color: entry.featured
                  ? (isChallenge ? _goldAccent : accent).withValues(
                      alpha: isChallenge ? 0.62 : 0.46,
                    )
                  : available
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.05),
            ),
            boxShadow: entry.featured
                ? [
                    BoxShadow(
                      color: (isChallenge ? _goldAccent : accent).withValues(
                        alpha: isChallenge ? 0.16 : 0.12,
                      ),
                      blurRadius: isChallenge ? 24 : 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: padding,
            child: entry.featured
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PyramidPokerStrings.get(entry.titleKey),
                        style:
                            (compact
                                    ? textTheme.titleLarge
                                    : textTheme.headlineSmall)
                                ?.copyWith(
                                  color: style.text,
                                  fontWeight: FontWeight.w800,
                                  fontSize: compact ? 20 : 26,
                                ),
                      ),
                      if (entry.subtitleKey != null) ...[
                        SizedBox(height: compact ? 6 : 8),
                        Text(
                          _menuText(
                            context,
                            entry.subtitleKey!,
                            zh: entry.subtitleFallbackZh ?? '',
                            en: entry.subtitleFallbackEn ?? '',
                          ),
                          maxLines: compact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: style.mutedText,
                            fontWeight: FontWeight.w600,
                            height: compact ? 1.24 : 1.4,
                            fontSize: compact ? 13.5 : null,
                          ),
                        ),
                      ],
                      SizedBox(height: compact ? 12 : 14),
                      Row(
                        children: [
                          _PlayerPill(
                            playerCountKey: entry.playerCountKey,
                            accent: isChallenge ? _goldAccent : accent,
                            compact: compact,
                          ),
                          SizedBox(width: compact ? 8 : 10),
                          Text(
                            Localizations.localeOf(context).languageCode == 'en'
                                ? 'Tap to enter'
                                : '點擊進入',
                            style: textTheme.bodySmall?.copyWith(
                              color: style.mutedText,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: compact ? 18 : 20,
                            color: isChallenge ? _goldAccent : accent,
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: compact ? 5 : 8,
                        height: compact ? 24 : 38,
                        decoration: BoxDecoration(
                          color: accent.withValues(
                            alpha: available ? 0.88 : 0.32,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      SizedBox(width: compact ? 10 : 14),
                      Expanded(
                        child: Text(
                          PyramidPokerStrings.get(entry.titleKey),
                          style:
                              (compact
                                      ? textTheme.titleMedium
                                      : textTheme.titleLarge)
                                  ?.copyWith(
                                    color: style.text.withValues(
                                      alpha: available ? 1 : 0.68,
                                    ),
                                    fontWeight: FontWeight.w800,
                                    fontSize: compact ? 15.5 : null,
                                  ),
                        ),
                      ),
                      SizedBox(width: compact ? 6 : 10),
                      _PlayerPill(
                        playerCountKey: entry.playerCountKey,
                        accent: accent,
                        dimmed: !available,
                        compact: compact,
                      ),
                      if (available) ...[
                        SizedBox(width: compact ? 4 : 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: compact ? 15 : 18,
                          color: _goldAccent.withValues(alpha: 0.84),
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

class _PlayerPill extends StatelessWidget {
  final String playerCountKey;
  final Color accent;
  final bool dimmed;
  final bool compact;

  const _PlayerPill({
    required this.playerCountKey,
    required this.accent,
    this.dimmed = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: dimmed ? 0.1 : 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_rounded,
            size: compact ? 12 : 15,
            color: accent.withValues(alpha: dimmed ? 0.58 : 1),
          ),
          SizedBox(width: compact ? 2.5 : 4),
          Text(
            PyramidPokerStrings.get(playerCountKey),
            style: textTheme.bodySmall?.copyWith(
              color: accent.withValues(alpha: dimmed ? 0.7 : 1),
              fontWeight: FontWeight.w800,
              fontSize: compact ? 10.5 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  final _SectionStyle style;
  final bool compact;

  const _TierIcon({required this.style, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 42 : 50,
      height: compact ? 42 : 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            style.accent.withValues(alpha: 0.22),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: style.border.withValues(alpha: 0.42)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 7,
            top: 7,
            child: Container(
              width: compact ? 7 : 9,
              height: compact ? 7 : 9,
              decoration: BoxDecoration(
                color: style.accent.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Icon(style.icon, color: style.accent, size: compact ? 19 : 23),
          Positioned(
            bottom: compact ? 5 : 6,
            child: _TierDots(
              color: style.accent,
              icon: style.icon,
              compact: compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierDots extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool compact;

  const _TierDots({
    required this.color,
    required this.icon,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    var count = 3;
    if (icon == Icons.local_bar_rounded) {
      count = 1;
    } else if (icon == Icons.sports_bar_rounded) {
      count = 2;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < count; index++) ...[
          Container(
            width: compact ? 3.5 : 4,
            height: compact ? 3.5 : 4,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          if (index != count - 1) SizedBox(width: compact ? 2.5 : 3),
        ],
      ],
    );
  }
}
