import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/i18n/app_locale.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';
import 'pyramid_game_page.dart';
import 'pyramid_settings_page.dart';

const _menuTop = Color(0xFF12070C);
const _menuBottom = Color(0xFF32101A);
const _menuGold = Color(0xFFE8C98D);
const _menuText = Color(0xFFF8EEDA);
const _menuMuted = Color(0xFFD8BE93);

class PyramidMenuPage extends StatefulWidget {
  const PyramidMenuPage({super.key});

  @override
  State<PyramidMenuPage> createState() => _PyramidMenuPageState();
}

class _PyramidMenuPageState extends State<PyramidMenuPage> {
  PyramidSettings settings = const PyramidSettings();

  Future<void> _openSettings() async {
    final updatedSettings = await Navigator.push<PyramidSettings>(
      context,
      MaterialPageRoute(
        builder: (context) => PyramidSettingsPage(initialSettings: settings),
      ),
    );

    if (updatedSettings != null && mounted) {
      setState(() {
        settings = updatedSettings;
      });
    }
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _GameLaunchCoverPage(settings: settings),
      ),
    );
  }

  void _showTutorial() {
    final String localeCode = AppLocale.code.value;
    final String safeLocaleCode = (localeCode == 'en' || localeCode == 'zh')
        ? localeCode
        : 'zh';
    final String assetPath =
        'assets/tutorial/pyramid_poker_tutorial_$safeLocaleCode.md';

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(PyramidPokerStrings.get('tutorialTitle')),
          content: FutureBuilder<String>(
            future: rootBundle.loadString(assetPath),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: SelectableText(
                      PyramidPokerStrings.get('tutorialContent'),
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const SizedBox(
                  width: 420,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: SelectableText(
                    snapshot.data!,
                    style: const TextStyle(height: 1.4),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(PyramidPokerStrings.get('closeButton')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.code,
      builder: (context, localeCode, child) {
        final textTheme = Theme.of(context).textTheme;
        final isEn = localeCode == 'en';

        return Scaffold(
          backgroundColor: _menuTop,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _menuGold,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              PyramidPokerStrings.get('menuTitle'),
              style: textTheme.titleMedium?.copyWith(
                color: _menuGold,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
              ),
            ),
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_menuTop, _menuBottom],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      _PyramidHero(textTheme: textTheme, isEn: isEn),
                      const SizedBox(height: 14),
                      _MenuActionCard(
                        title: PyramidPokerStrings.get('startGameButton'),
                        subtitle: isEn
                            ? 'Launch the headline round and bring the table in.'
                            : '直接開啟今晚主打的主桌局。',
                        icon: Icons.play_arrow_rounded,
                        highlighted: true,
                        onTap: _startGame,
                      ),
                      const SizedBox(height: 10),
                      _MenuActionCard(
                        title: PyramidPokerStrings.get('openSettingsButton'),
                        subtitle: isEn
                            ? 'Tune the rule pressure before the round starts.'
                            : '在開局前微調規則與壓力節奏。',
                        icon: Icons.tune_rounded,
                        onTap: _openSettings,
                      ),
                      const SizedBox(height: 10),
                      _MenuActionCard(
                        title: PyramidPokerStrings.get('tutorialButton'),
                        subtitle: isEn
                            ? 'Read the flow before anyone touches the deck.'
                            : '先看流程，再讓整桌一起進場。',
                        icon: Icons.menu_book_rounded,
                        outlined: true,
                        onTap: _showTutorial,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GameLaunchCoverPage extends StatefulWidget {
  final PyramidSettings settings;

  const _GameLaunchCoverPage({required this.settings});

  @override
  State<_GameLaunchCoverPage> createState() => _GameLaunchCoverPageState();
}

class _GameLaunchCoverPageState extends State<_GameLaunchCoverPage> {
  @override
  void initState() {
    super.initState();
    _launch();
  }

  Future<void> _launch() async {
    await Future<void>.delayed(const Duration(milliseconds: 950));
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: PyramidGamePage(settings: widget.settings),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEn = AppLocale.code.value == 'en';

    return Scaffold(
      backgroundColor: _menuTop,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_menuTop, _menuBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: _menuGold.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -70,
              bottom: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF8C2741).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF311019), Color(0xFF14080D)],
                        ),
                        border: Border.all(
                          color: _menuGold.withValues(alpha: 0.28),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 28,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'Now dealing' : '正在發牌',
                            style: textTheme.labelLarge?.copyWith(
                              color: _menuGold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.9,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'POKER\nDRINKER',
                            style: textTheme.displaySmall?.copyWith(
                              color: _menuText,
                              fontWeight: FontWeight.w900,
                              height: 0.92,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isEn
                                ? 'Set the table. Stack the pyramid. Let the round begin.'
                                : '主桌就位，金字塔開始疊起，今晚這一局準備開場。',
                            style: textTheme.bodyLarge?.copyWith(
                              color: _menuMuted,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: _menuGold.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: _menuGold.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  PyramidPokerStrings.get('gameTitle'),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: _menuGold,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _menuGold,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}

class _PyramidHero extends StatelessWidget {
  final TextTheme textTheme;
  final bool isEn;

  const _PyramidHero({required this.textTheme, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF311019), Color(0xFF17080D)],
        ),
        border: Border.all(color: _menuGold.withValues(alpha: 0.26)),
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
            right: -22,
            top: -18,
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: _menuGold.withValues(alpha: 0.1),
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
                  isEn ? 'Tonight\'s pick' : '今晚主打',
                  style: textTheme.labelLarge?.copyWith(
                    color: _menuGold,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  PyramidPokerStrings.get('gameTitle'),
                  style: textTheme.headlineSmall?.copyWith(
                    color: _menuText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  PyramidPokerStrings.get('gameCardPyramidSubtitle'),
                  style: textTheme.bodyMedium?.copyWith(
                    color: _menuMuted,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _menuGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _menuGold.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Text(
                    PyramidPokerStrings.get('gamePyramidPlayers'),
                    style: textTheme.labelLarge?.copyWith(
                      color: _menuGold,
                      fontWeight: FontWeight.w800,
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
}

class _MenuActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;
  final bool outlined;

  const _MenuActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = highlighted ? _menuGold : const Color(0xFFD09D62);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            gradient: outlined
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: highlighted
                        ? [const Color(0xFF571726), const Color(0xFF2A0F16)]
                        : [const Color(0xFF2A1518), const Color(0xFF211015)],
                  ),
            color: outlined ? Colors.white.withValues(alpha: 0.04) : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: accent.withValues(alpha: highlighted ? 0.42 : 0.22),
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.14),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accent.withValues(alpha: 0.18)),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          color: _menuText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: _menuMuted,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
