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
            Text('翻牌動畫示範（點牌翻面）', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            _FlipAnimationDemoRow(
              cardLogicalSize: _cardLogicalSize,
              faceUpCard: PlayingCard(
                suit: Suit.spades,
                rank: 1,
                isFaceUp: true,
              ),
              faceDownCard: PlayingCard(
                suit: Suit.spades,
                rank: 1,
                isFaceUp: false,
              ),
            ),
            const SizedBox(height: 24),
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

class _FlipAnimationDemoRow extends StatelessWidget {
  final Size cardLogicalSize;
  final PlayingCard faceUpCard;
  final PlayingCard faceDownCard;

  const _FlipAnimationDemoRow({
    required this.cardLogicalSize,
    required this.faceUpCard,
    required this.faceDownCard,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget cardFace(PlayingCard card) {
      return SizedBox(
        width: cardLogicalSize.width,
        height: cardLogicalSize.height,
        child: VectorPlayingCardWidget(
          card: card,
          layout: CardFaceLayout.centeredSuitThenRank,
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _FlipDemoItem(
          title: '方案1：3D 翻牌\n250ms',
          titleStyle: textTheme.bodyMedium,
          child: _ThreeDFlipCard(
            duration: const Duration(milliseconds: 250),
            back: cardFace(faceDownCard),
            front: cardFace(faceUpCard),
          ),
        ),
        _FlipDemoItem(
          title: '方案1：3D 翻牌\n400ms',
          titleStyle: textTheme.bodyMedium,
          child: _ThreeDFlipCard(
            duration: const Duration(milliseconds: 400),
            back: cardFace(faceDownCard),
            front: cardFace(faceUpCard),
          ),
        ),
        _FlipDemoItem(
          title: '方案2：淡入淡出\n+ 縮放',
          titleStyle: textTheme.bodyMedium,
          child: _CrossFadeFlipCard(
            duration: const Duration(milliseconds: 250),
            back: cardFace(faceDownCard),
            front: cardFace(faceUpCard),
          ),
        ),
      ],
    );
  }
}

class _FlipDemoItem extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget child;

  const _FlipDemoItem({
    required this.title,
    required this.titleStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: titleStyle, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ThreeDFlipCard extends StatefulWidget {
  final Duration duration;
  final Widget back;
  final Widget front;

  const _ThreeDFlipCard({
    required this.duration,
    required this.back,
    required this.front,
  });

  @override
  State<_ThreeDFlipCard> createState() => _ThreeDFlipCardState();
}

class _ThreeDFlipCardState extends State<_ThreeDFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      final bool goingForward = _controller.velocity >= 0;
      if (goingForward) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final double angle = _controller.value * math.pi;
          final bool showFront = _controller.value >= 0.5;
          final double displayAngle = showFront ? (angle - math.pi) : angle;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(displayAngle),
            child: showFront ? widget.front : widget.back,
          );
        },
      ),
    );
  }
}

class _CrossFadeFlipCard extends StatefulWidget {
  final Duration duration;
  final Widget back;
  final Widget front;

  const _CrossFadeFlipCard({
    required this.duration,
    required this.back,
    required this.front,
  });

  @override
  State<_CrossFadeFlipCard> createState() => _CrossFadeFlipCardState();
}

class _CrossFadeFlipCardState extends State<_CrossFadeFlipCard> {
  bool _showFront = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showFront = !_showFront),
      child: AnimatedSwitcher(
        duration: widget.duration,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final fade = FadeTransition(opacity: animation, child: child);
          final scale = ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
            child: fade,
          );
          return scale;
        },
        child: _showFront
            ? KeyedSubtree(key: const ValueKey('front'), child: widget.front)
            : KeyedSubtree(key: const ValueKey('back'), child: widget.back),
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
