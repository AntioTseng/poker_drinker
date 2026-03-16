import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/i18n/app_locale.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';
import 'pyramid_game_page.dart';
import 'pyramid_settings_page.dart';

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
        builder: (context) => PyramidGamePage(settings: settings),
      ),
    );
  }

  void _showTutorial() {
    final String localeCode = AppLocale.code.value;
    final String safeLocaleCode = (localeCode == 'en' || localeCode == 'zh')
        ? localeCode
        : 'zh';
    final String assetPath =
        'assets/tutorial/pyramid_poker_tutorial_${safeLocaleCode}.md';

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
      builder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(title: Text(PyramidPokerStrings.get('menuTitle'))),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _startGame,
                    child: Text(PyramidPokerStrings.get('startGameButton')),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _openSettings,
                    child: Text(PyramidPokerStrings.get('openSettingsButton')),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showTutorial,
                    child: Text(PyramidPokerStrings.get('tutorialButton')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
