import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';

class PyramidSettingsPage extends StatefulWidget {
  final PyramidSettings initialSettings;

  const PyramidSettingsPage({
    super.key,
    this.initialSettings = const PyramidSettings(),
  });

  @override
  State<PyramidSettingsPage> createState() => _PyramidSettingsPageState();
}

class _PyramidSettingsPageState extends State<PyramidSettingsPage> {
  late PyramidSettings settings;

  @override
  void initState() {
    super.initState();
    settings = widget.initialSettings;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocale.code,
      builder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(title: Text(PyramidPokerStrings.get('settingsTitle'))),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${PyramidPokerStrings.get('initialUnitLabel')}: ${settings.initialUnit.toStringAsFixed(1)} ${PyramidPokerStrings.get('cupUnit')}',
                ),
                Slider(
                  value: settings.initialUnit,
                  min: 0.5,
                  max: 5,
                  divisions: 9,
                  label: settings.initialUnit.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(initialUnit: value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  '${PyramidPokerStrings.get('layer1MultiplierLabel')}: ${settings.layer1Multiplier.toInt()}',
                ),
                Slider(
                  value: settings.layer1Multiplier,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: settings.layer1Multiplier.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(layer1Multiplier: value);
                    });
                  },
                ),
                Text(
                  '${PyramidPokerStrings.get('layer2MultiplierLabel')}: ${settings.layer2Multiplier.toInt()}',
                ),
                Slider(
                  value: settings.layer2Multiplier,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: settings.layer2Multiplier.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(layer2Multiplier: value);
                    });
                  },
                ),
                Text(
                  '${PyramidPokerStrings.get('layer3MultiplierLabel')}: ${settings.layer3Multiplier.toInt()}',
                ),
                Slider(
                  value: settings.layer3Multiplier,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: settings.layer3Multiplier.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(layer3Multiplier: value);
                    });
                  },
                ),
                Text(
                  '${PyramidPokerStrings.get('layer4MultiplierLabel')}: ${settings.layer4Multiplier.toInt()}',
                ),
                Slider(
                  value: settings.layer4Multiplier,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: settings.layer4Multiplier.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(layer4Multiplier: value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  '${PyramidPokerStrings.get('tiePenaltyLabel')}: ${settings.tiePenalty.toInt()} ${PyramidPokerStrings.get('timesUnit')}',
                ),
                Slider(
                  value: settings.tiePenalty,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: settings.tiePenalty.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      settings = settings.copyWith(tiePenalty: value);
                    });
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  PyramidPokerStrings.get('penaltyFormula'),
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, settings);
                  },
                  child: Text(PyramidPokerStrings.get('saveSettingsButton')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
