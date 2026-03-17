import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/card_game/models/playing_card.dart';

enum CardFaceLayout {
  twoCorners,
  singleCorner,
  singleCornerWithCenteredRankSuit,
  singleCornerWithCenteredSuitWatermark,
  centeredSuitThenRank,
}

enum CardBackStyle {
  lattice,
  pinstripe,
  artDeco,
  parquet,
  chevron,
  medallion,
  cornerFiligree,
  woven,
  starfield,
  casino,
}

class CardRenderDemoPage extends StatefulWidget {
  const CardRenderDemoPage({super.key});

  @override
  State<CardRenderDemoPage> createState() => _CardRenderDemoPageState();
}

class _CardRenderDemoPageState extends State<CardRenderDemoPage> {
  static const _cardLogicalSize = Size(60, 84);
  static const _pageBackground = Color(0xFFF4EBDD);
  static const _pageBackgroundSoft = Color(0xFFEADBC8);
  static const _panelColor = Color(0xFFFFF8F1);
  static const _primaryAccent = Color(0xFF7A2131);
  static const _secondaryAccent = Color(0xFFB57462);
  static const _ink = Color(0xFF34241C);

  late final List<PlayingCard> _sampleCards = <PlayingCard>[
    PlayingCard(suit: Suit.spades, rank: 1, isFaceUp: true),
    PlayingCard(suit: Suit.hearts, rank: 7, isFaceUp: true),
    PlayingCard(suit: Suit.diamonds, rank: 13, isFaceUp: true),
    PlayingCard(suit: Suit.clubs, rank: 2, isFaceUp: false),
  ];

  late final PlayingCard _backDemoCard = PlayingCard(
    suit: Suit.spades,
    rank: 1,
    isFaceUp: false,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Render Demo'),
        backgroundColor: _pageBackground,
        foregroundColor: _ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_pageBackground, _pageBackgroundSoft],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _DemoSection(
                title: 'Parquet 主題方向',
                eyebrow: '暖紙色背景 + 酒紅木質重點色',
                child: Text(
                  '我先把整個 demo 頁改成與 04 拼木地板牌背相容的視覺方向：背景從純白改成暖米紙色，主題色改為偏酒紅木質調，讓牌背的桃木/拼接感更像一套完整桌遊或牌盒包裝。',
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _DemoSection(
                title: '牌背花紋提案（10 款）',
                eyebrow: '目前偏好：04 Parquet',
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: CardBackStyle.values
                      .map((style) {
                        return _BackPatternDemoItem(
                          title: _cardBackStyleTitle(style),
                          subtitle: _cardBackStyleSubtitle(style),
                          isFeatured: style == CardBackStyle.parquet,
                          child: SizedBox(
                            width: _cardLogicalSize.width,
                            height: _cardLogicalSize.height,
                            child: VectorPlayingCardWidget(
                              card: _backDemoCard,
                              layout: CardFaceLayout.centeredSuitThenRank,
                              backStyle: style,
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 24),
              _DemoSection(
                title: '翻牌動畫示範（點牌翻面）',
                eyebrow: '背面已切換為 04 Parquet',
                child: _FlipAnimationDemoRow(
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
                  backStyle: CardBackStyle.parquet,
                ),
              ),
              const SizedBox(height: 24),
              _RenderColumn(
                title: '目前版本（上下各一組角標）',
                cards: _sampleCards,
                panelColor: _panelColor,
                builder: (card) => SizedBox(
                  width: _cardLogicalSize.width,
                  height: _cardLogicalSize.height,
                  child: VectorPlayingCardWidget(
                    card: card,
                    layout: CardFaceLayout.twoCorners,
                    backStyle: CardBackStyle.parquet,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RenderColumn(
                title: '版本 A（只有正面角標）',
                cards: _sampleCards,
                panelColor: _panelColor,
                builder: (card) => SizedBox(
                  width: _cardLogicalSize.width,
                  height: _cardLogicalSize.height,
                  child: VectorPlayingCardWidget(
                    card: card,
                    layout: CardFaceLayout.singleCorner,
                    backStyle: CardBackStyle.parquet,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RenderColumn(
                title: '版本 B（正面角標 + 中間淡花色）',
                cards: _sampleCards,
                panelColor: _panelColor,
                builder: (card) => SizedBox(
                  width: _cardLogicalSize.width,
                  height: _cardLogicalSize.height,
                  child: VectorPlayingCardWidget(
                    card: card,
                    layout:
                        CardFaceLayout.singleCornerWithCenteredSuitWatermark,
                    backStyle: CardBackStyle.parquet,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RenderColumn(
                title: '版本 C（版本 A + 數字與花色置中）',
                cards: _sampleCards,
                panelColor: _panelColor,
                builder: (card) => SizedBox(
                  width: _cardLogicalSize.width,
                  height: _cardLogicalSize.height,
                  child: VectorPlayingCardWidget(
                    card: card,
                    layout: CardFaceLayout.singleCornerWithCenteredRankSuit,
                    backStyle: CardBackStyle.parquet,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RenderColumn(
                title: '版本 D（版本 C 但花色與數字對調）',
                cards: _sampleCards,
                panelColor: _panelColor,
                builder: (card) => SizedBox(
                  width: _cardLogicalSize.width,
                  height: _cardLogicalSize.height,
                  child: VectorPlayingCardWidget(
                    card: card,
                    layout: CardFaceLayout.centeredSuitThenRank,
                    backStyle: CardBackStyle.parquet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  final String title;
  final String eyebrow;
  final Widget child;

  const _DemoSection({
    required this.title,
    required this.eyebrow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _CardRenderDemoPageState._panelColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: textTheme.labelLarge?.copyWith(
                color: _CardRenderDemoPageState._secondaryAccent,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 14),
            child,
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
  final CardBackStyle backStyle;

  const _FlipAnimationDemoRow({
    required this.cardLogicalSize,
    required this.faceUpCard,
    required this.faceDownCard,
    required this.backStyle,
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
          backStyle: backStyle,
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

class _BackPatternDemoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool isFeatured;

  const _BackPatternDemoItem({
    required this.title,
    required this.subtitle,
    required this.child,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 132,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: isFeatured
                  ? _CardRenderDemoPageState._pageBackgroundSoft
                  : _CardRenderDemoPageState._panelColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isFeatured
                    ? _CardRenderDemoPageState._primaryAccent
                    : Colors.black.withValues(alpha: 0.08),
                width: isFeatured ? 2 : 1,
              ),
            ),
            child: Padding(padding: const EdgeInsets.all(10), child: child),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: isFeatured
                  ? _CardRenderDemoPageState._primaryAccent
                  : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: isFeatured ? FontWeight.w700 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
  final Color panelColor;

  const _RenderColumn({
    required this.title,
    required this.cards,
    required this.builder,
    required this.panelColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
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
        ),
      ),
    );
  }
}

class VectorPlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final CardFaceLayout layout;
  final CardBackStyle backStyle;

  const VectorPlayingCardWidget({
    super.key,
    required this.card,
    required this.layout,
    this.backStyle = CardBackStyle.lattice,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VectorCardPainter(
        card: card,
        theme: Theme.of(context),
        layout: layout,
        backStyle: backStyle,
      ),
    );
  }
}

class _VectorCardPainter extends CustomPainter {
  final PlayingCard card;
  final ThemeData theme;
  final CardFaceLayout layout;
  final CardBackStyle backStyle;

  _VectorCardPainter({
    required this.card,
    required this.theme,
    required this.layout,
    required this.backStyle,
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
      final style = _cardBackPalette(backStyle);
      final backPaint = Paint()..color = style.background;
      canvas.drawRRect(rrect, backPaint);
      _paintCardBackPattern(canvas, size, rrect, backStyle, style);
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
        oldDelegate.layout != layout ||
        oldDelegate.backStyle != backStyle;
  }
}

class _CardBackPalette {
  final Color background;
  final Color accent;
  final Color softAccent;

  const _CardBackPalette({
    required this.background,
    required this.accent,
    required this.softAccent,
  });
}

String _cardBackStyleTitle(CardBackStyle style) {
  switch (style) {
    case CardBackStyle.lattice:
      return '01 Lattice';
    case CardBackStyle.pinstripe:
      return '02 Pinstripe';
    case CardBackStyle.artDeco:
      return '03 Art Deco';
    case CardBackStyle.parquet:
      return '04 Parquet';
    case CardBackStyle.chevron:
      return '05 Chevron';
    case CardBackStyle.medallion:
      return '06 Medallion';
    case CardBackStyle.cornerFiligree:
      return '07 Filigree';
    case CardBackStyle.woven:
      return '08 Woven';
    case CardBackStyle.starfield:
      return '09 Starfield';
    case CardBackStyle.casino:
      return '10 Casino';
  }
}

String _cardBackStyleSubtitle(CardBackStyle style) {
  switch (style) {
    case CardBackStyle.lattice:
      return '經典菱格';
    case CardBackStyle.pinstripe:
      return '細條紋印刷';
    case CardBackStyle.artDeco:
      return '裝飾藝術';
    case CardBackStyle.parquet:
      return '拼木地板感';
    case CardBackStyle.chevron:
      return '箭紋律動';
    case CardBackStyle.medallion:
      return '中心徽章';
    case CardBackStyle.cornerFiligree:
      return '角落飾紋';
    case CardBackStyle.woven:
      return '編織質感';
    case CardBackStyle.starfield:
      return '星點夜幕';
    case CardBackStyle.casino:
      return '賭場牌盒';
  }
}

_CardBackPalette _cardBackPalette(CardBackStyle style) {
  switch (style) {
    case CardBackStyle.lattice:
      return const _CardBackPalette(
        background: Color(0xFF9CCBFF),
        accent: Color(0xFFF9FCFF),
        softAccent: Color(0xFF3D6FA6),
      );
    case CardBackStyle.pinstripe:
      return const _CardBackPalette(
        background: Color(0xFF143B73),
        accent: Color(0xFFEAF3FF),
        softAccent: Color(0xFF89B7F1),
      );
    case CardBackStyle.artDeco:
      return const _CardBackPalette(
        background: Color(0xFF123C36),
        accent: Color(0xFFF3E2A7),
        softAccent: Color(0xFF78B8A8),
      );
    case CardBackStyle.parquet:
      return const _CardBackPalette(
        background: Color(0xFF7A2131),
        accent: Color(0xFFFFE6D2),
        softAccent: Color(0xFFE99E8C),
      );
    case CardBackStyle.chevron:
      return const _CardBackPalette(
        background: Color(0xFF2F295C),
        accent: Color(0xFFEAE7FF),
        softAccent: Color(0xFF958CE5),
      );
    case CardBackStyle.medallion:
      return const _CardBackPalette(
        background: Color(0xFF0F4E56),
        accent: Color(0xFFF4FBF7),
        softAccent: Color(0xFF8DD2C6),
      );
    case CardBackStyle.cornerFiligree:
      return const _CardBackPalette(
        background: Color(0xFF61263C),
        accent: Color(0xFFFFF1E8),
        softAccent: Color(0xFFE1A6B8),
      );
    case CardBackStyle.woven:
      return const _CardBackPalette(
        background: Color(0xFF3D4E26),
        accent: Color(0xFFF7F7E8),
        softAccent: Color(0xFFC6D18B),
      );
    case CardBackStyle.starfield:
      return const _CardBackPalette(
        background: Color(0xFF1D2347),
        accent: Color(0xFFF3F7FF),
        softAccent: Color(0xFF9EB5FF),
      );
    case CardBackStyle.casino:
      return const _CardBackPalette(
        background: Color(0xFF8A1E2B),
        accent: Color(0xFFFFF7F1),
        softAccent: Color(0xFFF3B8A8),
      );
  }
}

void _paintCardBackPattern(
  Canvas canvas,
  Size size,
  RRect rrect,
  CardBackStyle style,
  _CardBackPalette palette,
) {
  canvas.save();
  canvas.clipRRect(rrect);

  final rect = Offset.zero & size;
  final insetRect = rect.deflate(5);
  final insetRadius = math.max(0.0, rrect.brRadiusX - 2);
  final insetRRect = RRect.fromRectAndRadius(
    insetRect,
    Radius.circular(insetRadius),
  );

  final innerBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = palette.accent.withValues(alpha: 0.45);
  canvas.drawRRect(insetRRect, innerBorderPaint);

  switch (style) {
    case CardBackStyle.lattice:
      _paintLatticePattern(canvas, size, palette);
      break;
    case CardBackStyle.pinstripe:
      _paintPinstripePattern(canvas, size, palette);
      break;
    case CardBackStyle.artDeco:
      _paintArtDecoPattern(canvas, size, palette);
      break;
    case CardBackStyle.parquet:
      _paintParquetPattern(canvas, size, palette);
      break;
    case CardBackStyle.chevron:
      _paintChevronPattern(canvas, size, palette);
      break;
    case CardBackStyle.medallion:
      _paintMedallionPattern(canvas, size, palette);
      break;
    case CardBackStyle.cornerFiligree:
      _paintCornerFiligreePattern(canvas, size, palette);
      break;
    case CardBackStyle.woven:
      _paintWovenPattern(canvas, size, palette);
      break;
    case CardBackStyle.starfield:
      _paintStarfieldPattern(canvas, size, palette);
      break;
    case CardBackStyle.casino:
      _paintCasinoPattern(canvas, size, palette);
      break;
  }

  canvas.restore();
}

void _paintLatticePattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final step = math.max(9.0, size.shortestSide / 5);
  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..color = palette.accent.withValues(alpha: 0.22);
  for (double x = -size.height; x <= size.width + size.height; x += step) {
    canvas.drawLine(
      Offset(x, 0),
      Offset(x + size.height, size.height),
      linePaint,
    );
  }
  for (double x = 0; x <= size.width + size.height; x += step) {
    canvas.drawLine(
      Offset(x, 0),
      Offset(x - size.height, size.height),
      linePaint,
    );
  }
  final dotPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.accent.withValues(alpha: 0.24);
  final dotStep = step * 0.9;
  for (double y = 10; y <= size.height - 10; y += dotStep) {
    for (double x = 10; x <= size.width - 10; x += dotStep) {
      if ((((x / dotStep).floor() + (y / dotStep).floor()) & 1) == 0) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }
  _paintCenterRings(canvas, size, palette);
}

void _paintPinstripePattern(
  Canvas canvas,
  Size size,
  _CardBackPalette palette,
) {
  final stripePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = palette.accent.withValues(alpha: 0.22);
  final beadPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.softAccent.withValues(alpha: 0.28);
  for (double x = 8; x <= size.width - 8; x += 5) {
    canvas.drawLine(Offset(x, 8), Offset(x, size.height - 8), stripePaint);
  }
  for (double y = 12; y <= size.height - 12; y += 12) {
    canvas.drawCircle(Offset(size.width / 2, y), 1.2, beadPaint);
  }
  _paintCenterLozenge(canvas, size, palette);
}

void _paintArtDecoPattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final archPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2
    ..color = palette.accent.withValues(alpha: 0.4);
  final center = Offset(size.width / 2, size.height / 2);
  for (double inset = 8; inset <= size.width / 2; inset += 6) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width - inset,
      height: size.height - inset * 1.25,
    );
    canvas.drawArc(rect, math.pi, math.pi, false, archPaint);
    canvas.drawArc(rect, 0, math.pi, false, archPaint);
  }
  final spokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = palette.softAccent.withValues(alpha: 0.4);
  for (int i = 0; i < 6; i++) {
    final dx = 12.0 + i * 7;
    canvas.drawLine(
      Offset(dx, center.dy),
      Offset(size.width - dx, center.dy),
      spokePaint,
    );
  }
}

void _paintParquetPattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final tilePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = palette.accent.withValues(alpha: 0.28);
  final fillPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.softAccent.withValues(alpha: 0.16);
  const tile = 10.0;
  for (double y = 10; y <= size.height - 14; y += tile) {
    for (double x = 8; x <= size.width - 12; x += tile) {
      final rect = Rect.fromLTWH(x, y, tile - 2, tile - 2);
      if ((((x / tile).floor() + (y / tile).floor()) & 1) == 0) {
        canvas.drawRect(rect, fillPaint);
      }
      canvas.drawRect(rect, tilePaint);
    }
  }
  _paintCenterDiamond(canvas, size, palette);
}

void _paintChevronPattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final chevronPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4
    ..strokeJoin = StrokeJoin.round
    ..color = palette.accent.withValues(alpha: 0.3);
  for (double y = 14; y <= size.height - 14; y += 10) {
    final path = Path()
      ..moveTo(8, y)
      ..lineTo(size.width / 2, y - 4)
      ..lineTo(size.width - 8, y);
    canvas.drawPath(path, chevronPaint);
  }
  _paintCenterRings(canvas, size, palette);
}

void _paintMedallionPattern(
  Canvas canvas,
  Size size,
  _CardBackPalette palette,
) {
  _paintCenterRings(canvas, size, palette);
  final center = Offset(size.width / 2, size.height / 2);
  final petalPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1
    ..color = palette.accent.withValues(alpha: 0.55);
  for (int i = 0; i < 10; i++) {
    final a = (i / 10.0) * math.pi * 2;
    final p = Offset(
      center.dx + math.cos(a) * size.shortestSide * 0.16,
      center.dy + math.sin(a) * size.shortestSide * 0.16,
    );
    canvas.drawCircle(p, size.shortestSide * 0.045, petalPaint);
  }
}

void _paintCornerFiligreePattern(
  Canvas canvas,
  Size size,
  _CardBackPalette palette,
) {
  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1
    ..color = palette.accent.withValues(alpha: 0.45);
  for (final offset in <Offset>[
    const Offset(12, 12),
    Offset(size.width - 12, 12),
    Offset(12, size.height - 12),
    Offset(size.width - 12, size.height - 12),
  ]) {
    canvas.drawCircle(offset, 6, linePaint);
    canvas.drawCircle(offset, 11, linePaint);
  }
  canvas.drawLine(
    const Offset(18, 18),
    Offset(size.width - 18, size.height - 18),
    linePaint,
  );
  canvas.drawLine(
    Offset(size.width - 18, 18),
    Offset(18, size.height - 18),
    linePaint,
  );
  _paintCenterLozenge(canvas, size, palette);
}

void _paintWovenPattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final horiz = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = palette.accent.withValues(alpha: 0.18);
  final vert = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = palette.softAccent.withValues(alpha: 0.24);
  for (double y = 10; y <= size.height - 10; y += 8) {
    canvas.drawLine(Offset(8, y), Offset(size.width - 8, y), horiz);
  }
  for (double x = 10; x <= size.width - 10; x += 8) {
    canvas.drawLine(Offset(x, 8), Offset(x, size.height - 8), vert);
  }
  _paintCenterDiamond(canvas, size, palette);
}

void _paintStarfieldPattern(
  Canvas canvas,
  Size size,
  _CardBackPalette palette,
) {
  final starPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.accent.withValues(alpha: 0.75);
  final smallPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.softAccent.withValues(alpha: 0.45);
  final points = <Offset>[
    const Offset(12, 14),
    const Offset(24, 20),
    const Offset(43, 15),
    const Offset(17, 35),
    const Offset(31, 31),
    const Offset(47, 40),
    const Offset(14, 58),
    const Offset(27, 69),
    const Offset(46, 61),
  ];
  for (var i = 0; i < points.length; i++) {
    canvas.drawCircle(
      points[i],
      i.isEven ? 1.5 : 1.0,
      i.isEven ? starPaint : smallPaint,
    );
  }
  _paintCenterRays(canvas, size, palette);
}

void _paintCasinoPattern(Canvas canvas, Size size, _CardBackPalette palette) {
  final framePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1
    ..color = palette.accent.withValues(alpha: 0.45);
  canvas.drawRect(
    Rect.fromLTWH(9, 9, size.width - 18, size.height - 18),
    framePaint,
  );
  canvas.drawRect(
    Rect.fromLTWH(13, 13, size.width - 26, size.height - 26),
    framePaint,
  );
  final pipPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = palette.softAccent.withValues(alpha: 0.3);
  for (double y = 18; y <= size.height - 18; y += 12) {
    canvas.drawCircle(Offset(16, y), 1.2, pipPaint);
    canvas.drawCircle(Offset(size.width - 16, y), 1.2, pipPaint);
  }
  _paintCenterLozenge(canvas, size, palette);
}

void _paintCenterRings(Canvas canvas, Size size, _CardBackPalette palette) {
  final center = Offset(size.width / 2, size.height / 2);
  final ringPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = palette.accent.withValues(alpha: 0.52);
  canvas.drawCircle(center, size.shortestSide * 0.18, ringPaint);
  canvas.drawCircle(center, size.shortestSide * 0.12, ringPaint);
}

void _paintCenterDiamond(Canvas canvas, Size size, _CardBackPalette palette) {
  final center = Offset(size.width / 2, size.height / 2);
  final path = Path()
    ..moveTo(center.dx, center.dy - 10)
    ..lineTo(center.dx + 10, center.dy)
    ..lineTo(center.dx, center.dy + 10)
    ..lineTo(center.dx - 10, center.dy)
    ..close();
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..color = palette.accent.withValues(alpha: 0.55),
  );
}

void _paintCenterLozenge(Canvas canvas, Size size, _CardBackPalette palette) {
  final rect = Rect.fromCenter(
    center: Offset(size.width / 2, size.height / 2),
    width: size.width * 0.34,
    height: size.height * 0.14,
  );
  final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
  canvas.drawRRect(
    rrect,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = palette.accent.withValues(alpha: 0.55),
  );
}

void _paintCenterRays(Canvas canvas, Size size, _CardBackPalette palette) {
  final center = Offset(size.width / 2, size.height / 2);
  final rayPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = palette.accent.withValues(alpha: 0.2);
  for (int i = 0; i < 12; i++) {
    final a = (i / 12.0) * math.pi * 2;
    canvas.drawLine(
      center,
      Offset(center.dx + math.cos(a) * 24, center.dy + math.sin(a) * 24),
      rayPaint,
    );
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
