import 'package:flutter/material.dart';

import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/theme/card_palette.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';

const _pileGold = Color(0xFFE8C98D);
const _pileText = Color(0xFFF8EEDA);
const _pileBadgeTop = Color(0xFF5B1A24);
const _pileBadgeBottom = Color(0xFF341219);

class DeckPileWidget extends StatelessWidget {
  final List<PlayingCard> deck;
  final PlayingCard? currentDeckCard;
  final VoidCallback? onCurrentDeckCardFlipCompleted;
  final GlobalKey? currentDeckCardAnchorKey;
  final GlobalKey? pileAnchorKey;
  final double cardFaceWidth;
  final double cardFaceHeight;
  final double stackOffset;

  const DeckPileWidget({
    super.key,
    required this.deck,
    required this.currentDeckCard,
    this.onCurrentDeckCardFlipCompleted,
    this.currentDeckCardAnchorKey,
    this.pileAnchorKey,
    this.cardFaceWidth = 50,
    this.cardFaceHeight = 70,
    this.stackOffset = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final double pileWidth = cardFaceWidth + 8;
    final double pileHeight = cardFaceHeight + 8 + deck.length * stackOffset;

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
                top: i * stackOffset,
                child: CustomPaint(
                  painter: _PileBackPainter(),
                  child: SizedBox(width: pileWidth, height: cardFaceHeight + 8),
                ),
              ),
            if (currentDeckCard != null)
              Positioned(
                top: deck.length * stackOffset,
                child: Container(
                  key: currentDeckCardAnchorKey,
                  child: PlayingCardWidget(
                    key: ValueKey(currentDeckCard),
                    card: currentDeckCard!,
                    flipDuration: const Duration(milliseconds: 500),
                    animateOnMountIfFaceUp: true,
                    onFlipCompleted: onCurrentDeckCardFlipCompleted,
                    width: cardFaceWidth,
                    height: cardFaceHeight,
                  ),
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
                    colors: [_pileBadgeTop, _pileBadgeBottom],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _pileGold.withValues(alpha: 0.28)),
                ),
                child: Text(
                  '${deck.length}',
                  style: const TextStyle(
                    color: _pileText,
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

class _PileBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(6),
    );
    canvas.drawRRect(rrect, Paint()..color = CardPalette.cardBack);

    final inset = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(3.5),
      const Radius.circular(4.5),
    );
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(
      inset,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = CardPalette.cardBackPattern.withValues(alpha: 0.48),
    );

    const tile = 9.0;
    final parquetPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = CardPalette.cardBackPattern.withValues(alpha: 0.3);
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..color = CardPalette.cardBackPatternSoft.withValues(alpha: 0.24);

    for (double y = 8; y <= size.height - 8; y += tile) {
      for (double x = 7; x <= size.width - 7; x += tile) {
        final path = Path()
          ..moveTo(x + tile * 0.5, y)
          ..lineTo(x + tile, y + tile * 0.5)
          ..lineTo(x + tile * 0.5, y + tile)
          ..lineTo(x, y + tile * 0.5)
          ..close();
        canvas.drawPath(path, parquetPaint);
      }
    }

    for (double y = 12; y <= size.height - 12; y += 10) {
      final phase = ((y / 10).floor().isEven ? 0.0 : 4.0);
      for (double x = 10 + phase; x <= size.width - 16; x += 12) {
        final curve = Path()
          ..moveTo(x, y)
          ..quadraticBezierTo(x + 4, y - 1.4, x + 8, y)
          ..quadraticBezierTo(x + 11, y + 1.4, x + 14, y);
        canvas.drawPath(curve, grainPaint);
      }
    }

    final center = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = CardPalette.cardBackPattern.withValues(alpha: 0.56);
    canvas.drawCircle(center, size.shortestSide * 0.18, ringPaint);
    canvas.drawCircle(center, size.shortestSide * 0.11, ringPaint);

    canvas.restore();
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = CardPalette.motherPile,
    );
  }

  @override
  bool shouldRepaint(covariant _PileBackPainter oldDelegate) => false;
}
