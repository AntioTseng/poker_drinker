import 'package:flutter/material.dart';

import '../models/playing_card.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 70,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: card.isFaceUp ? Colors.white : Colors.blue,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(6),
        ),
        child: card.isFaceUp
            ? Center(
                child: Text(
                  '${card.rankLabel}${getSuitSymbol()}',
                  style: TextStyle(
                    fontSize: 18,
                    color: getSuitColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
