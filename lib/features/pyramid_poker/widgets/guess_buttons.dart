import 'package:flutter/material.dart';

const _guessGold = Color(0xFFE8C98D);
const _guessText = Color(0xFFF8EEDA);
const _guessPanelTop = Color(0xFF5A1A24);
const _guessPanelBottom = Color(0xFF311117);
const _guessSecondaryTop = Color(0xFF4B1620);
const _guessSecondaryBottom = Color(0xFF2A1015);

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
          child: _GuessActionButton(
            onPressed: onGuessBigger,
            icon: Icons.keyboard_double_arrow_up_rounded,
            label: biggerLabel,
            colors: const [_guessPanelTop, _guessPanelBottom],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GuessActionButton(
            onPressed: onGuessSmaller,
            icon: Icons.keyboard_double_arrow_down_rounded,
            label: smallerLabel,
            colors: const [_guessSecondaryTop, _guessSecondaryBottom],
          ),
        ),
      ],
    );
  }
}

class _GuessActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final List<Color> colors;

  const _GuessActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: enabled
                  ? colors
                  : colors
                        .map((color) => color.withValues(alpha: 0.45))
                        .toList(),
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _guessGold.withValues(alpha: 0.16)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: enabled
                        ? _guessGold
                        : _guessText.withValues(alpha: 0.42),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: enabled
                          ? _guessText
                          : _guessText.withValues(alpha: 0.42),
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
