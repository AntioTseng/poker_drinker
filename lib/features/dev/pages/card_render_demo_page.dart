import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/theme/card_palette.dart';

enum CardFaceLayout {
  twoCorners,
  singleCorner,
  singleCornerWithCenteredRankSuit,
  singleCornerWithCenteredSuitWatermark,
  centeredSuitThenRank,
}

class CardRenderDemoPage extends StatefulWidget {
  const CardRenderDemoPage({super.key});

  @override
  State<CardRenderDemoPage> createState() => _CardRenderDemoPageState();
}

class _CardRenderDemoPageState extends State<CardRenderDemoPage> {
  static const _cardLogicalSize = Size(60, 84);

  late final List<PlayingCard> _sampleCards = <PlayingCard>[
    PlayingCard(suit: Suit.spades, rank: 1, isFaceUp: true),
    PlayingCard(suit: Suit.hearts, rank: 7, isFaceUp: true),
    PlayingCard(suit: Suit.diamonds, rank: 13, isFaceUp: true),
    PlayingCard(suit: Suit.clubs, rank: 2, isFaceUp: false),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Card Render Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              '同一頁面提供 5 種「向量繪圖」牌面版本：\n'
              '1) 目前版本：上下各一組角標（倒過來再畫一次）\n'
              '2) 版本 A：只有正面角標（沒有倒過來的花色數字）\n'
              '3) 版本 B：只有正面角標 + 中間淡花色（沒有倒過來的花色數字）\n'
              '4) 版本 C：版本 A + 數字與花色置中（沒有倒過來的花色數字）\n'
              '5) 版本 D：版本 C 但花色與數字對調（例如 ♠A；沒有倒過來的花色數字）',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _RenderColumn(
              title: '目前版本（上下各一組角標）',
              cards: _sampleCards,
              builder: (card) => SizedBox(
                width: _cardLogicalSize.width,
                height: _cardLogicalSize.height,
                child: VectorPlayingCardWidget(
                  card: card,
                  layout: CardFaceLayout.twoCorners,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _RenderColumn(
              title: '版本 A（只有正面角標）',
              cards: _sampleCards,
              builder: (card) => SizedBox(
                width: _cardLogicalSize.width,
                height: _cardLogicalSize.height,
                child: VectorPlayingCardWidget(
                  card: card,
                  layout: CardFaceLayout.singleCorner,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _RenderColumn(
              title: '版本 B（正面角標 + 中間淡花色）',
              cards: _sampleCards,
              builder: (card) => SizedBox(
                width: _cardLogicalSize.width,
                height: _cardLogicalSize.height,
                child: VectorPlayingCardWidget(
                  card: card,
                  layout: CardFaceLayout.singleCornerWithCenteredSuitWatermark,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _RenderColumn(
              title: '版本 C（版本 A + 數字與花色置中）',
              cards: _sampleCards,
              builder: (card) => SizedBox(
                width: _cardLogicalSize.width,
                height: _cardLogicalSize.height,
                child: VectorPlayingCardWidget(
                  card: card,
                  layout: CardFaceLayout.singleCornerWithCenteredRankSuit,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _RenderColumn(
              title: '版本 D（版本 C 但花色與數字對調）',
              cards: _sampleCards,
              builder: (card) => SizedBox(
                width: _cardLogicalSize.width,
                height: _cardLogicalSize.height,
                child: VectorPlayingCardWidget(
                  card: card,
                  layout: CardFaceLayout.centeredSuitThenRank,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef _CardWidgetBuilder = Widget Function(PlayingCard card);

class _RenderColumn extends StatelessWidget {
  final String title;
  final List<PlayingCard> cards;
  final _CardWidgetBuilder builder;

  const _RenderColumn({
    required this.title,
    required this.cards,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards.map(builder).toList(growable: false),
        ),
      ],
    );
  }
}

class VectorPlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final CardFaceLayout layout;

  const VectorPlayingCardWidget({
    super.key,
    required this.card,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VectorCardPainter(
        card: card,
        theme: Theme.of(context),
        layout: layout,
      ),
    );
  }
}

class _VectorCardPainter extends CustomPainter {
  final PlayingCard card;
  final ThemeData theme;
  final CardFaceLayout layout;

  _VectorCardPainter({
    required this.card,
    required this.theme,
    required this.layout,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;

    if (!card.isFaceUp) {
      final backPaint = Paint()..color = CardPalette.cardBack;
      canvas.drawRRect(rrect, backPaint);
      canvas.drawRRect(rrect, borderPaint);
      return;
    }

    canvas.drawRRect(rrect, Paint()..color = Colors.white);
    canvas.drawRRect(rrect, borderPaint);

    final suitSymbol = _suitSymbol(card.suit);
    final rankText = card.rankLabel;
    final suitColor = _suitColor(card.suit);

    final cornerStyle =
        theme.textTheme.titleMedium?.copyWith(
          color: suitColor,
          fontWeight: FontWeight.bold,
        ) ??
        TextStyle(color: suitColor, fontWeight: FontWeight.bold, fontSize: 16);

    final cornerRankSuitPainter = TextPainter(
      text: TextSpan(text: '$rankText$suitSymbol', style: cornerStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    switch (layout) {
      case CardFaceLayout.twoCorners:
        cornerRankSuitPainter.paint(canvas, const Offset(6, 6));
        canvas.save();
        canvas.translate(size.width, size.height);
        canvas.rotate(math.pi);
        cornerRankSuitPainter.paint(canvas, const Offset(6, 6));
        canvas.restore();
        break;

      case CardFaceLayout.singleCorner:
        cornerRankSuitPainter.paint(canvas, const Offset(6, 6));
        break;

      case CardFaceLayout.singleCornerWithCenteredRankSuit:
        final centerStyle =
            theme.textTheme.headlineSmall?.copyWith(
              color: suitColor,
              fontWeight: FontWeight.w800,
            ) ??
            TextStyle(
              color: suitColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            );

        final centerPainter = TextPainter(
          text: TextSpan(text: '$rankText$suitSymbol', style: centerStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width);

        final centerOffset = Offset(
          (size.width - centerPainter.width) / 2,
          (size.height - centerPainter.height) / 2,
        );
        centerPainter.paint(canvas, centerOffset);
        break;

      case CardFaceLayout.singleCornerWithCenteredSuitWatermark:
        cornerRankSuitPainter.paint(canvas, const Offset(6, 6));

        final watermarkStyle =
            theme.textTheme.displaySmall?.copyWith(
              color: suitColor.withValues(alpha: 0.16),
              fontWeight: FontWeight.w800,
            ) ??
            TextStyle(
              color: suitColor.withValues(alpha: 0.16),
              fontWeight: FontWeight.w800,
              fontSize: 42,
            );

        final watermarkPainter = TextPainter(
          text: TextSpan(text: suitSymbol, style: watermarkStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width);

        final watermarkOffset = Offset(
          (size.width - watermarkPainter.width) / 2,
          (size.height - watermarkPainter.height) / 2,
        );
        watermarkPainter.paint(canvas, watermarkOffset);
        break;

      case CardFaceLayout.centeredSuitThenRank:
        final centerStyle =
            theme.textTheme.headlineSmall?.copyWith(
              color: suitColor,
              fontWeight: FontWeight.w800,
            ) ??
            TextStyle(
              color: suitColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
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
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _VectorCardPainter oldDelegate) {
    return oldDelegate.card.rank != card.rank ||
        oldDelegate.card.suit != card.suit ||
        oldDelegate.card.isFaceUp != card.isFaceUp ||
        oldDelegate.theme != theme ||
        oldDelegate.layout != layout;
  }
}

Color _suitColor(Suit suit) {
  return (suit == Suit.hearts || suit == Suit.diamonds)
      ? Colors.red
      : Colors.black;
}

String _suitSymbol(Suit suit) {
  switch (suit) {
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
