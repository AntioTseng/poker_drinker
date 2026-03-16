import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/theme/card_palette.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

class PyramidCardWidget extends StatelessWidget {
  final PlayingCard card;
  final int cardCount;
  final VoidCallback? onTap;

  const PyramidCardWidget({
    super.key,
    required this.card,
    required this.cardCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        PlayingCardWidget(card: card, onTap: onTap),
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CardPalette.badge,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              '$cardCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
