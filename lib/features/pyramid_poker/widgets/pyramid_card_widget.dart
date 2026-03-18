import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

const _pyramidGold = Color(0xFFE8C98D);
const _pyramidBadgeTop = Color(0xFF5B1A24);
const _pyramidBadgeBottom = Color(0xFF341219);
const _pyramidSelectGlow = Color(0x66E8C98D);

class PyramidCardWidget extends StatelessWidget {
  final PlayingCard card;
  final int cardCount;
  final bool isSelected;
  final VoidCallback? onTap;

  const PyramidCardWidget({
    super.key,
    required this.card,
    required this.cardCount,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? _pyramidGold.withValues(alpha: 0.42)
                  : Colors.transparent,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: _pyramidSelectGlow,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: PlayingCardWidget(
            card: card,
            onTap: onTap,
            flipDuration: const Duration(milliseconds: 250),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_pyramidBadgeTop, _pyramidBadgeBottom],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _pyramidGold.withValues(alpha: 0.28)),
            ),
            child: Text(
              '$cardCount',
              style: const TextStyle(
                color: Color(0xFFF8EEDA),
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
