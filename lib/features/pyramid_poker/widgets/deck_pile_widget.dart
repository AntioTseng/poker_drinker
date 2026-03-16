import 'package:flutter/material.dart';

import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/theme/card_palette.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

class DeckPileWidget extends StatelessWidget {
  final List<PlayingCard> deck;
  final PlayingCard? currentDeckCard;
  final VoidCallback? onCurrentDeckCardFlipCompleted;
  final GlobalKey? currentDeckCardAnchorKey;
  final GlobalKey? pileAnchorKey;

  const DeckPileWidget({
    super.key,
    required this.deck,
    required this.currentDeckCard,
    this.onCurrentDeckCardFlipCompleted,
    this.currentDeckCardAnchorKey,
    this.pileAnchorKey,
  });

  @override
  Widget build(BuildContext context) {
    final double pileWidth = 50;
    final double pileHeight = 70 + deck.length * 2.0;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        key: pileAnchorKey,
        width: pileWidth,
        height: pileHeight,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < deck.length; i++)
              Positioned(
                top: i * 2.0,
                child: Container(
                  width: pileWidth,
                  height: 70,
                  decoration: BoxDecoration(
                    color: CardPalette.cardBack,
                    border: Border.all(color: CardPalette.motherPile),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            if (currentDeckCard != null)
              Positioned(
                top: deck.length * 2.0,
                child: Container(
                  key: currentDeckCardAnchorKey,
                  child: PlayingCardWidget(
                    key: ValueKey(currentDeckCard),
                    card: currentDeckCard!,
                    flipDuration: const Duration(milliseconds: 500),
                    animateOnMountIfFaceUp: true,
                    onFlipCompleted: onCurrentDeckCardFlipCompleted,
                  ),
                ),
              ),
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
                  '${deck.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
