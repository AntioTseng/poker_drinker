import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';
import '../logic/pyramid_game_logic.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';
import '../widgets/deck_pile_widget.dart';
import '../widgets/guess_buttons.dart';
import '../widgets/pyramid_card_widget.dart';
import '../widgets/result_dialog.dart';

class PyramidGamePage extends StatefulWidget {
  final PyramidSettings settings;

  const PyramidGamePage({super.key, this.settings = const PyramidSettings()});

  @override
  State<PyramidGamePage> createState() => _PyramidGamePageState();
}

class _PyramidGamePageState extends State<PyramidGamePage>
    with TickerProviderStateMixin {
  late PyramidGameLogic gameLogic;
  bool _isDialogShowing = false;
  bool _pendingResultDialogAfterDeckFlip = false;
  bool _isCoverAnimating = false;

  final GlobalKey _deckCardGlobalKey = GlobalKey();
  final GlobalKey _deckPileAnchorKey = GlobalKey();
  final GlobalKey _boardGlobalKey = GlobalKey();
  late List<List<GlobalKey>> _pyramidCardKeys;
  late List<GlobalKey> _pyramidLayerRowKeys;

  static const double _cardWidth = 58;
  static const double _cardHeight = 78;

  PlayingCard? _flyingDeckCard;
  Rect? _flyStartRect;
  Rect? _flyEndRect;
  AnimationController? _flyController;
  Animation<double>? _flyAnimation;

  @override
  void initState() {
    super.initState();
    gameLogic = PyramidGameLogic.initial();
    gameLogic.settings = widget.settings;
    _pyramidCardKeys = _createPyramidCardKeys();
    _pyramidLayerRowKeys = List<GlobalKey>.generate(
      gameLogic.pyramid.layers.length,
      (_) => GlobalKey(),
    );
  }

  List<List<GlobalKey>> _createPyramidCardKeys() {
    return gameLogic.pyramid.layers
        .map(
          (layer) => List<GlobalKey>.generate(layer.length, (_) => GlobalKey()),
        )
        .toList();
  }

  Rect? _rectForKey(GlobalKey key, {RenderBox? ancestor}) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return null;
    }

    final offset = renderObject.localToGlobal(Offset.zero, ancestor: ancestor);
    return offset & renderObject.size;
  }

  @override
  void dispose() {
    _flyController?.dispose();
    super.dispose();
  }

  void _coverImmediately() {
    if (!mounted) {
      return;
    }
    setState(() {
      gameLogic.coverSelectedCardWithDeckCard();
      _isCoverAnimating = false;
      _flyingDeckCard = null;
      _flyStartRect = null;
      _flyEndRect = null;
      _flyController?.dispose();
      _flyController = null;
      _flyAnimation = null;
    });
  }

  void _triggerCoverAnimationAfterDialogClose() {
    if (_isCoverAnimating) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _attemptCoverAnimation();
    });
  }

  Future<void> _attemptCoverAnimation() async {
    if (!mounted) {
      return;
    }

    final stopwatch = Stopwatch()..start();
    while (mounted && stopwatch.elapsed < const Duration(milliseconds: 600)) {
      bool didAnimate = false;
      try {
        didAnimate = await _tryAnimateCoverSelectedCardWithDeckCard();
      } catch (_) {
        // Ignore and try again until timeout.
      }

      if (didAnimate) {
        return;
      }

      await Future<void>.delayed(const Duration(milliseconds: 16));
    }

    _coverImmediately();
  }

  Future<bool> _tryAnimateCoverSelectedCardWithDeckCard() async {
    if (_isCoverAnimating) {
      return true;
    }

    final deckCard = gameLogic.currentDeckCard;
    if (deckCard == null ||
        gameLogic.selectedLayer == null ||
        gameLogic.selectedIndex == null) {
      return false;
    }

    final boardRenderObject = _boardGlobalKey.currentContext
        ?.findRenderObject();
    if (boardRenderObject is! RenderBox) {
      return false;
    }

    Rect? startRect = _rectForKey(
      _deckCardGlobalKey,
      ancestor: boardRenderObject,
    );
    final endRect = _rectForKey(
      _pyramidCardKeys[gameLogic.selectedLayer!][gameLogic.selectedIndex!],
      ancestor: boardRenderObject,
    );

    if (startRect == null) {
      final pileRect = _rectForKey(
        _deckPileAnchorKey,
        ancestor: boardRenderObject,
      );
      if (pileRect != null) {
        final double left = pileRect.left + (pileRect.width - _cardWidth) / 2;
        final double top = pileRect.top + gameLogic.pyramid.deck.length * 2.0;
        startRect = Rect.fromLTWH(left, top, _cardWidth, _cardHeight);
      }
    }

    Rect? resolvedEndRect = endRect;
    if (resolvedEndRect == null) {
      final rowRect = _rectForKey(
        _pyramidLayerRowKeys[gameLogic.selectedLayer!],
        ancestor: boardRenderObject,
      );
      if (rowRect != null) {
        final layerLen =
            gameLogic.pyramid.layers[gameLogic.selectedLayer!].length;
        final totalWidth = layerLen * _cardWidth;
        final startLeft = rowRect.left + (rowRect.width - totalWidth) / 2;
        final left = startLeft + gameLogic.selectedIndex! * _cardWidth;
        resolvedEndRect = Rect.fromLTWH(
          left,
          rowRect.top,
          _cardWidth,
          _cardHeight,
        );
      }
    }

    if (startRect == null || resolvedEndRect == null) {
      return false;
    }

    try {
      _flyController?.dispose();
      _flyController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );
      _flyAnimation = CurvedAnimation(
        parent: _flyController!,
        curve: Curves.easeInOut,
      );

      setState(() {
        _isCoverAnimating = true;
        _flyingDeckCard = deckCard;
        _flyStartRect = startRect;
        _flyEndRect = resolvedEndRect;
      });

      // Ensure the flying card is laid out before we start the controller.
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) {
        setState(() {});
      }

      await _flyController!.forward();

      if (!mounted) {
        return false;
      }

      setState(() {
        gameLogic.coverSelectedCardWithDeckCard();
        _isCoverAnimating = false;
        _flyingDeckCard = null;
        _flyStartRect = null;
        _flyEndRect = null;
        _flyController?.dispose();
        _flyController = null;
        _flyAnimation = null;
      });

      return true;
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCoverAnimating = false;
          _flyingDeckCard = null;
          _flyStartRect = null;
          _flyEndRect = null;
          _flyController?.dispose();
          _flyController = null;
          _flyAnimation = null;
        });
      }
      return false;
    }
  }

  Widget _buildFlyingCardOverlay() {
    final card = _flyingDeckCard;
    final start = _flyStartRect;
    final end = _flyEndRect;
    final controller = _flyController;

    if (!_isCoverAnimating ||
        card == null ||
        start == null ||
        end == null ||
        controller == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        final rect = Rect.lerp(start, end, t)!;
        return Positioned(
          left: rect.left,
          top: rect.top,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: rect.width,
                height: rect.height,
                child: PlayingCardWidget(
                  card: card,
                  flipDuration: Duration.zero,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResultDialog() async {
    if (_isDialogShowing || gameLogic.result.isEmpty) {
      return;
    }

    _isDialogShowing = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ResultDialog(
          result: gameLogic.result,
          penalty: gameLogic.penalty,
          penaltyExplain: gameLogic.penaltyExplain,
          onCover: () {
            Navigator.of(dialogContext).pop();
            _triggerCoverAnimationAfterDialogClose();
          },
        );
      },
    );

    _isDialogShowing = false;
  }

  Future<void> _handleGuess({required bool isBiggerGuess}) async {
    setState(() {
      if (isBiggerGuess) {
        gameLogic.guessBigger();
      } else {
        gameLogic.guessSmaller();
      }
    });

    _pendingResultDialogAfterDeckFlip = gameLogic.currentDeckCard != null;

    if (!_pendingResultDialogAfterDeckFlip) {
      await _showResultDialog();
    }
  }

  Future<void> _onDeckCardFlipCompleted() async {
    if (!mounted) {
      return;
    }

    if (!_pendingResultDialogAfterDeckFlip) {
      return;
    }

    _pendingResultDialogAfterDeckFlip = false;
    await _showResultDialog();
  }

  Widget _buildPyramid() {
    return Column(
      children: gameLogic.pyramid.layers.asMap().entries.map((entry) {
        final int layerIndex = entry.key;
        final List<PlayingCard> layer = entry.value;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'x${gameLogic.settings.multiplierForLayer(layerIndex)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                key: _pyramidLayerRowKeys[layerIndex],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: layer.asMap().entries.map((cardEntry) {
                    final int cardIndex = cardEntry.key;
                    final PlayingCard card = cardEntry.value;

                    return SizedBox(
                      key: _pyramidCardKeys[layerIndex][cardIndex],
                      child: PyramidCardWidget(
                        card: card,
                        cardCount: gameLogic.pileCardCountFor(
                          layerIndex,
                          cardIndex,
                        ),
                        onTap: () {
                          setState(() {
                            gameLogic.selectCard(layerIndex, cardIndex);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGuessButtons() {
    final selectedCard = gameLogic.selectedCard;
    final bool isInteractionLocked =
        _pendingResultDialogAfterDeckFlip || _isCoverAnimating;

    return GuessButtons(
      biggerLabel: selectedCard != null
          ? PyramidPokerStrings.format('guessHigherWithRank', {
              'rank': selectedCard.rank.toString(),
            })
          : PyramidPokerStrings.get('guessHigher'),
      smallerLabel: selectedCard != null
          ? PyramidPokerStrings.format('guessLowerWithRank', {
              'rank': selectedCard.rank.toString(),
            })
          : PyramidPokerStrings.get('guessLower'),
      onGuessBigger:
          !isInteractionLocked &&
              gameLogic.canGuess &&
              gameLogic.pyramid.deck.isNotEmpty &&
              gameLogic.selectedLayer != null &&
              gameLogic.selectedIndex != null
          ? () => _handleGuess(isBiggerGuess: true)
          : null,
      onGuessSmaller:
          !isInteractionLocked &&
              gameLogic.canGuess &&
              gameLogic.pyramid.deck.isNotEmpty &&
              gameLogic.selectedLayer != null &&
              gameLogic.selectedIndex != null
          ? () => _handleGuess(isBiggerGuess: false)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PyramidPokerStrings.get('gameTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _pendingResultDialogAfterDeckFlip = false;
                _isCoverAnimating = false;
                _flyingDeckCard = null;
                _flyStartRect = null;
                _flyEndRect = null;
                _flyController?.dispose();
                _flyController = null;
                _flyAnimation = null;
                gameLogic.resetGame();
                gameLogic.settings = widget.settings;
                _pyramidCardKeys = _createPyramidCardKeys();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          key: _boardGlobalKey,
          fit: StackFit.expand,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPyramid(),
                        if (gameLogic.selectedCard != null &&
                            gameLogic.selectedCard!.isFaceUp)
                          _buildGuessButtons(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DeckPileWidget(
                      deck: gameLogic.pyramid.deck,
                      currentDeckCard: _isCoverAnimating
                          ? null
                          : gameLogic.currentDeckCard,
                      onCurrentDeckCardFlipCompleted: _onDeckCardFlipCompleted,
                      currentDeckCardAnchorKey: _deckCardGlobalKey,
                      pileAnchorKey: _deckPileAnchorKey,
                    ),
                  ),
                ],
              ),
            ),
            _buildFlyingCardOverlay(),
          ],
        ),
      ),
    );
  }
}
