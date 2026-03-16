import 'package:flutter/material.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';
import '../../pyramid_poker/resources/strings.dart';
import '../../settings/pages/app_settings_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
