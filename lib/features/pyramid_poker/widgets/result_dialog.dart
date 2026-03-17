import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../resources/strings.dart';

class ResultDialog extends StatelessWidget {
  final String result;
  final double penalty;
  final String penaltyExplain;
  final VoidCallback onCover;

  const ResultDialog({
    super.key,
    required this.result,
    required this.penalty,
    required this.penaltyExplain,
    required this.onCover,
  });

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      title: Text(PyramidPokerStrings.get('resultDialogTitle')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.pageBackground.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.secondaryAccent.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppTheme.ink,
                    ),
                  ),
                  if (penalty > 0) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E5DE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                            0xFFD89B86,
                          ).withValues(alpha: 0.55),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            PyramidPokerStrings.format('penaltyLine', {
                              'penalty': _formatNumber(penalty),
                              'cup': PyramidPokerStrings.get('cupUnit'),
                            }),
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF9C4B35),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            penaltyExplain,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF9C4B35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onCover,
            child: Text(PyramidPokerStrings.get('coverSelectedCardButton')),
          ),
        ),
      ],
    );
  }
}
