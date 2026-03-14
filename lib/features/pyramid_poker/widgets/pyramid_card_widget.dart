import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

class PyramidCardWidget extends StatelessWidget {
  final PlayingCard card;
  final VoidCallback? onTap;

  const PyramidCardWidget({super.key, required this.card, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PlayingCardWidget(card: card, onTap: onTap);
  }
}
