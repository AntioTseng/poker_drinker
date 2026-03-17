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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(biggerLabel, maxLines: 1),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onGuessSmaller,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(smallerLabel, maxLines: 1),
            ),
          ),
        ),
      ],
    );
  }
}
