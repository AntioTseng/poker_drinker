import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../../pyramid_poker/resources/strings.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(PyramidPokerStrings.get('appSettingsTitle'))),
      body: ValueListenableBuilder<String>(
        valueListenable: AppLocale.code,
        builder: (context, localeCode, _) {
          return ListView(
            children: [
              ListTile(title: Text(PyramidPokerStrings.get('languageTitle'))),
              RadioListTile<String>(
                value: 'zh',
                groupValue: localeCode,
                title: Text(PyramidPokerStrings.get('languageZh')),
                onChanged: (value) {
                  if (value == null) return;
                  AppLocale.set(value);
                },
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: localeCode,
                title: Text(PyramidPokerStrings.get('languageEn')),
                onChanged: (value) {
                  if (value == null) return;
                  AppLocale.set(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
