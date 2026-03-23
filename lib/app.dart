import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import 'core/theme/app_theme.dart';
import 'core/i18n/app_locale.dart';
import 'features/main_meau/pages/main_menu_page.dart';
import 'features/pyramid_poker/resources/strings.dart';
import 'core/update/update_service.dart';

const _launchTop = Color(0xFF11070C);
const _launchBottom = Color(0xFF32101A);
const _launchPanelTop = Color(0xFF301018);
const _launchPanelBottom = Color(0xFF15080D);
const _launchGold = Color(0xFFE8C98D);
const _launchText = Color(0xFFF8EEDA);
const _launchMuted = Color(0xFFD8BE93);
const _minimumLaunchDisplay = Duration(seconds: 3);

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  @override
  void initState() {
    super.initState();
    // Trigger Android in-app update check after first frame to ensure context/activity is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.logLocalVersion();
      UpdateService.checkAndPerformAndroidInAppUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.code,
      builder: (context, localeCode, _) {
        return FutureBuilder<void>(
          future: Future.wait<void>([
            PyramidPokerStrings.load(localeCode),
            Future<void>.delayed(_minimumLaunchDisplay),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                home: _AppLaunchLoadingPage(localeCode: localeCode),
                debugShowCheckedModeBanner: false,
              );
            }

            return UpgradeAlert(
              child: MaterialApp(
                title: PyramidPokerStrings.get('appTitle'),
                locale: Locale(localeCode),
                theme: AppTheme.lightTheme,
                themeAnimationDuration: Duration.zero,
                home: const MainMenuPage(),
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}

class _AppLaunchLoadingPage extends StatefulWidget {
  final String localeCode;

  const _AppLaunchLoadingPage({required this.localeCode});

  @override
  State<_AppLaunchLoadingPage> createState() => _AppLaunchLoadingPageState();
}

class _AppLaunchLoadingPageState extends State<_AppLaunchLoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEn = widget.localeCode == 'en';

    return Scaffold(
      backgroundColor: _launchTop,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_launchTop, _launchBottom],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final drift = (_controller.value - 0.5) * 14;
            final glow = 0.08 + (_controller.value * 0.08);

            return Stack(
              children: [
                Positioned(
                  top: -90,
                  right: -60,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: _launchGold.withValues(alpha: glow),
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
                      color: const Color(0xFF8C2741).withValues(alpha: 0.18),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_launchPanelTop, _launchPanelBottom],
                            ),
                            border: Border.all(
                              color: _launchGold.withValues(alpha: 0.28),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 28,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 28,
                                top: 22 + drift,
                                child: _LaunchCard(
                                  label: 'K',
                                  accent: Colors.white.withValues(alpha: 0.16),
                                  fill: Colors.white.withValues(alpha: 0.03),
                                  width: 72,
                                  height: 104,
                                ),
                              ),
                              Positioned(
                                right: 70,
                                top: 42 - drift,
                                child: _LaunchCard(
                                  label: 'A',
                                  accent: _launchGold.withValues(alpha: 0.72),
                                  fill: _launchGold.withValues(alpha: 0.08),
                                  width: 78,
                                  height: 112,
                                  highlighted: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  24,
                                  24,
                                  22,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEn ? 'Preparing the table' : '正在佈置今晚牌桌',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: _launchGold,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.9,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'POKER\nDRINKER',
                                      style: textTheme.displaySmall?.copyWith(
                                        color: _launchText,
                                        fontWeight: FontWeight.w900,
                                        height: 0.92,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 220,
                                      ),
                                      child: Text(
                                        isEn
                                            ? 'Pour the mood, shuffle the deck, and bring tonight\'s round to the table.'
                                            : '先把氣氛倒滿、把牌洗好，今晚這一局馬上開桌。',
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: _launchMuted,
                                          height: 1.42,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                            child: SizedBox(
                                              height: 4,
                                              child: LinearProgressIndicator(
                                                backgroundColor: Colors.white
                                                    .withValues(alpha: 0.08),
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(_launchGold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        _LoadingDots(
                                          progress: _controller.value,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

class _LaunchCard extends StatelessWidget {
  final String label;
  final Color accent;
  final Color fill;
  final double width;
  final double height;
  final bool highlighted;

  const _LaunchCard({
    required this.label,
    required this.accent,
    required this.fill,
    required this.width,
    required this.height,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: highlighted ? -0.14 : 0.12,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: fill,
          border: Border.all(color: accent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.72)),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
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

class _LoadingDots extends StatelessWidget {
  final double progress;

  const _LoadingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    final activeIndex = (progress * 3).floor() % 3;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(3, (index) {
        final isActive = index == activeIndex;

        return Padding(
          padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: isActive ? 10 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? _launchGold
                  : _launchGold.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
