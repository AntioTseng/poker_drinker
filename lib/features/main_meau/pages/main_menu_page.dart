import 'package:flutter/material.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';
import '../../../core/theme/app_theme.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTheme.panel,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.secondaryAccent.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          PyramidPokerStrings.get('mainMenuTitle'),
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppTheme.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 56,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryAccent,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          PyramidPokerStrings.get('gameTitle'),
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppTheme.subtleInk,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PyramidMenuPage(),
                                ),
                              );
                            },
                            child: Text(PyramidPokerStrings.get('gameTitle')),
                          ),
                        ),
                      ],
                    ),
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
