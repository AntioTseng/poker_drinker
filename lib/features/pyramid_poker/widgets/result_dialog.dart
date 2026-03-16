import 'package:flutter/material.dart';

import '../resources/strings.dart';

class ResultDialog extends StatelessWidget {
  final String result;
  final int penalty;
  final String penaltyExplain;
  final VoidCallback onCover;

  const ResultDialog({
    super.key,
    required this.result,
    required this.penalty,
    required this.penaltyExplain,
    required this.onCover,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(PyramidPokerStrings.get('resultDialogTitle')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(result, style: const TextStyle(fontSize: 20)),
          if (penalty > 0)
            Column(
              children: [
                Text(
                  PyramidPokerStrings.format('penaltyLine', {
                    'penalty': penalty,
                    'cup': PyramidPokerStrings.get('cupUnit'),
                  }),
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                Text(
                  penaltyExplain,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: onCover,
          child: Text(PyramidPokerStrings.get('coverSelectedCardButton')),
        ),
      ],
    );
  }
}
