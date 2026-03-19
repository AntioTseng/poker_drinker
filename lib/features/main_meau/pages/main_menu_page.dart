import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';

const _pageBackgroundTop = Color(0xFF14080D);
const _pageBackgroundBottom = Color(0xFF3A131C);
const _goldAccent = Color(0xFFE8C98D);

String _localizedCopy(
  BuildContext context, {
  required String zh,
  required String en,
}) {
  return zh;
}

String _sectionCaption(BuildContext context, String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return _localizedCopy(context, zh: '先暖場', en: '先暖場');
    case 'gameLevelClassic':
      return _localizedCopy(context, zh: '節奏上來', en: '節奏上來');
    default:
      return _localizedCopy(context, zh: '主桌時刻', en: '主桌時刻');
  }
}

String _homePlayerCountLabel(BuildContext context, String playerCountKey) {
  switch (playerCountKey) {
    case 'gameComparePlayers':
      return _localizedCopy(context, zh: '2-6人', en: '2-6人');
    case 'gameHorseRacePlayers':
      return _localizedCopy(context, zh: '2-6人', en: '2-6人');
    case 'gameClassicReservedPlayers':
      return _localizedCopy(context, zh: '2-6人', en: '2-6人');
    case 'gamePyramidPlayers':
      return _localizedCopy(context, zh: '2-6人', en: '2-6人');
    case 'gameChallengeReservedPlayers':
      return _localizedCopy(context, zh: '4-10人', en: '4-10人');
    default:
      return PyramidPokerStrings.get(playerCountKey);
  }
}

String _sectionSupportCopy(BuildContext context, String levelKey) {
  switch (levelKey) {
    case 'gameLevelStarter':
      return _localizedCopy(context, zh: '先讓全桌進到同一個節奏。', en: '先讓全桌進到同一個節奏。');
    case 'gameLevelClassic':
      return _localizedCopy(context, zh: '把場子從暖場推到主桌前。', en: '把場子從暖場推到主桌前。');
    default:
      return _localizedCopy(context, zh: '今晚最重的玩法都在這裡。', en: '今晚最重的玩法都在這裡。');
  }
}

String _gameSummaryCopy(BuildContext context, String titleKey) {
  switch (titleKey) {
    case 'gameCompareTitle':
      return _localizedCopy(context, zh: '規則直覺，開局最快。', en: '規則直覺，開局最快。');
    case 'gameHorseRaceTitle':
      return _localizedCopy(context, zh: '節奏連續，氣氛升得快。', en: '節奏連續，氣氛升得快。');
    case 'gameTitle':
      return _localizedCopy(context, zh: '主桌核心玩法，張力最高。', en: '主桌核心玩法，張力最高。');
    case 'gameChallengeReservedTitle':
      return _localizedCopy(context, zh: '保留給之後的重口味玩法。', en: '保留給之後的重口味玩法。');
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

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      _GameSection(
        levelKey: 'gameLevelChallenge',
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MainMenuHeaderRow(
                          onSettingsTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const AppSettingsPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const _MainMenuHeroIntro(),
                        const SizedBox(height: 14),
                        for (final section in sections) ...[
                          _GameSectionBlock(section: section),
                          if (section != sections.last)
                            const SizedBox(height: 10),
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

class _MainMenuBackgroundDecor extends StatelessWidget {
  const _MainMenuBackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(child: _CurtainGlow(accent: Color(0xFFF0CD8D)));
  }
}

class _MainMenuHeroIntro extends StatelessWidget {
  const _MainMenuHeroIntro();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _localizedCopy(context, zh: '今晚主場準備開燈', en: '今晚主場準備開燈'),
          style: textTheme.labelLarge?.copyWith(
            color: const Color(0xFFE8C98D),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _localizedCopy(context, zh: '從暖場進門\n一路走到主桌', en: '從暖場進門\n一路走到主桌'),
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 0.96,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _localizedCopy(
            context,
            zh: '快速選一局，先暖場，再把整桌一路帶進主桌。',
            en: '快速選一局，先暖場，再把整桌一路帶進主桌。',
          ),
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.74),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _MainMenuHeaderRow extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const _MainMenuHeaderRow({required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _MainMenuBrandHeader()),
        IconButton(
          onPressed: onSettingsTap,
          visualDensity: VisualDensity.compact,
          splashRadius: 16,
          padding: const EdgeInsets.all(2),
          icon: const Icon(
            Icons.settings_rounded,
            color: _goldAccent,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class _MainMenuBrandHeader extends StatelessWidget {
  const _MainMenuBrandHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const _PlayingCardsMark(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POKER DRINKER',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFFFE3B1),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.9,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '朋友局最順手的撲克牌喝酒遊戲',
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFF0CD8D).withValues(alpha: 0.78),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayingCardsMark extends StatelessWidget {
  const _PlayingCardsMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 5,
            child: Transform.rotate(
              angle: -0.28,
              child: const _MiniCard(suit: '♥', width: 17, height: 23),
            ),
          ),
          Positioned(
            left: 11,
            top: 0,
            child: const _MiniCard(
              suit: '♠',
              width: 18,
              height: 25,
              highlighted: true,
            ),
          ),
          Positioned(
            right: 0,
            top: 5,
            child: Transform.rotate(
              angle: 0.28,
              child: const _MiniCard(suit: '♦', width: 17, height: 23),
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
                      fontSize: 5.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    suit,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 5.2,
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
                    fontSize: highlighted ? 9.5 : 8.5,
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            style.accent.withValues(alpha: isChallenge ? 0.18 : 0.10),
            const Color(0xFF2A1015).withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: style.border.withValues(alpha: isChallenge ? 0.28 : 0.14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.wine_bar_rounded, size: 14, color: style.accent),
                const SizedBox(width: 4),
                Text(
                  _sectionCaption(context, section.levelKey),
                  style: textTheme.labelSmall?.copyWith(
                    color: style.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  PyramidPokerStrings.get(section.levelKey),
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _sectionSupportCopy(context, section.levelKey),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.62),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            for (final entry in section.entries) ...[
              _GameMenuCard(entry: entry, levelKey: section.levelKey),
              if (entry != section.entries.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _CurtainGlow extends StatelessWidget {
  final Color accent;

  const _CurtainGlow({required this.accent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CurtainGlowPainter(accent));
  }
}

class _CurtainGlowPainter extends CustomPainter {
  final Color accent;

  _CurtainGlowPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [accent.withValues(alpha: 0.16), Colors.transparent],
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
    return oldDelegate.accent != accent;
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
    final isHeadline = entry.titleKey == 'gameTitle';
    final labelColor = const Color(0xFFE8C98D);
    final metaAccent = accent.withValues(alpha: available ? 1 : 0.52);
    final summary = _gameSummaryCopy(context, entry.titleKey);
    final rowFill = Color.alphaBlend(
      accent.withValues(alpha: available ? 0.08 : 0.04),
      const Color(0xFF1F0B11),
    );
    final rowBorder = accent.withValues(alpha: available ? 0.15 : 0.08);
    final arrowColor = accent.withValues(alpha: available ? 0.92 : 0.32);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: rowFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: rowBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              PyramidPokerStrings.get(entry.titleKey),
                              style: textTheme.titleMedium?.copyWith(
                                color: labelColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                height: 1.1,
                              ),
                            ),
                          ),
                          if (isHeadline) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: accent,
                            ),
                          ],
                        ],
                      ),
                      if (summary.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          summary,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(
                              alpha: available ? 0.66 : 0.40,
                            ),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _PlayerPill(
                      label: _homePlayerCountLabel(
                        context,
                        entry.playerCountKey,
                      ),
                      accent: metaAccent,
                      dimmed: !available,
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: arrowColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: accent.withValues(alpha: dimmed ? 0.7 : 1),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
