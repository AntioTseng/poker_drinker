import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main_meau/pages/main_menu_page.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '遊戲選擇',
      theme: AppTheme.lightTheme,
      home: const MainMenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
