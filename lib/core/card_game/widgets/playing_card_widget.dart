import 'package:flutter/material.dart';

import '../models/playing_card.dart';
import '../theme/card_palette.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final VoidCallback? onTap;

  const PlayingCardWidget({super.key, required this.card, this.onTap});

  Color getSuitColor() {
    if (card.suit == Suit.hearts || card.suit == Suit.diamonds) {
      return Colors.red;
    }

    return Colors.black;
  }

  String getSuitSymbol() {
    switch (card.suit) {
      case Suit.spades:
        return '♠';
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: 50,
          height: 70,
          child: CustomPaint(
            painter: _VersionCPainter(
              theme: theme,
              isFaceUp: card.isFaceUp,
              rankText: card.rankLabel,
              suitSymbol: getSuitSymbol(),
              suitColor: getSuitColor(),
            ),
          ),
        ),
      ),
    );
  }
}

class _VersionCPainter extends CustomPainter {
  final ThemeData theme;
  final bool isFaceUp;
  final String rankText;
  final String suitSymbol;
  final Color suitColor;

  _VersionCPainter({
    required this.theme,
    required this.isFaceUp,
    required this.rankText,
    required this.suitSymbol,
    required this.suitColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(6),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;

    if (!isFaceUp) {
      canvas.drawRRect(rrect, Paint()..color = CardPalette.cardBack);
      canvas.drawRRect(rrect, borderPaint);
      return;
    }

    canvas.drawRRect(rrect, Paint()..color = Colors.white);
    canvas.drawRRect(rrect, borderPaint);

    final fontSize = size.shortestSide * 0.36;
    final centerStyle =
        theme.textTheme.titleLarge?.copyWith(
          color: suitColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ) ??
        TextStyle(
          color: suitColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        );

    final centerPainter = TextPainter(
      text: TextSpan(text: '$suitSymbol$rankText', style: centerStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final centerOffset = Offset(
      (size.width - centerPainter.width) / 2,
      (size.height - centerPainter.height) / 2,
    );
    centerPainter.paint(canvas, centerOffset);
  }

  @override
  bool shouldRepaint(covariant _VersionCPainter oldDelegate) {
    return oldDelegate.theme != theme ||
        oldDelegate.isFaceUp != isFaceUp ||
        oldDelegate.rankText != rankText ||
        oldDelegate.suitSymbol != suitSymbol ||
        oldDelegate.suitColor != suitColor;
  }
}
