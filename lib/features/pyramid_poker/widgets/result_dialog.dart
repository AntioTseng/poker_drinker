import 'package:flutter/material.dart';

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
      title: const Text('結果'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(result, style: const TextStyle(fontSize: 20)),
          if (penalty > 0)
            Column(
              children: [
                Text(
                  '懲罰：$penalty 杯',
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
        ElevatedButton(onPressed: onCover, child: const Text('覆蓋到當前子牌')),
      ],
    );
  }
}
