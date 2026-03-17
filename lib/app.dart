import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main_meau/pages/main_menu_page.dart';
import 'features/pyramid_poker/resources/strings.dart';
import 'core/i18n/app_locale.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.code,
      builder: (context, localeCode, _) {
        return FutureBuilder<void>(
          future: PyramidPokerStrings.load(localeCode),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                debugShowCheckedModeBanner: false,
              );
            }

            return MaterialApp(
              title: PyramidPokerStrings.get('appTitle'),
              theme: AppTheme.lightTheme,
              themeAnimationDuration: Duration.zero,
              home: const MainMenuPage(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
