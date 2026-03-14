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
        ElevatedButton(onPressed: onGuessBigger, child: Text(biggerLabel)),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: onGuessSmaller, child: Text(smallerLabel)),
      ],
    );
  }
}
