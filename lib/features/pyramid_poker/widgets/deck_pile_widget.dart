import 'package:flutter/material.dart';

import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

class DeckPileWidget extends StatelessWidget {
  final List<PlayingCard> deck;
  final PlayingCard? currentDeckCard;

  const DeckPileWidget({
    super.key,
    required this.deck,
    required this.currentDeckCard,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < deck.length; i++)
          Positioned(
            top: i * 2.0,
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        if (currentDeckCard != null)
          Positioned(
            top: deck.length * 2.0,
            child: PlayingCardWidget(card: currentDeckCard!),
          ),
      ],
    );
  }
}
