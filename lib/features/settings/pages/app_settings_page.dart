import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../../../core/theme/app_theme.dart';
import '../../dev/pages/card_render_demo_page.dart';
import '../../dev/pages/main_menu_cover_demo_page.dart';
import '../../pyramid_poker/resources/strings.dart';

const _settingsTop = Color(0xFF12070C);
const _settingsBottom = Color(0xFF32101A);
const _settingsGold = Color(0xFFE8C98D);
const _settingsText = Color(0xFFF8EEDA);
const _settingsMuted = Color(0xFFD8BE93);

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _settingsTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: _settingsGold,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          PyramidPokerStrings.get('appSettingsTitle'),
          style: textTheme.headlineSmall?.copyWith(
            color: _settingsGold,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
          ),
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: AppLocale.code,
        builder: (context, localeCode, _) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_settingsTop, _settingsBottom],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _SettingsHero(textTheme: textTheme),
                const SizedBox(height: 14),
                _SettingsPanel(
                  title: PyramidPokerStrings.get('languageTitle'),
                  subtitle: 'Language',
                  child: Column(
                    children: [
                      _SettingsRadioTile(
                        selected: localeCode == 'zh',
                        title: PyramidPokerStrings.get('languageZh'),
                        onTap: () {
                          AppLocale.set('zh');
                        },
                      ),
                      const SizedBox(height: 10),
                      _SettingsRadioTile(
                        selected: localeCode == 'en',
                        title: PyramidPokerStrings.get('languageEn'),
                        onTap: () {
                          AppLocale.set('en');
                        },
                      ),
                    ],
                  ),
                ),
                if (isDebug) const SizedBox(height: 16),
                if (isDebug)
                  _SettingsPanel(
                    title: 'Developer',
                    subtitle: 'Debug tools',
                    child: Column(
                      children: [
                        Material(
                          color: AppTheme.pageBackground.withValues(
                            alpha: 0.58,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            title: const Text('Main Menu Demo'),
                            subtitle: Text(
                              'Compare three crest-header brand directions',
                              style: textTheme.bodySmall?.copyWith(
                                color: _settingsMuted,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const MainMenuCoverDemoPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Material(
                          color: AppTheme.pageBackground.withValues(
                            alpha: 0.58,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            title: const Text('Card Render Demo'),
                            subtitle: Text(
                              'Vector vs sprite sheet rendering',
                              style: textTheme.bodySmall?.copyWith(
                                color: _settingsMuted,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const CardRenderDemoPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  final TextTheme textTheme;

  const _SettingsHero({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final isEn = AppLocale.code.value == 'en';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F1018), Color(0xFF15080D)],
        ),
        border: Border.all(color: _settingsGold.withValues(alpha: 0.26)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -26,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: _settingsGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Brand settings' : '品牌設定',
                  style: textTheme.labelLarge?.copyWith(
                    color: _settingsGold,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'POKER DRINKER',
                  style: textTheme.headlineSmall?.copyWith(
                    color: _settingsText,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEn
                      ? 'Tune language and dev tools without breaking the velvet casino tone.'
                      : '調整語言與開發工具，同時維持整體 Velvet Casino 品牌語氣。',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _settingsMuted,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
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

class _SettingsPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.panel, AppTheme.panel.withValues(alpha: 0.88)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.secondaryAccent.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: textTheme.labelLarge?.copyWith(
                color: _settingsGold,
                letterSpacing: 0.7,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(color: _settingsText),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _SettingsRadioTile extends StatelessWidget {
  final bool selected;
  final String title;
  final VoidCallback onTap;

  const _SettingsRadioTile({
    required this.selected,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.pageBackground.withValues(alpha: 0.48),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? _settingsGold
                        : _settingsGold.withValues(alpha: 0.32),
                    width: 1.6,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: _settingsGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _settingsText,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
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
