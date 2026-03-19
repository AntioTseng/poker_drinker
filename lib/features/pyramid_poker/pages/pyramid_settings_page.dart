import 'package:flutter/material.dart';

import '../../../core/i18n/app_locale.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';

const _settingsBackgroundTop = Color(0xFF14080D);
const _settingsBackgroundBottom = Color(0xFF34111A);
const _settingsPanelTop = Color(0xFF4A1620);
const _settingsPanelBottom = Color(0xFF2A1015);
const _settingsGold = Color(0xFFE8C98D);
const _settingsText = Color(0xFFF8EEDA);
const _settingsMuted = Color(0xFFD2B89C);

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
      builder: (context, localeCode, __) {
        final textTheme = Theme.of(context).textTheme;
        final isEn = localeCode == 'en';

        return Scaffold(
          backgroundColor: _settingsBackgroundTop,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _settingsGold,
            surfaceTintColor: Colors.transparent,
            title: Text(
              PyramidPokerStrings.get('settingsTitle'),
              style: textTheme.headlineSmall?.copyWith(
                color: _settingsGold,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_settingsBackgroundTop, _settingsBackgroundBottom],
              ),
            ),
            child: Stack(
              children: [
                const _SettingsBackgroundDecor(),
                SafeArea(
                  top: false,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _settingsGold,
                      inactiveTrackColor: _settingsGold.withValues(alpha: 0.16),
                      thumbColor: _settingsGold,
                      overlayColor: _settingsGold.withValues(alpha: 0.12),
                      valueIndicatorColor: _settingsPanelTop,
                      valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
                        color: _settingsGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                18,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _settingsPanelTop,
                                    _settingsPanelBottom,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: _settingsGold.withValues(alpha: 0.22),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEn ? 'Rule tuning' : '規則微調',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: _settingsGold,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isEn
                                        ? 'Set the unit, tune each layer, and decide how punishing a tie should be.'
                                        : '先定初始單位、各層倍率，再決定撞柱時要罰多重。',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: _settingsMuted,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get(
                                'initialUnitLabel',
                              ),
                              valueLabel:
                                  '${settings.initialUnit.toStringAsFixed(1)} ${PyramidPokerStrings.get('cupUnit')}',
                              value: settings.initialUnit,
                              min: 0.5,
                              max: 5,
                              divisions: 9,
                              sliderLabel: settings.initialUnit.toStringAsFixed(
                                1,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    initialUnit: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get(
                                'layer1MultiplierLabel',
                              ),
                              valueLabel: settings.layer1Multiplier
                                  .toInt()
                                  .toString(),
                              value: settings.layer1Multiplier,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              sliderLabel: settings.layer1Multiplier
                                  .toInt()
                                  .toString(),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    layer1Multiplier: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get(
                                'layer2MultiplierLabel',
                              ),
                              valueLabel: settings.layer2Multiplier
                                  .toInt()
                                  .toString(),
                              value: settings.layer2Multiplier,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              sliderLabel: settings.layer2Multiplier
                                  .toInt()
                                  .toString(),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    layer2Multiplier: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get(
                                'layer3MultiplierLabel',
                              ),
                              valueLabel: settings.layer3Multiplier
                                  .toInt()
                                  .toString(),
                              value: settings.layer3Multiplier,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              sliderLabel: settings.layer3Multiplier
                                  .toInt()
                                  .toString(),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    layer3Multiplier: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get(
                                'layer4MultiplierLabel',
                              ),
                              valueLabel: settings.layer4Multiplier
                                  .toInt()
                                  .toString(),
                              value: settings.layer4Multiplier,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              sliderLabel: settings.layer4Multiplier
                                  .toInt()
                                  .toString(),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    layer4Multiplier: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingSliderTile(
                              context,
                              label: PyramidPokerStrings.get('tiePenaltyLabel'),
                              valueLabel:
                                  '${settings.tiePenalty.toInt()} ${PyramidPokerStrings.get('timesUnit')}',
                              value: settings.tiePenalty,
                              min: 1,
                              max: 5,
                              divisions: 4,
                              sliderLabel: settings.tiePenalty
                                  .toInt()
                                  .toString(),
                              onChanged: (value) {
                                setState(() {
                                  settings = settings.copyWith(
                                    tiePenalty: value,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                14,
                                16,
                                16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _settingsPanelTop,
                                    _settingsPanelBottom,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _settingsGold.withValues(alpha: 0.22),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    PyramidPokerStrings.get('penaltyFormula'),
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: _settingsGold,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, settings);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _settingsGold,
                                        foregroundColor: const Color(
                                          0xFF2A1015,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        PyramidPokerStrings.get(
                                          'saveSettingsButton',
                                        ),
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingSliderTile(
    BuildContext context, {
    required String label,
    required String valueLabel,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String sliderLabel,
    required ValueChanged<double> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_settingsPanelTop, _settingsPanelBottom],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _settingsGold.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.titleSmall?.copyWith(
                    color: _settingsText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _settingsGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: _settingsGold.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  valueLabel,
                  style: textTheme.labelLarge?.copyWith(
                    color: _settingsGold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: sliderLabel,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsBackgroundDecor extends StatelessWidget {
  const _SettingsBackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: -52,
            top: -26,
            child: SizedBox(
              width: 188,
              height: 188,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _settingsGold.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      width: 136,
                      height: 136,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _settingsGold.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -64,
            top: 220,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                color: _settingsGold.withValues(alpha: 0.028),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -34,
            bottom: 60,
            child: SizedBox(
              width: 154,
              height: 154,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _settingsGold.withValues(alpha: 0.045),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 20,
                    child: Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _settingsGold.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
