import 'package:flutter/material.dart';

class GuessButtons extends StatelessWidget {
  final String biggerLabel;
  final String smallerLabel;
  final VoidCallback? onGuessBigger;
  final VoidCallback? onGuessSmaller;

  const GuessButtons({
    super.key,
    required this.biggerLabel,
    required this.smallerLabel,
    required this.onGuessBigger,
    required this.onGuessSmaller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onGuessBigger,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard_double_arrow_up_rounded, size: 22),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onGuessSmaller,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard_double_arrow_down_rounded, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
