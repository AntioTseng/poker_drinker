import 'package:flutter/material.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';
import '../../../core/theme/app_theme.dart';

class _GameEntry {
  final String levelKey;
  final String titleKey;
  final String statusKey;
  final IconData icon;
  final VoidCallback? onTap;

  const _GameEntry({
    required this.levelKey,
    required this.titleKey,
    required this.statusKey,
    required this.icon,
    this.onTap,
  });

  bool get isAvailable => onTap != null;
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entries = <_GameEntry>[
      const _GameEntry(
        levelKey: 'gameLevelStarter',
        titleKey: 'gameCompareTitle',
        statusKey: 'gameStatusComingSoon',
        icon: Icons.swap_vert_circle_rounded,
      ),
      _GameEntry(
        levelKey: 'gameLevelClassic',
        titleKey: 'gameTitle',
        statusKey: 'gameStatusAvailable',
        icon: Icons.change_circle_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PyramidMenuPage()),
          );
        },
      ),
      const _GameEntry(
        levelKey: 'gameLevelChallenge',
        titleKey: 'gameChallengeTitle',
        statusKey: 'gameStatusComingSoon',
        icon: Icons.extension_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(PyramidPokerStrings.get('mainMenuTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    PyramidPokerStrings.get('mainMenuTitle'),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final entry in entries) ...[
                    _GameMenuCard(entry: entry),
                    if (entry != entries.last) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameMenuCard extends StatelessWidget {
  final _GameEntry entry;

  const _GameMenuCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool available = entry.isAvailable;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: AppTheme.panel,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: available
                  ? AppTheme.secondaryAccent.withValues(alpha: 0.16)
                  : AppTheme.secondaryAccent.withValues(alpha: 0.12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: available
                        ? AppTheme.primaryAccent.withValues(alpha: 0.1)
                        : AppTheme.secondaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    entry.icon,
                    color: available
                        ? AppTheme.primaryAccent
                        : AppTheme.secondaryAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.pageBackground,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              PyramidPokerStrings.get(entry.levelKey),
                              style: textTheme.bodySmall?.copyWith(
                                color: AppTheme.secondaryAccent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        PyramidPokerStrings.get(entry.titleKey),
                        style: textTheme.titleLarge?.copyWith(
                          color: AppTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  PyramidPokerStrings.get(entry.statusKey),
                  style: textTheme.bodySmall?.copyWith(
                    color: available
                        ? AppTheme.primaryAccent
                        : AppTheme.secondaryAccent,
                    fontWeight: FontWeight.w800,
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
