import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../../../core/theme/app_theme.dart';
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

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(PyramidPokerStrings.get('appSettingsTitle'))),
      body: ValueListenableBuilder<String>(
        valueListenable: AppLocale.code,
        builder: (context, localeCode, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SettingsPanel(
                title: PyramidPokerStrings.get('languageTitle'),
                subtitle: 'Language',
                child: Column(
                  children: [
                    _SettingsRadioTile(
                      value: 'zh',
                      groupValue: localeCode,
                      title: PyramidPokerStrings.get('languageZh'),
                      onChanged: (value) {
                        if (value == null) return;
                        AppLocale.set(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    _SettingsRadioTile(
                      value: 'en',
                      groupValue: localeCode,
                      title: PyramidPokerStrings.get('languageEn'),
                      onChanged: (value) {
                        if (value == null) return;
                        AppLocale.set(value);
                      },
                    ),
                  ],
                ),
              ),
              if (isDebug) const SizedBox(height: 16),
              if (isDebug)
                _SettingsPanel(
                  title: 'Developer',
                  subtitle: 'Debug tools',
                  child: Material(
                    color: AppTheme.pageBackground.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(18),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      title: const Text('Card Render Demo'),
                      subtitle: Text(
                        'Vector vs sprite sheet rendering',
                        style: textTheme.bodySmall,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CardRenderDemoPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.secondaryAccent.withValues(alpha: 0.16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: textTheme.labelLarge?.copyWith(
                color: AppTheme.secondaryAccent,
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _SettingsRadioTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final ValueChanged<String?> onChanged;

  const _SettingsRadioTile({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.pageBackground.withValues(alpha: 0.62),
      borderRadius: BorderRadius.circular(18),
      child: RadioListTile<String>(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        value: value,
        groupValue: groupValue,
        title: Text(title),
        activeColor: AppTheme.primaryAccent,
        onChanged: onChanged,
      ),
    );
  }
}
