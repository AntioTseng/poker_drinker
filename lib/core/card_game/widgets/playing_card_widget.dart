import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/playing_card.dart';
import '../theme/card_palette.dart';

class PlayingCardWidget extends StatefulWidget {
  final PlayingCard card;
  final VoidCallback? onTap;
  final Duration? flipDuration;
  final bool animateOnMountIfFaceUp;
  final VoidCallback? onFlipCompleted;

  const PlayingCardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.flipDuration,
    this.animateOnMountIfFaceUp = false,
    this.onFlipCompleted,
  });

  @override
  State<PlayingCardWidget> createState() => _PlayingCardWidgetState();
}

class _PlayingCardWidgetState extends State<PlayingCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _lastIsFaceUp;

  @override
  void initState() {
    super.initState();

    _lastIsFaceUp = widget.card.isFaceUp;
    _controller = AnimationController(
      vsync: this,
      duration: widget.flipDuration ?? const Duration(milliseconds: 250),
    );

    if (widget.animateOnMountIfFaceUp && widget.card.isFaceUp) {
      _controller.value = 0;
      _animateToFaceUp();
    } else {
      _controller.value = widget.card.isFaceUp ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(covariant PlayingCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final duration = widget.flipDuration;
    if (duration != null) {
      _controller.duration = duration;
    }

    final bool newIsFaceUp = widget.card.isFaceUp;
    if (!_lastIsFaceUp && newIsFaceUp) {
      _animateToFaceUp();
    } else if (_lastIsFaceUp && !newIsFaceUp) {
      _animateToFaceDown();
    } else {
      _controller.value = newIsFaceUp ? 1 : 0;
    }

    _lastIsFaceUp = newIsFaceUp;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateToFaceUp() async {
    final duration = widget.flipDuration;
    if (duration == null || duration == Duration.zero) {
      _controller.value = 1;
      widget.onFlipCompleted?.call();
      return;
    }

    try {
      await _controller.forward(from: 0);
    } finally {
      if (mounted) {
        widget.onFlipCompleted?.call();
      }
    }
  }

  void _animateToFaceDown() {
    final duration = widget.flipDuration;
    if (duration == null || duration == Duration.zero) {
      _controller.value = 0;
      return;
    }
    _controller.reverse(from: 1);
  }

  Color _getSuitColor() {
    if (widget.card.suit == Suit.hearts || widget.card.suit == Suit.diamonds) {
      return Colors.red;
    }

    return Colors.black;
  }

  String _getSuitSymbol() {
    switch (widget.card.suit) {
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
    final theme = Theme.of(context);

    Widget face({required bool isFaceUp}) {
      return CustomPaint(
        painter: _CardPainter(
          theme: theme,
          isFaceUp: isFaceUp,
          rankText: widget.card.rankLabel,
          suitSymbol: _getSuitSymbol(),
          suitColor: _getSuitColor(),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: 50,
          height: 70,
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
                child: showFront ? face(isFaceUp: true) : face(isFaceUp: false),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CardPainter extends CustomPainter {
  final ThemeData theme;
  final bool isFaceUp;
  final String rankText;
  final String suitSymbol;
  final Color suitColor;

  _CardPainter({
    required this.theme,
    required this.isFaceUp,
    required this.rankText,
    required this.suitSymbol,
    required this.suitColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(6),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;

    if (!isFaceUp) {
      canvas.drawRRect(rrect, Paint()..color = CardPalette.cardBack);
      canvas.drawRRect(rrect, borderPaint);
      return;
    }

    canvas.drawRRect(rrect, Paint()..color = Colors.white);
    canvas.drawRRect(rrect, borderPaint);

    final fontSize = size.shortestSide * 0.36;
    final centerStyle =
        theme.textTheme.titleLarge?.copyWith(
          color: suitColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ) ??
        TextStyle(
          color: suitColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
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
  }

  @override
  bool shouldRepaint(covariant _CardPainter oldDelegate) {
    return oldDelegate.theme != theme ||
        oldDelegate.isFaceUp != isFaceUp ||
        oldDelegate.rankText != rankText ||
        oldDelegate.suitSymbol != suitSymbol ||
        oldDelegate.suitColor != suitColor;
  }
}
