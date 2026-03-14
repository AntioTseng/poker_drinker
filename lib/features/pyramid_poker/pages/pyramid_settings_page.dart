import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text(PyramidPokerStrings.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('初始單位: ${settings.initialUnit.toStringAsFixed(1)} 杯'),
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
            Text('第1層倍數: ${settings.layer1Multiplier.toInt()}'),
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
            Text('第2層倍數: ${settings.layer2Multiplier.toInt()}'),
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
            Text('第3層倍數: ${settings.layer3Multiplier.toInt()}'),
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
            Text('第4層倍數: ${settings.layer4Multiplier.toInt()}'),
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
            Text('撞柱懲罰: ${settings.tiePenalty.toInt()} 倍'),
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
            const Text(
              '懲罰杯數算法: 層數倍數 x 張牌數 x 初始單位 x 撞柱懲罰',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, settings);
              },
              child: const Text('儲存設定'),
            ),
          ],
        ),
      ),
    );
  }
}
