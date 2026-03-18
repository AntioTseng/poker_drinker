import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/widgets/playing_card_widget.dart';
import '../../../core/i18n/app_locale.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/pyramid_game_logic.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';
import '../widgets/deck_pile_widget.dart';
import '../widgets/guess_buttons.dart';
import '../widgets/pyramid_card_widget.dart';

const _gameBackgroundTop = Color(0xFF14080D);
const _gameBackgroundBottom = Color(0xFF34111A);
const _gamePanelTop = Color(0xFF4A1620);
const _gamePanelBottom = Color(0xFF2A1015);
const _gameGold = Color(0xFFE8C98D);
const _gameText = Color(0xFFF8EEDA);
const _gameMuted = Color(0xFFD2B89C);

class PyramidGamePage extends StatefulWidget {
  final PyramidSettings settings;

  const PyramidGamePage({super.key, this.settings = const PyramidSettings()});

  @override
  State<PyramidGamePage> createState() => _PyramidGamePageState();
}

class _PyramidGamePageState extends State<PyramidGamePage>
    with TickerProviderStateMixin {
  static const double _manualRevealWidth = 108;
  static const double _manualRevealHeight = 152;

  late PyramidGameLogic gameLogic;
  bool _isCoverAnimating = false;
  bool _isManualRevealActive = false;
  bool _isManualRevealCompleted = false;
  bool _isManualRevealResultVisible = false;
  double _manualRevealProgress = 0;
  Offset _manualRevealVector = const Offset(1, 0);
  bool _isManualRevealGestureLocked = false;

  final GlobalKey _deckCardGlobalKey = GlobalKey();
  final GlobalKey _deckPileAnchorKey = GlobalKey();
  final GlobalKey _boardGlobalKey = GlobalKey();
  late List<List<GlobalKey>> _pyramidCardKeys;
  late List<GlobalKey> _pyramidLayerRowKeys;

  static const double _cardWidth = 58;
  static const double _cardHeight = 78;
  static const double _rowLabelWidth = 70;
  static const double _compactRowLabelWidth = 56;
  static const double _cardSlotWidth = 60;
  static const double _pyramidAreaWidth = _cardSlotWidth * 4;
  static const double _gameTableGap = 28;

  PlayingCard? _flyingDeckCard;
  Rect? _flyStartRect;
  Rect? _flyEndRect;
  AnimationController? _flyController;

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

  void _resetManualRevealState() {
    _isManualRevealActive = false;
    _isManualRevealCompleted = false;
    _isManualRevealResultVisible = false;
    _manualRevealProgress = 0;
    _manualRevealVector = const Offset(1, 0);
    _isManualRevealGestureLocked = false;
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
    });
  }

  void _triggerCoverAnimationAfterRevealClose() {
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
        final totalWidth = layerLen * _cardSlotWidth;
        final startLeft = rowRect.left + (rowRect.width - totalWidth) / 2;
        final left =
            startLeft +
            (gameLogic.selectedIndex! * _cardSlotWidth) +
            ((_cardSlotWidth - _cardWidth) / 2);
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

  Future<void> _handleGuess({required bool isBiggerGuess}) async {
    setState(() {
      if (isBiggerGuess) {
        gameLogic.guessBigger();
      } else {
        gameLogic.guessSmaller();
      }

      if (gameLogic.currentDeckCard != null) {
        _isManualRevealActive = true;
        _isManualRevealCompleted = false;
        _isManualRevealResultVisible = false;
        _manualRevealProgress = 0;
        _manualRevealVector = const Offset(1, 0);
        _isManualRevealGestureLocked = false;
      } else {
        _resetManualRevealState();
      }
    });
  }

  Future<void> _completeManualReveal() async {
    if (_isManualRevealCompleted || !_isManualRevealActive) {
      return;
    }

    setState(() {
      _manualRevealProgress = 1;
      _isManualRevealCompleted = true;
      _isManualRevealResultVisible = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted || !_isManualRevealActive || !_isManualRevealCompleted) {
      return;
    }

    setState(() {
      _isManualRevealResultVisible = true;
    });
  }

  void _handleManualRevealPanStart(DragStartDetails details) {
    if (!_isManualRevealActive || _isManualRevealCompleted) {
      return;
    }

    _isManualRevealGestureLocked = false;
  }

  void _handleManualRevealPanUpdate(DragUpdateDetails details) {
    if (!_isManualRevealActive || _isManualRevealCompleted) {
      return;
    }

    final Offset delta = details.delta;
    if (!_isManualRevealGestureLocked) {
      if (delta.distance < 2) {
        return;
      }
      _manualRevealVector = _normalizedOrFallback(delta);
      _isManualRevealGestureLocked = true;
    }

    final double alignedDelta =
        (delta.dx * _manualRevealVector.dx) +
        (delta.dy * _manualRevealVector.dy);
    final double diagonalExtent =
        (Offset(_manualRevealWidth, _manualRevealHeight).distance) * 2.45;
    final double progressDelta = alignedDelta / diagonalExtent;
    final double next = (_manualRevealProgress + progressDelta).clamp(0.0, 1.0);

    if (next == _manualRevealProgress) {
      return;
    }

    setState(() {
      _manualRevealProgress = next;
    });

    if (next >= 1) {
      _completeManualReveal();
    }
  }

  void _handleManualRevealPanEnd(DragEndDetails details) {
    _isManualRevealGestureLocked = false;

    if (_manualRevealProgress >= 0.985) {
      _completeManualReveal();
    }
  }

  Future<void> _handleManualRevealTap(TapUpDetails details) async {
    if (!_isManualRevealActive || _isManualRevealCompleted) {
      return;
    }

    setState(() {
      _manualRevealVector = _normalizedOrFallback(
        Offset(
          details.localPosition.dx - ((_manualRevealWidth + 8) / 2),
          details.localPosition.dy - ((_manualRevealHeight + 8) / 2),
        ),
      );
    });

    await _completeManualReveal();
  }

  Offset _normalizedOrFallback(Offset value) {
    if (value.distance == 0) {
      return const Offset(1, 0);
    }
    return value / value.distance;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  bool get _didPlayerLose => gameLogic.penalty > 0;

  Color get _resultAccentColor =>
      _didPlayerLose ? const Color(0xFFB14E3A) : const Color(0xFF2F7A4E);

  bool get _isZhLocale {
    return AppLocale.code.value.toLowerCase().startsWith('zh');
  }

  String get _deckPanelTitle {
    return _isZhLocale ? '抽牌堆' : 'Draw pile';
  }

  String get _deckPanelSubtitle {
    return _isZhLocale
        ? '翻開下一張牌來驗證你的判斷'
        : 'Reveal the next card to test your guess';
  }

  String get _resultHeadline {
    return _didPlayerLose
        ? (_isZhLocale ? '猜錯了' : 'Wrong Guess')
        : (_isZhLocale ? '猜對了' : 'Correct');
  }

  String get _resultPrimaryMessage {
    if (_didPlayerLose) {
      return _isZhLocale
          ? '喝 ${_formatNumber(gameLogic.penalty)} 杯'
          : '${_formatNumber(gameLogic.penalty)} cups';
    }
    return _isZhLocale ? '不用喝' : 'No penalty';
  }

  String get _resultComparisonMessage {
    final selectedCard = gameLogic.selectedCard;
    final deckCard = gameLogic.currentDeckCard;

    if (selectedCard == null || deckCard == null) {
      return '';
    }

    if (deckCard.rank == selectedCard.rank) {
      return _isZhLocale
          ? '${deckCard.rankLabel} = ${selectedCard.rankLabel}'
          : '${deckCard.rankLabel} = ${selectedCard.rankLabel}';
    }

    final bool isHigher = deckCard.rank > selectedCard.rank;
    if (_isZhLocale) {
      return isHigher
          ? '${deckCard.rankLabel} > ${selectedCard.rankLabel}'
          : '${deckCard.rankLabel} < ${selectedCard.rankLabel}';
    }

    return isHigher
        ? '${deckCard.rankLabel} > ${selectedCard.rankLabel}'
        : '${deckCard.rankLabel} < ${selectedCard.rankLabel}';
  }

  String get _penaltyBreakdownFormula {
    if (!_didPlayerLose || gameLogic.selectedLayer == null) {
      return '';
    }

    final int layerNumber = gameLogic.selectedLayer! + 1;
    final int layerMultiplier = gameLogic.settings.multiplierForLayer(
      gameLogic.selectedLayer!,
    );
    final int cardCount = gameLogic.selectedPileCardCount;
    final String unitValue = _formatNumber(gameLogic.settings.initialUnit);
    final List<String> parts = <String>[
      _isZhLocale
          ? '第$layerNumber層×$layerMultiplier'
          : 'L$layerNumber×$layerMultiplier',
      _isZhLocale ? '$cardCount張' : '$cardCount cards',
      _isZhLocale ? '$unitValue杯' : '$unitValue cup',
    ];

    final selectedCard = gameLogic.selectedCard;
    final deckCard = gameLogic.currentDeckCard;
    final bool isTie =
        selectedCard != null &&
        deckCard != null &&
        selectedCard.rank == deckCard.rank;
    if (isTie) {
      parts.add(
        _isZhLocale
            ? '撞柱×${_formatNumber(gameLogic.settings.tiePenalty)}'
            : 'tie×${_formatNumber(gameLogic.settings.tiePenalty)}',
      );
    }

    final String total = _isZhLocale
        ? '= ${_formatNumber(gameLogic.penalty)}杯'
        : '= ${_formatNumber(gameLogic.penalty)} cups';
    return '${parts.join(' · ')}  $total';
  }

  void _handleManualRevealContinue() {
    if (!mounted) {
      return;
    }

    setState(_resetManualRevealState);
    _triggerCoverAnimationAfterRevealClose();
  }

  IconData _iconForRevealVector() {
    final dx = _manualRevealVector.dx;
    final dy = _manualRevealVector.dy;

    if (dx.abs() > dy.abs() * 1.4) {
      return dx >= 0 ? Icons.west_rounded : Icons.east_rounded;
    }
    if (dy.abs() > dx.abs() * 1.4) {
      return dy >= 0 ? Icons.north_rounded : Icons.south_rounded;
    }
    if (dx >= 0 && dy >= 0) {
      return Icons.north_west_rounded;
    }
    if (dx < 0 && dy >= 0) {
      return Icons.north_east_rounded;
    }
    if (dx >= 0 && dy < 0) {
      return Icons.south_west_rounded;
    }
    return Icons.south_east_rounded;
  }

  Widget _buildManualRevealOverlay() {
    final selectedCard = gameLogic.selectedCard;
    final deckCard = gameLogic.currentDeckCard;

    if (!_isManualRevealActive || selectedCard == null || deckCard == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.34),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_gamePanelTop, _gamePanelBottom],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 26,
                      offset: Offset(0, 12),
                    ),
                  ],
                  border: Border.all(color: _gameGold.withValues(alpha: 0.18)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: _isManualRevealResultVisible ? 0.72 : 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildManualRevealCardFrame(
                              child: PlayingCardWidget(
                                card: selectedCard,
                                width: _manualRevealWidth,
                                height: _manualRevealHeight,
                                flipDuration: Duration.zero,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 56,
                              ),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 180),
                                opacity: _isManualRevealCompleted ? 0 : 1,
                                child: Icon(
                                  _iconForRevealVector(),
                                  color: _gameGold,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: _handleManualRevealTap,
                              onPanStart: _handleManualRevealPanStart,
                              onPanUpdate: _handleManualRevealPanUpdate,
                              onPanEnd: _handleManualRevealPanEnd,
                              child: _buildManualRevealCardFrame(
                                accent: _manualRevealProgress > 0
                                    ? _gameGold
                                    : const Color(0xFFB57462),
                                child: PlayingCardWidget(
                                  card: deckCard,
                                  width: _manualRevealWidth,
                                  height: _manualRevealHeight,
                                  flipDuration: Duration.zero,
                                  flipProgress: _manualRevealProgress,
                                  flipVector: _manualRevealVector,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: _isManualRevealResultVisible
                            ? _buildManualRevealResultSection()
                            : const SizedBox(height: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualRevealCardFrame({required Widget child, Color? accent}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B10).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: (accent ?? _gameGold).withValues(alpha: 0.28),
        ),
      ),
      child: child,
    );
  }

  Widget _buildManualRevealResultSection() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      key: const ValueKey('manual-reveal-result'),
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _resultAccentColor.withValues(alpha: 0.18),
                  const Color(0xFF221016),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _resultAccentColor.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: _resultAccentColor.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _resultAccentColor.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      _resultHeadline,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: _resultAccentColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _resultPrimaryMessage,
                    textAlign: TextAlign.center,
                    style:
                        (_didPlayerLose
                                ? textTheme.displaySmall
                                : textTheme.headlineMedium)
                            ?.copyWith(
                              color: _resultAccentColor,
                              fontWeight: FontWeight.w900,
                              height: 0.98,
                            ),
                  ),
                  if (_resultComparisonMessage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _resultComparisonMessage,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: _gameText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                  if (_didPlayerLose &&
                      _penaltyBreakdownFormula.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _resultAccentColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isZhLocale ? '計算方式' : 'Calculation',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: _resultAccentColor.withValues(alpha: 0.82),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _penaltyBreakdownFormula,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: _gameText,
                              fontWeight: FontWeight.w800,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleManualRevealContinue,
              child: Text(PyramidPokerStrings.get('coverSelectedCardButton')),
            ),
          ),
        ],
      ),
    );
  }

  double _rowLabelWidthFor(bool compact) {
    return compact ? _compactRowLabelWidth : _rowLabelWidth;
  }

  double get _compactStageWidth => _rowLabelWidthFor(true) + _pyramidAreaWidth;

  Widget _buildMultiplierRailItem({
    required int layerIndex,
    required bool isFirst,
    required bool isLast,
    required bool compact,
  }) {
    final multiplier = gameLogic.settings.multiplierForLayer(layerIndex);
    final railWidth = _rowLabelWidthFor(compact);
    final markerLeft = compact ? 6.0 : 8.0;
    final lineLeft = compact ? 11.0 : 14.0;
    final connectorLeft = compact ? 16.0 : 20.0;
    final connectorRight = compact ? 8.0 : 10.0;
    final markerSize = compact ? 12.0 : 14.0;
    final pillVertical = compact ? 4.0 : 5.0;
    final pillHorizontal = compact ? 8.0 : 10.0;

    return SizedBox(
      width: railWidth,
      height: _cardHeight + 8,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            left: lineLeft,
            top: isFirst ? (_cardHeight + 8) / 2 : 0,
            bottom: isLast ? (_cardHeight + 8) / 2 : 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: AppTheme.secondaryAccent.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            left: markerLeft,
            child: Container(
              width: markerSize,
              height: markerSize,
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.pageBackground, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: connectorLeft,
            right: connectorRight,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondaryAccent.withValues(alpha: 0.45),
                    AppTheme.secondaryAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: pillHorizontal,
                vertical: pillVertical,
              ),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppTheme.secondaryAccent.withValues(alpha: 0.22),
                ),
              ),
              child: Text(
                'x$multiplier',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 11 : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPyramid({required bool compact}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: gameLogic.pyramid.layers.asMap().entries.map((entry) {
        final int layerIndex = entry.key;
        final List<PlayingCard> layer = entry.value;
        final bool isFirst = layerIndex == 0;
        final bool isLast = layerIndex == gameLogic.pyramid.layers.length - 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMultiplierRailItem(
                layerIndex: layerIndex,
                isFirst: isFirst,
                isLast: isLast,
                compact: compact,
              ),
              SizedBox(
                width: _pyramidAreaWidth,
                child: SizedBox(
                  key: _pyramidLayerRowKeys[layerIndex],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: layer.asMap().entries.map((cardEntry) {
                      final int cardIndex = cardEntry.key;
                      final PlayingCard card = cardEntry.value;

                      return SizedBox(
                        width: _cardSlotWidth,
                        key: _pyramidCardKeys[layerIndex][cardIndex],
                        child: Center(
                          child: PyramidCardWidget(
                            card: card,
                            cardCount: gameLogic.pileCardCountFor(
                              layerIndex,
                              cardIndex,
                            ),
                            isSelected:
                                gameLogic.selectedLayer == layerIndex &&
                                gameLogic.selectedIndex == cardIndex,
                            onTap: () {
                              setState(() {
                                gameLogic.selectCard(layerIndex, cardIndex);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGuessButtons({required bool compact}) {
    final selectedCard = gameLogic.selectedCard;
    final bool isInteractionLocked = _isCoverAnimating || _isManualRevealActive;

    return Padding(
      padding: EdgeInsets.only(top: compact ? 12 : 14),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            compact ? 12 : 14,
            compact ? 12 : 14,
            compact ? 12 : 14,
            compact ? 12 : 14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_gamePanelTop, _gamePanelBottom],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isZhLocale ? '你的判斷' : 'Your call',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _gameGold,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              GuessButtons(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDeckHeader() {
    final compactDeckWidget = DeckPileWidget(
      deck: gameLogic.pyramid.deck,
      currentDeckCard: gameLogic.currentDeckCard,
      currentDeckCardAnchorKey: _deckCardGlobalKey,
      pileAnchorKey: _deckPileAnchorKey,
      cardFaceWidth: 42,
      cardFaceHeight: 60,
      stackOffset: 0.65,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _gameGold.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _gameGold.withValues(alpha: 0.12)),
            ),
            child: Center(child: compactDeckWidget),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _deckPanelTitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _gameGold,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isZhLocale
                      ? '主桌用牌，保持輕量呈現。'
                      : 'Support deck, kept visually secondary.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _gameMuted.withValues(alpha: 0.82),
                    height: 1.3,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      icon: Icons.style_rounded,
                      text: _isZhLocale
                          ? '剩餘 ${gameLogic.pyramid.deck.length} 張'
                          : '${gameLogic.pyramid.deck.length} cards left',
                      compact: true,
                    ),
                    _buildInfoChip(
                      icon: Icons.local_bar_rounded,
                      text: _isZhLocale
                          ? '單位 ${_formatNumber(gameLogic.settings.initialUnit)} 杯'
                          : 'Unit ${_formatNumber(gameLogic.settings.initialUnit)} cup',
                      compact: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactGameStage() {
    final stage = SizedBox(
      width: _compactStageWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPyramid(compact: true),
          if (gameLogic.selectedCard != null &&
              gameLogic.selectedCard!.isFaceUp)
            SizedBox(
              width: _compactStageWidth,
              child: _buildGuessButtons(compact: true),
            ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _compactStageWidth) {
          return stage;
        }

        return SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: stage,
          ),
        );
      },
    );
  }

  Widget _buildDeckArea({required bool compact}) {
    final deckWidget = DeckPileWidget(
      deck: gameLogic.pyramid.deck,
      currentDeckCard: gameLogic.currentDeckCard,
      currentDeckCardAnchorKey: _deckCardGlobalKey,
      pileAnchorKey: _deckPileAnchorKey,
    );

    if (compact) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_gamePanelTop, _gamePanelBottom],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 64, child: Center(child: deckWidget)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _deckPanelTitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _gameGold,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.style_rounded,
                        text: _isZhLocale
                            ? '剩餘 ${gameLogic.pyramid.deck.length} 張'
                            : '${gameLogic.pyramid.deck.length} cards left',
                        compact: true,
                      ),
                      _buildInfoChip(
                        icon: Icons.local_bar_rounded,
                        text: _isZhLocale
                            ? '單位 ${_formatNumber(gameLogic.settings.initialUnit)} 杯'
                            : 'Unit ${_formatNumber(gameLogic.settings.initialUnit)} cup',
                        compact: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 168,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gamePanelTop, _gamePanelBottom],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _deckPanelTitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _gameGold,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _deckPanelSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _gameMuted,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Center(child: deckWidget),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildInfoChip(
                icon: Icons.style_rounded,
                text: _isZhLocale
                    ? '剩餘 ${gameLogic.pyramid.deck.length} 張'
                    : '${gameLogic.pyramid.deck.length} cards left',
                compact: false,
              ),
              _buildInfoChip(
                icon: Icons.local_bar_rounded,
                text: _isZhLocale
                    ? '單位 ${_formatNumber(gameLogic.settings.initialUnit)} 杯'
                    : 'Unit ${_formatNumber(gameLogic.settings.initialUnit)} cup',
                compact: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required bool compact,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 7 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 13 : 14, color: _gameGold),
          SizedBox(width: compact ? 5 : 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _gameText,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 11 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablePanel({required Widget child, required bool compact}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        compact ? 10 : 14,
        compact ? 12 : 14,
        compact ? 10 : 14,
        compact ? 12 : 14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gamePanelTop, _gamePanelBottom],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _gameBackgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: _gameGold,
        surfaceTintColor: Colors.transparent,
        title: Text(PyramidPokerStrings.get('gameTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isCoverAnimating = false;
                _resetManualRevealState();
                _flyingDeckCard = null;
                _flyStartRect = null;
                _flyEndRect = null;
                _flyController?.dispose();
                _flyController = null;
                gameLogic.resetGame();
                gameLogic.settings = widget.settings;
                _pyramidCardKeys = _createPyramidCardKeys();
                _pyramidLayerRowKeys = List<GlobalKey>.generate(
                  gameLogic.pyramid.layers.length,
                  (_) => GlobalKey(),
                );
              });
            },
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isCompact = constraints.maxWidth < 520;

            return Stack(
              key: _boardGlobalKey,
              fit: StackFit.expand,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_gameBackgroundTop, _gameBackgroundBottom],
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 10 : 12,
                      isCompact ? 12 : 18,
                      isCompact ? 10 : 12,
                      18,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isCompact ? 352 : 860,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isCompact) ...[
                            _buildTablePanel(
                              compact: true,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCompactDeckHeader(),
                                  const SizedBox(height: 14),
                                  _buildCompactGameStage(),
                                ],
                              ),
                            ),
                          ] else ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTablePanel(
                                    compact: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildPyramid(compact: false),
                                        if (gameLogic.selectedCard != null &&
                                            gameLogic.selectedCard!.isFaceUp)
                                          _buildGuessButtons(compact: false),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: _gameTableGap),
                                _buildDeckArea(compact: false),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFlyingCardOverlay(),
                _buildManualRevealOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }
}
