import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/playing_card.dart';
import '../theme/card_palette.dart';

enum CardFlipAxis { horizontal, vertical }

enum CardPeelCorner { topLeft, topRight, bottomLeft, bottomRight }

class PlayingCardWidget extends StatefulWidget {
  final PlayingCard card;
  final VoidCallback? onTap;
  final Duration? flipDuration;
  final bool animateOnMountIfFaceUp;
  final VoidCallback? onFlipCompleted;
  final double width;
  final double height;
  final double? flipProgress;
  final CardFlipAxis flipAxis;
  final double flipDirection;
  final CardPeelCorner? peelCorner;
  final Offset? flipVector;

  const PlayingCardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.flipDuration,
    this.animateOnMountIfFaceUp = false,
    this.onFlipCompleted,
    this.width = 50,
    this.height = 70,
    this.flipProgress,
    this.flipAxis = CardFlipAxis.horizontal,
    this.flipDirection = 1,
    this.peelCorner,
    this.flipVector,
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
    } else if (widget.flipProgress != null) {
      _controller.value = widget.flipProgress!.clamp(0.0, 1.0);
    } else {
      _controller.value = widget.card.isFaceUp ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(covariant PlayingCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.flipProgress != null) {
      _controller.value = widget.flipProgress!.clamp(0.0, 1.0);
      _lastIsFaceUp = widget.card.isFaceUp;
      return;
    }

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
          width: widget.width,
          height: widget.height,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final double visualProgress = widget.flipProgress != null
                  ? Curves.easeInOut.transform(_controller.value)
                  : _controller.value;
              final double angle = visualProgress * math.pi;
              final Offset activeVector =
                  widget.flipVector == null || widget.flipVector!.distance == 0
                  ? const Offset(1, 0)
                  : widget.flipVector! / widget.flipVector!.distance;
              final double signedAngle = angle * widget.flipDirection.sign;
              final double displayAngle = visualProgress >= 0.5
                  ? signedAngle - (math.pi * widget.flipDirection.sign)
                  : signedAngle;
              final double foldAmount = math.sin(visualProgress * math.pi);
              final double bend = Curves.easeOut.transform(foldAmount);
              final bentCard =
                  widget.peelCorner != null && widget.flipVector == null
                  ? _buildCornerPeelCard(
                      frontFace: face(isFaceUp: true),
                      backFace: face(isFaceUp: false),
                      progress: visualProgress,
                      bend: bend,
                      displayAngle: displayAngle,
                    )
                  : ClipPath(
                      clipper: _BentCardClipper(
                        axis: widget.flipAxis,
                        bendAmount: bend,
                        direction: widget.flipDirection,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          visualProgress >= 0.5
                              ? face(isFaceUp: true)
                              : face(isFaceUp: false),
                          IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: _buildBendGradient(
                                  axis: widget.flipAxis,
                                  bendAmount: bend,
                                  direction: widget.flipDirection,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

              final transform = Matrix4.identity()..setEntry(3, 2, 0.00095);
              if (widget.flipVector != null) {
                transform
                  ..translate(0.0, 0.0, bend * 7)
                  ..rotateX(-activeVector.dy * displayAngle)
                  ..rotateY(activeVector.dx * displayAngle)
                  ..rotateZ(activeVector.dx * activeVector.dy * bend * 0.06)
                  ..scale(
                    1.0 + (activeVector.dx.abs() * bend * 0.02),
                    1.0 - (activeVector.dy.abs() * bend * 0.03),
                  );
              } else if (widget.peelCorner != null) {
                transform.translate(0.0, 0.0, bend * 2.5);
              } else if (widget.flipAxis == CardFlipAxis.vertical) {
                transform
                  ..translate(0.0, 0.0, bend * 7)
                  ..rotateX(displayAngle)
                  ..rotateY(widget.flipDirection.sign * bend * 0.085)
                  ..scale(1.0 - (bend * 0.055), 1.0 + (bend * 0.025));
              } else {
                transform
                  ..translate(0.0, 0.0, bend * 7)
                  ..rotateY(displayAngle)
                  ..rotateX(widget.flipDirection.sign * bend * 0.085)
                  ..scale(1.0 + (bend * 0.025), 1.0 - (bend * 0.055));
              }

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: bentCard,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCornerPeelCard({
    required Widget frontFace,
    required Widget backFace,
    required double progress,
    required double bend,
    required double displayAngle,
  }) {
    final corner = widget.peelCorner!;
    final signs = _signsForCorner(corner);
    final flapTransform = Matrix4.identity()..setEntry(3, 2, 0.00095);
    flapTransform
      ..translate(0.0, 0.0, bend * 13)
      ..rotateX(displayAngle * signs.dy * 0.6)
      ..rotateY(displayAngle * -signs.dx * 0.6)
      ..rotateZ(signs.dx * signs.dy * bend * 0.038)
      ..scale(1.0 + (bend * 0.015), 1.0 - (bend * 0.08));

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: _CornerBaseClipper(corner: corner, revealAmount: progress),
          child: backFace,
        ),
        if (progress < 0.999)
          ClipPath(
            clipper: _CornerRevealClipper(
              corner: corner,
              revealAmount: progress,
            ),
            child: frontFace,
          ),
        if (progress < 0.999)
          _buildCornerPeelFlap(
            backFace: backFace,
            corner: corner,
            progress: progress,
            bend: bend,
            displayAngle: displayAngle,
            flapTransform: flapTransform,
          ),
      ],
    );
  }

  Widget _buildCornerPeelFlap({
    required Widget backFace,
    required CardPeelCorner corner,
    required double progress,
    required double bend,
    required double displayAngle,
    required Matrix4 flapTransform,
  }) {
    const int bandCount = 6;

    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(bandCount, (index) {
        final double start = progress * (index / bandCount);
        final double end = progress * ((index + 1) / bandCount);
        final double bandT = (index + 1) / bandCount;
        final double bandBend = Curves.easeOut.transform(bandT) * bend;
        final double bandLift = 1 + (bandT * 0.35);
        final Matrix4 bandTransform = Matrix4.copy(flapTransform)
          ..translate(0.0, 0.0, bandBend * 2.2 * bandLift);

        return Transform(
          alignment: _anchorAlignmentForCorner(corner),
          transform: bandTransform,
          child: Opacity(
            opacity: (0.94 - (progress * 0.18) - ((1 - bandT) * 0.08)).clamp(
              0.0,
              1.0,
            ),
            child: ClipPath(
              clipper: _CornerFlapBandClipper(
                corner: corner,
                innerRevealAmount: start,
                outerRevealAmount: end,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  backFace,
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: _buildCornerFlapGradient(
                          corner: corner,
                          bendAmount: bandBend,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).reversed.toList(growable: false),
    );
  }
}

Offset _signsForCorner(CardPeelCorner corner) {
  switch (corner) {
    case CardPeelCorner.topLeft:
      return const Offset(-1, -1);
    case CardPeelCorner.topRight:
      return const Offset(1, -1);
    case CardPeelCorner.bottomLeft:
      return const Offset(-1, 1);
    case CardPeelCorner.bottomRight:
      return const Offset(1, 1);
  }
}

Alignment _anchorAlignmentForCorner(CardPeelCorner corner) {
  switch (corner) {
    case CardPeelCorner.topLeft:
      return Alignment.bottomRight;
    case CardPeelCorner.topRight:
      return Alignment.bottomLeft;
    case CardPeelCorner.bottomLeft:
      return Alignment.topRight;
    case CardPeelCorner.bottomRight:
      return Alignment.topLeft;
  }
}

LinearGradient _buildCornerPeelGradient({
  required CardPeelCorner corner,
  required double bendAmount,
}) {
  final begin = switch (corner) {
    CardPeelCorner.topLeft => Alignment.topLeft,
    CardPeelCorner.topRight => Alignment.topRight,
    CardPeelCorner.bottomLeft => Alignment.bottomLeft,
    CardPeelCorner.bottomRight => Alignment.bottomRight,
  };
  final end = switch (corner) {
    CardPeelCorner.topLeft => Alignment.bottomRight,
    CardPeelCorner.topRight => Alignment.bottomLeft,
    CardPeelCorner.bottomLeft => Alignment.topRight,
    CardPeelCorner.bottomRight => Alignment.topLeft,
  };

  return LinearGradient(
    begin: begin,
    end: end,
    colors: [
      Colors.black.withValues(alpha: 0.18 * bendAmount),
      Colors.black.withValues(alpha: 0.08 * bendAmount),
      Colors.white.withValues(alpha: 0.06 * bendAmount),
      Colors.transparent,
    ],
    stops: const [0.0, 0.18, 0.58, 1.0],
  );
}

LinearGradient _buildCornerFlapGradient({
  required CardPeelCorner corner,
  required double bendAmount,
}) {
  final begin = switch (corner) {
    CardPeelCorner.topLeft => Alignment.topLeft,
    CardPeelCorner.topRight => Alignment.topRight,
    CardPeelCorner.bottomLeft => Alignment.bottomLeft,
    CardPeelCorner.bottomRight => Alignment.bottomRight,
  };
  final end = switch (corner) {
    CardPeelCorner.topLeft => Alignment.bottomRight,
    CardPeelCorner.topRight => Alignment.bottomLeft,
    CardPeelCorner.bottomLeft => Alignment.topRight,
    CardPeelCorner.bottomRight => Alignment.topLeft,
  };

  return LinearGradient(
    begin: begin,
    end: end,
    colors: [
      Colors.white.withValues(alpha: 0.08 * bendAmount),
      Colors.transparent,
      Colors.black.withValues(alpha: 0.2 * bendAmount),
    ],
    stops: const [0.0, 0.42, 1.0],
  );
}

class _CornerBaseClipper extends CustomClipper<Path> {
  final CardPeelCorner corner;
  final double revealAmount;

  const _CornerBaseClipper({required this.corner, required this.revealAmount});

  @override
  Path getClip(Size size) {
    final rectPath = Path()..addRect(Offset.zero & size);
    final revealPath = _buildCornerRevealPath(size, corner, revealAmount);
    return Path.combine(PathOperation.difference, rectPath, revealPath);
  }

  @override
  bool shouldReclip(covariant _CornerBaseClipper oldClipper) {
    return oldClipper.corner != corner ||
        oldClipper.revealAmount != revealAmount;
  }
}

class _CornerRevealClipper extends CustomClipper<Path> {
  final CardPeelCorner corner;
  final double revealAmount;

  const _CornerRevealClipper({
    required this.corner,
    required this.revealAmount,
  });

  @override
  Path getClip(Size size) {
    return _buildCornerRevealPath(size, corner, revealAmount);
  }

  @override
  bool shouldReclip(covariant _CornerRevealClipper oldClipper) {
    return oldClipper.corner != corner ||
        oldClipper.revealAmount != revealAmount;
  }
}

class _CornerFlapBandClipper extends CustomClipper<Path> {
  final CardPeelCorner corner;
  final double innerRevealAmount;
  final double outerRevealAmount;

  const _CornerFlapBandClipper({
    required this.corner,
    required this.innerRevealAmount,
    required this.outerRevealAmount,
  });

  @override
  Path getClip(Size size) {
    final outerPath = _buildCornerRevealPath(size, corner, outerRevealAmount);
    if (innerRevealAmount <= 0.0001) {
      return outerPath;
    }

    final innerPath = _buildCornerRevealPath(size, corner, innerRevealAmount);
    return Path.combine(PathOperation.difference, outerPath, innerPath);
  }

  @override
  bool shouldReclip(covariant _CornerFlapBandClipper oldClipper) {
    return oldClipper.corner != corner ||
        oldClipper.innerRevealAmount != innerRevealAmount ||
        oldClipper.outerRevealAmount != outerRevealAmount;
  }
}

Path _buildCornerRevealPath(
  Size size,
  CardPeelCorner corner,
  double revealAmount,
) {
  final double eased = Curves.easeOutCubic.transform(
    revealAmount.clamp(0.0, 1.0),
  );
  final double pullX = size.width * (0.56 * eased);
  final double pullY = size.height * (0.56 * eased);
  final double reachX = size.width * (0.36 * eased);
  final double reachY = size.height * (0.36 * eased);

  switch (corner) {
    case CardPeelCorner.topLeft:
      return Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(reachX, 0, pullX, pullY * 0.26)
        ..quadraticBezierTo(0, reachY, 0, 0)
        ..close();
    case CardPeelCorner.topRight:
      return Path()
        ..moveTo(size.width, 0)
        ..quadraticBezierTo(
          size.width - reachX,
          0,
          size.width - pullX,
          pullY * 0.26,
        )
        ..quadraticBezierTo(size.width, reachY, size.width, 0)
        ..close();
    case CardPeelCorner.bottomLeft:
      return Path()
        ..moveTo(0, size.height)
        ..quadraticBezierTo(
          reachX,
          size.height,
          pullX,
          size.height - (pullY * 0.26),
        )
        ..quadraticBezierTo(0, size.height - reachY, 0, size.height)
        ..close();
    case CardPeelCorner.bottomRight:
      return Path()
        ..moveTo(size.width, size.height)
        ..quadraticBezierTo(
          size.width - reachX,
          size.height,
          size.width - pullX,
          size.height - (pullY * 0.26),
        )
        ..quadraticBezierTo(
          size.width,
          size.height - reachY,
          size.width,
          size.height,
        )
        ..close();
  }
}

LinearGradient _buildBendGradient({
  required CardFlipAxis axis,
  required double bendAmount,
  required double direction,
}) {
  final double shadowAlpha = 0.15 * bendAmount;
  final double highlightAlpha = 0.08 * bendAmount;

  if (axis == CardFlipAxis.vertical) {
    final bool towardBottom = direction >= 0;
    return LinearGradient(
      begin: towardBottom ? Alignment.topCenter : Alignment.bottomCenter,
      end: towardBottom ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.white.withValues(alpha: highlightAlpha),
        Colors.transparent,
        Colors.black.withValues(alpha: shadowAlpha),
      ],
      stops: const [0.0, 0.46, 1.0],
    );
  }

  final bool towardRight = direction >= 0;
  return LinearGradient(
    begin: towardRight ? Alignment.centerLeft : Alignment.centerRight,
    end: towardRight ? Alignment.centerRight : Alignment.centerLeft,
    colors: [
      Colors.white.withValues(alpha: highlightAlpha),
      Colors.transparent,
      Colors.black.withValues(alpha: shadowAlpha),
    ],
    stops: const [0.0, 0.46, 1.0],
  );
}

class _BentCardClipper extends CustomClipper<Path> {
  final CardFlipAxis axis;
  final double bendAmount;
  final double direction;

  const _BentCardClipper({
    required this.axis,
    required this.bendAmount,
    required this.direction,
  });

  @override
  Path getClip(Size size) {
    final double edgePull = bendAmount * size.shortestSide * 0.1;
    final double centerDip = bendAmount * size.shortestSide * 0.16;
    final double sign = direction.sign == 0 ? 1 : direction.sign;

    if (axis == CardFlipAxis.vertical) {
      return Path()
        ..moveTo(edgePull, 0)
        ..quadraticBezierTo(
          size.width / 2,
          centerDip * sign,
          size.width - edgePull,
          0,
        )
        ..quadraticBezierTo(
          size.width + centerDip * 0.35 * sign,
          size.height / 2,
          size.width - edgePull,
          size.height,
        )
        ..quadraticBezierTo(
          size.width / 2,
          size.height - centerDip * sign,
          edgePull,
          size.height,
        )
        ..quadraticBezierTo(
          -centerDip * 0.35 * sign,
          size.height / 2,
          edgePull,
          0,
        )
        ..close();
    }

    return Path()
      ..moveTo(0, edgePull)
      ..quadraticBezierTo(
        size.width / 2,
        -centerDip * sign,
        size.width,
        edgePull,
      )
      ..quadraticBezierTo(
        size.width - centerDip * 0.35 * sign,
        size.height / 2,
        size.width,
        size.height - edgePull,
      )
      ..quadraticBezierTo(
        size.width / 2,
        size.height + centerDip * sign,
        0,
        size.height - edgePull,
      )
      ..quadraticBezierTo(centerDip * 0.35 * sign, size.height / 2, 0, edgePull)
      ..close();
  }

  @override
  bool shouldReclip(covariant _BentCardClipper oldClipper) {
    return oldClipper.axis != axis ||
        oldClipper.bendAmount != bendAmount ||
        oldClipper.direction != direction;
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
      _paintCardBackPattern(canvas, size, rrect);
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

void _paintCardBackPattern(Canvas canvas, Size size, RRect rrect) {
  canvas.save();
  canvas.clipRRect(rrect);

  final rect = Offset.zero & size;
  final insetRect = rect.deflate(4);
  final insetRadius = math.max(0.0, rrect.brRadiusX - 2);
  final insetRRect = RRect.fromRectAndRadius(
    insetRect,
    Radius.circular(insetRadius),
  );

  final innerBorderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = CardPalette.cardBackPattern.withValues(alpha: 0.52);
  canvas.drawRRect(insetRRect, innerBorderPaint);

  final double tile = math.max(8.0, size.shortestSide / 4.8);
  final parquetPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.05
    ..color = CardPalette.cardBackPattern.withValues(alpha: 0.34);
  final grainPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8
    ..strokeCap = StrokeCap.round
    ..color = CardPalette.cardBackPatternSoft.withValues(alpha: 0.28);
  final dotPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = CardPalette.cardBackPattern.withValues(alpha: 0.18);

  for (double y = 9; y <= size.height - 9; y += tile) {
    for (double x = 8; x <= size.width - 8; x += tile) {
      final path = Path()
        ..moveTo(x + tile * 0.5, y)
        ..lineTo(x + tile, y + tile * 0.5)
        ..lineTo(x + tile * 0.5, y + tile)
        ..lineTo(x, y + tile * 0.5)
        ..close();
      canvas.drawPath(path, parquetPaint);
    }
  }

  for (double y = 11; y <= size.height - 11; y += tile * 0.9) {
    final phase = ((y / tile).floor().isEven ? 0.0 : tile * 0.5);
    for (double x = 10; x <= size.width - 10; x += tile) {
      canvas.drawCircle(Offset(x + phase, y), 0.9, dotPaint);
    }
  }

  for (double y = 12; y <= size.height - 12; y += tile * 1.15) {
    final startX = 10 + (((y / tile).floor() & 1) * tile * 0.5);
    for (double x = startX; x <= size.width - 16; x += tile) {
      final curve = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x + tile * 0.32, y - 1.5, x + tile * 0.65, y)
        ..quadraticBezierTo(x + tile * 0.96, y + 1.6, x + tile * 1.2, y);
      canvas.drawPath(curve, grainPaint);
      canvas.drawPath(curve.shift(const Offset(0, 3.2)), grainPaint);
      canvas.drawPath(curve.shift(const Offset(0, 6.4)), grainPaint);
    }
  }

  final center = rect.center;
  final ringPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4
    ..color = CardPalette.cardBackPattern.withValues(alpha: 0.6);
  canvas.drawCircle(center, size.shortestSide * 0.18, ringPaint);
  canvas.drawCircle(center, size.shortestSide * 0.12, ringPaint);

  final petalPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = CardPalette.cardBackPatternSoft.withValues(alpha: 0.54);
  for (int i = 0; i < 8; i++) {
    final a = (i / 8.0) * math.pi * 2;
    final p = Offset(
      center.dx + math.cos(a) * size.shortestSide * 0.12,
      center.dy + math.sin(a) * size.shortestSide * 0.12,
    );
    canvas.drawCircle(p, size.shortestSide * 0.035, petalPaint);
  }

  canvas.restore();
}
