import 'package:flutter/material.dart';

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
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(PyramidPokerStrings.tutorialTitle),
          content: const Text(PyramidPokerStrings.tutorialContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PyramidPokerStrings.menuTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(onPressed: _startGame, child: const Text('開始遊戲')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openSettings,
                child: const Text('設定參數'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _showTutorial,
                child: const Text('遊戲教學'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
