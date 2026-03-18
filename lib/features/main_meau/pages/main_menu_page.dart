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
        accent: Color(0xFFD09D62),
        tint: Color(0xFF3A231A),
        surface: Color(0xFF241419),
        surfaceAlt: Color(0xFF2A1818),
        border: Color(0xFF8D6138),
        text: Color(0xFFF7EBD9),
        mutedText: Color(0xFFD3BEA1),
      );
    case 'gameLevelClassic':
      return const _SectionStyle(
        accent: Color(0xFFD08D77),
        tint: Color(0xFF341922),
        surface: Color(0xFF26121A),
        surfaceAlt: Color(0xFF2D151F),
        border: Color(0xFF915A56),
        text: Color(0xFFF8E6E2),
        mutedText: Color(0xFFD8BCB8),
      );
    default:
      return const _SectionStyle(
        accent: Color(0xFF6E1625),
        tint: Color(0xFF4B1420),
        surface: Color(0xFF2A0E16),
        surfaceAlt: Color(0xFF35101B),
        border: Color(0xFFC59079),
        text: Color(0xFFFFEEF0),
        mutedText: Color(0xFFE0B8BE),
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

String _sectionLead(BuildContext context, String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return _menuText(
        context,
        'gameLevelStarterLead',
        zh: '暖場開局',
        en: 'Opening Round',
      );
    case 'gameLevelClassic':
      return _menuText(
        context,
        'gameLevelClassicLead',
        zh: '節奏升溫',
        en: 'Raising the Pace',
      );
    default:
      return _menuText(
        context,
        'gameLevelChallengeLead',
        zh: '今晚主桌',
        en: 'House Headliner',
      );
  }
}

Color _gameTitleColor(_GameEntry entry, String levelKey, _SectionStyle style) {
  switch (entry.titleKey) {
    case 'gameCompareTitle':
      return const Color(0xFFF0D6A1);
    case 'gameHorseRaceTitle':
      return const Color(0xFFE7B98A);
    case 'gameTitle':
      return const Color(0xFFFFE1B0);
    case 'gameClassicReservedTitle':
      return const Color(0xFFE4C7C3);
    case 'gameChallengeReservedTitle':
      return const Color(0xFFE0A59B);
    default:
      return style.text;
  }
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
        toolbarHeight: 50,
        titleSpacing: 16,
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
            fontSize: 17,
            letterSpacing: 1.0,
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
            final horizontalPadding = compact ? 14.0 : 22.0;
            final topPadding = compact ? 10.0 : 14.0;
            final bottomPadding = compact ? 22.0 : 32.0;
            final sectionGap = compact ? 16.0 : 22.0;

            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_pageBackgroundTop, _pageBackgroundBottom],
                ),
              ),
              child: Center(
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
                          _GameSectionBlock(section: section, compact: compact),
                          if (section != sections.last)
                            SizedBox(height: sectionGap),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
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
    final outerRadius = compact ? 20.0 : 22.0;
    final headerGap = compact ? 12.0 : 14.0;
    final drinkCount = switch (section.levelKey) {
      'gameLevelStarter' => 1,
      'gameLevelClassic' => 2,
      _ => 3,
    };
    final sectionLead = _sectionLead(context, section.levelKey);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              style.accent.withValues(alpha: isChallenge ? 0.10 : 0.05),
              const Color(0xFF41141E),
            ),
            const Color(0xFF2A1015),
          ],
        ),
        borderRadius: BorderRadius.circular(outerRadius),
        border: Border.all(
          color: style.border.withValues(alpha: isChallenge ? 0.30 : 0.12),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 14 : 16,
          compact ? 12 : 14,
          compact ? 14 : 16,
          compact ? 12 : 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: isChallenge ? 2.5 : 1,
              width: isChallenge ? double.infinity : (compact ? 86 : 96),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    style.accent.withValues(alpha: isChallenge ? 0.90 : 0.72),
                    style.accent.withValues(alpha: 0.14),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            SizedBox(height: compact ? 12 : 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionLead,
                        style: textTheme.labelSmall?.copyWith(
                          color: style.accent.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          fontSize: compact ? 10 : 11,
                        ),
                      ),
                      SizedBox(height: compact ? 6 : 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              PyramidPokerStrings.get(section.levelKey),
                              style:
                                  (compact
                                          ? textTheme.titleLarge
                                          : textTheme.headlineSmall)
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: isChallenge
                                            ? (compact ? 22 : 24)
                                            : (compact ? 19 : 22),
                                      ),
                            ),
                          ),
                          SizedBox(width: compact ? 6 : 8),
                          _DrinkLevelIcons(
                            count: drinkCount,
                            color: style.accent,
                            compact: compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 10 : 12),
                Text(
                  '${section.entries.length} 款',
                  style: textTheme.labelSmall?.copyWith(
                    color: style.accent.withValues(
                      alpha: isChallenge ? 0.96 : 0.82,
                    ),
                    fontWeight: FontWeight.w800,
                    fontSize: compact ? 10 : 11,
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 8 : 10),
            Text(
              _menuText(
                context,
                section.hintKey,
                zh: section.hintFallbackZh,
                en: section.hintFallbackEn,
              ),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
                fontSize: compact ? 11 : 12,
                height: 1.35,
              ),
            ),
            SizedBox(height: headerGap),
            for (final entry in section.entries) ...[
              _GameMenuCard(
                entry: entry,
                levelKey: section.levelKey,
                compact: compact,
              ),
              if (entry != section.entries.last)
                Divider(
                  height: compact ? 12 : 14,
                  thickness: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
            ],
          ],
        ),
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
    final available = entry.isAvailable;
    final accent = available ? style.accent : AppTheme.secondaryAccent;
    final labelColor = available
        ? _gameTitleColor(
            entry,
            levelKey,
            style,
          ).withValues(alpha: entry.featured ? 1 : 0.92)
        : _gameTitleColor(entry, levelKey, style).withValues(alpha: 0.42);
    final metaAccent = available ? accent : accent.withValues(alpha: 0.52);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: compact ? 4 : 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entry.featured) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: accent.withValues(alpha: 0.16)),
                  ),
                  child: Text(
                    _menuText(
                      context,
                      'mainMenuFeatureLabel',
                      zh: '今晚推薦玩法',
                      en: 'Tonight\'s featured round',
                    ),
                    style: textTheme.labelSmall?.copyWith(
                      color: accent.withValues(alpha: 0.96),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      fontSize: compact ? 9.5 : 10.5,
                    ),
                  ),
                ),
                SizedBox(height: compact ? 6 : 8),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      PyramidPokerStrings.get(entry.titleKey),
                      style:
                          (entry.featured
                                  ? (compact
                                        ? textTheme.titleMedium
                                        : textTheme.titleLarge)
                                  : (compact
                                        ? textTheme.bodyLarge
                                        : textTheme.titleMedium))
                              ?.copyWith(
                                color: labelColor,
                                fontWeight: entry.featured
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                                fontSize: entry.featured
                                    ? (compact ? 18 : 20)
                                    : (compact ? 14 : 16),
                              ),
                    ),
                  ),
                  SizedBox(width: compact ? 8 : 10),
                  _PlayerPill(
                    playerCountKey: entry.playerCountKey,
                    accent: metaAccent,
                    dimmed: !available,
                    compact: compact,
                  ),
                  if (available) ...[
                    SizedBox(width: compact ? 8 : 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: compact ? 16 : 18,
                      color: accent,
                    ),
                  ],
                ],
              ),
            ],
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
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: dimmed ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_rounded,
            size: compact ? 11 : 13,
            color: accent.withValues(alpha: dimmed ? 0.58 : 1),
          ),
          SizedBox(width: compact ? 2.5 : 4),
          Text(
            PyramidPokerStrings.get(playerCountKey),
            style: textTheme.bodySmall?.copyWith(
              color: accent.withValues(alpha: dimmed ? 0.7 : 1),
              fontWeight: FontWeight.w800,
              fontSize: compact ? 10 : 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkLevelIcons extends StatelessWidget {
  final int count;
  final Color color;
  final bool compact;

  const _DrinkLevelIcons({
    required this.count,
    required this.color,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < count; index++) ...[
          Icon(
            Icons.wine_bar_rounded,
            size: compact ? 14 : 15,
            color: color.withValues(alpha: 0.9),
          ),
          if (index != count - 1) SizedBox(width: compact ? 2 : 3),
        ],
      ],
    );
  }
}
