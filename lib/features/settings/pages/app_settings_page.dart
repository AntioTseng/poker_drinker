import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../../dev/pages/card_render_demo_page.dart';
import '../../pyramid_poker/resources/strings.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());

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
              if (isDebug) const Divider(),
              if (isDebug)
                ListTile(
                  title: const Text('Card Render Demo'),
                  subtitle: const Text('Vector vs sprite sheet rendering'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CardRenderDemoPage(),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
