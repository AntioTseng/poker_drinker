import 'package:flutter/material.dart';
import '../../pyramid_poker/pages/pyramid_menu_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('選擇遊戲')),
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
              child: const Text('金字塔撲克牌'),
            ),
          ],
        ),
      ),
    );
  }
}
