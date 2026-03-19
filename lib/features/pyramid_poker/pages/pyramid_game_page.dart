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
  bool? _isCurrentGuessBigger;

  final GlobalKey _deckCardGlobalKey = GlobalKey();
  final GlobalKey _deckPileAnchorKey = GlobalKey();
  final GlobalKey _boardGlobalKey = GlobalKey();
  late List<List<GlobalKey>> _pyramidCardKeys;
  late List<GlobalKey> _pyramidLayerRowKeys;

  static const double _regularCardFaceWidth = 50;
  static const double _regularCardFaceHeight = 70;
  static const double _compactCardFaceWidth = 60;
  static const double _compactCardFaceHeight = 84;
  static const double _rowLabelWidth = 70;
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
    _isCurrentGuessBigger = null;
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
      final compact = _isCompactViewport;
      final pileRect = _rectForKey(
        _deckPileAnchorKey,
        ancestor: boardRenderObject,
      );
      if (pileRect != null) {
        final double left =
            pileRect.left + (pileRect.width - _cardOuterWidthFor(compact)) / 2;
        final double top = pileRect.top + gameLogic.pyramid.deck.length * 2.0;
        startRect = Rect.fromLTWH(
          left,
          top,
          _cardOuterWidthFor(compact),
          _cardOuterHeightFor(compact),
        );
      }
    }

    Rect? resolvedEndRect = endRect;
    if (resolvedEndRect == null) {
      final compact = _isCompactViewport;
      final rowRect = _rectForKey(
        _pyramidLayerRowKeys[gameLogic.selectedLayer!],
        ancestor: boardRenderObject,
      );
      if (rowRect != null) {
        final layerLen =
            gameLogic.pyramid.layers[gameLogic.selectedLayer!].length;
        final totalWidth = layerLen * _cardSlotWidthFor(compact);
        final startLeft = rowRect.left + (rowRect.width - totalWidth) / 2;
        final left =
            startLeft +
            (gameLogic.selectedIndex! * _cardSlotWidthFor(compact)) +
            ((_cardSlotWidthFor(compact) - _cardOuterWidthFor(compact)) / 2);
        resolvedEndRect = Rect.fromLTWH(
          left,
          rowRect.top,
          _cardOuterWidthFor(compact),
          _cardOuterHeightFor(compact),
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
      _isCurrentGuessBigger = isBiggerGuess;

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

  String get _actionConsolePrompt {
    return _isZhLocale
        ? '判斷下一張更大還是更小'
        : 'Call whether the next card will be higher or lower';
  }

  String get _currentGuessSymbol {
    if (_isCurrentGuessBigger == null) {
      return '?';
    }
    return _isCurrentGuessBigger! ? '<' : '>';
  }

  PlayingCard? get _visibleDeckPileCard {
    if (_isManualRevealActive || _isCoverAnimating) {
      return null;
    }
    return gameLogic.currentDeckCard;
  }

  double _basePenaltyForLayer({
    required int layerIndex,
    required int cardCount,
  }) {
    final multiplier = gameLogic.settings.multiplierForLayer(layerIndex);
    return multiplier * cardCount * gameLogic.settings.initialUnit;
  }

  Future<void> _showInfoSheet({
    required String title,
    String? subtitle,
    required List<MapEntry<String, String>> items,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_gamePanelTop, _gamePanelBottom],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _gameGold.withValues(alpha: 0.16)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 22,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _gameGold.withValues(alpha: 0.24),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        color: _gameText,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: _gameMuted,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    for (final item in items) ...[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _gameGold.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.key,
                                style: textTheme.bodySmall?.copyWith(
                                  color: _gameMuted,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                item.value,
                                textAlign: TextAlign.right,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: _gameText,
                                  fontWeight: FontWeight.w800,
                                  height: 1.35,
                                ),
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
          ),
        );
      },
    );
  }

  Future<void> _showDeckPileInfoSheet() {
    return _showInfoSheet(
      title: _isZhLocale ? '母牌堆資訊' : 'Draw pile info',
      subtitle: _isZhLocale
          ? '長按母牌堆可快速查看目前剩餘牌數。'
          : 'Long press the draw pile to check how many cards remain.',
      items: [
        MapEntry(
          _isZhLocale ? '目前母牌堆張數' : 'Cards remaining',
          '${gameLogic.pyramid.deck.length}',
        ),
      ],
    );
  }

  Future<void> _showPileInfoSheet({
    required int layerIndex,
    required int cardIndex,
  }) {
    final cardCount = gameLogic.pileCardCountFor(layerIndex, cardIndex);
    final multiplier = gameLogic.settings.multiplierForLayer(layerIndex);
    final unit = gameLogic.settings.initialUnit;
    final tieMultiplier = gameLogic.settings.tiePenalty;
    final loseCups = _basePenaltyForLayer(
      layerIndex: layerIndex,
      cardCount: cardCount,
    );
    final tieCups = loseCups * tieMultiplier;
    final loseFormula =
        '${_formatNumber(loseCups)} = $cardCount × $multiplier × ${_formatNumber(unit)}';
    final tieFormula =
        '${_formatNumber(tieCups)} = $cardCount × $multiplier × ${_formatNumber(unit)} × ${_formatNumber(tieMultiplier)}';

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_gamePanelTop, _gamePanelBottom],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _gameGold.withValues(alpha: 0.16)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 22,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _gameGold.withValues(alpha: 0.24),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildFormulaCard(
                      label: _isZhLocale ? '如果輸' : 'If you lose',
                      formula: loseFormula,
                      note: _isZhLocale
                          ? '$cardCount=這疊張數，$multiplier=這層倍率，${_formatNumber(unit)}=單位杯數'
                          : '$cardCount = pile cards, $multiplier = layer multiplier, ${_formatNumber(unit)} = unit cups',
                    ),
                    const SizedBox(height: 10),
                    _buildFormulaCard(
                      label: _isZhLocale ? '如果撞柱' : 'If it ties',
                      formula: tieFormula,
                      note: _isZhLocale
                          ? '$cardCount=這疊張數，$multiplier=這層倍率，${_formatNumber(unit)}=單位杯數，${_formatNumber(tieMultiplier)}=撞柱倍率'
                          : '$cardCount = pile cards, $multiplier = layer multiplier, ${_formatNumber(unit)} = unit cups, ${_formatNumber(tieMultiplier)} = tie multiplier',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormulaCard({
    required String label,
    required String formula,
    required String note,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _gameGold.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _gameGold.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: _gameGold,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            formula,
            style: textTheme.titleLarge?.copyWith(
              color: _gameText,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: textTheme.bodySmall?.copyWith(
              color: _gameMuted,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
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

  bool get _isTieResult {
    final selectedCard = gameLogic.selectedCard;
    final deckCard = gameLogic.currentDeckCard;
    return selectedCard != null &&
        deckCard != null &&
        selectedCard.rank == deckCard.rank;
  }

  String get _resultAmountValue => _formatNumber(gameLogic.penalty);

  String get _resultAmountUnit {
    return _isZhLocale ? '杯' : 'cups';
  }

  String get _penaltyEquation {
    if (!_didPlayerLose || gameLogic.selectedLayer == null) {
      return '';
    }

    final int layerMultiplier = gameLogic.settings.multiplierForLayer(
      gameLogic.selectedLayer!,
    );
    final int cardCount = gameLogic.selectedPileCardCount;
    final String unitValue = _formatNumber(gameLogic.settings.initialUnit);
    final List<String> factors = <String>[
      '$layerMultiplier',
      '$cardCount',
      unitValue,
    ];

    if (_isTieResult) {
      factors.add(_formatNumber(gameLogic.settings.tiePenalty));
    }

    return factors.join(' × ');
  }

  String get _penaltyNumberLegend {
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
          ? '$layerMultiplier=第$layerNumber層倍率'
          : '$layerMultiplier = row $layerNumber multiplier',
      _isZhLocale ? '$cardCount=這疊張數' : '$cardCount = pile cards',
      _isZhLocale ? '$unitValue=單位杯數' : '$unitValue = unit cups',
    ];

    if (_isTieResult) {
      final String tieMultiplier = _formatNumber(gameLogic.settings.tiePenalty);
      parts.add(
        _isZhLocale ? '$tieMultiplier=撞柱倍率' : '$tieMultiplier = tie multiplier',
      );
    }

    return parts.join('  ·  ');
  }

  void _handleManualRevealContinue() {
    if (!mounted) {
      return;
    }

    setState(_resetManualRevealState);
    _triggerCoverAnimationAfterRevealClose();
  }

  Widget _buildManualRevealOverlay() {
    final selectedCard = gameLogic.selectedCard;
    final deckCard = gameLogic.currentDeckCard;

    if (!_isManualRevealActive || selectedCard == null || deckCard == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.46),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              ),
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _gameGold.withValues(alpha: 0.18),
                                  ),
                                ),
                                child: Text(
                                  _currentGuessSymbol,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: _gameGold,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                      ),
                                ),
                              ),
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
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
                                Positioned(
                                  top: -16,
                                  left: 0,
                                  right: 0,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 180),
                                    opacity: _isManualRevealCompleted ? 0 : 1,
                                    child: Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              _gamePanelTop.withValues(
                                                alpha: 0.92,
                                              ),
                                              _gamePanelBottom.withValues(
                                                alpha: 0.92,
                                              ),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          border: Border.all(
                                            color: _gameGold.withValues(
                                              alpha: 0.14,
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.12,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            _isZhLocale
                                                ? '點擊/拉動'
                                                : 'Tap / drag',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: _gameText.withValues(
                                                    alpha: 0.8,
                                                  ),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 9.5,
                                                  letterSpacing: 0.25,
                                                  height: 1,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    final bool showPenaltyBreakdown =
        _didPlayerLose && _penaltyEquation.isNotEmpty;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _resultAccentColor.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        _resultHeadline,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: _resultAccentColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_didPlayerLose) ...[
                    Text(
                      _isZhLocale ? '這回合要喝' : 'Penalty',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge?.copyWith(
                        color: _gameMuted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _resultAmountValue,
                            style: textTheme.displayMedium?.copyWith(
                              color: _resultAccentColor,
                              fontWeight: FontWeight.w900,
                              height: 0.95,
                            ),
                          ),
                          TextSpan(
                            text: ' $_resultAmountUnit',
                            style: textTheme.headlineSmall?.copyWith(
                              color: _resultAccentColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    Text(
                      _resultPrimaryMessage,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        color: _resultAccentColor,
                        fontWeight: FontWeight.w900,
                        height: 0.98,
                      ),
                    ),
                  if (showPenaltyBreakdown) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _resultAccentColor.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _penaltyEquation,
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              color: _gameText.withValues(alpha: 0.72),
                              fontWeight: FontWeight.w700,
                              height: 1.05,
                            ),
                          ),
                          if (_penaltyNumberLegend.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              _penaltyNumberLegend,
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                color: _gameMuted.withValues(alpha: 0.74),
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                          ],
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
    return compact ? 0 : _rowLabelWidth;
  }

  double _cardFaceWidthFor(bool compact) {
    return compact ? _compactCardFaceWidth : _regularCardFaceWidth;
  }

  double _cardFaceHeightFor(bool compact) {
    return compact ? _compactCardFaceHeight : _regularCardFaceHeight;
  }

  double _cardOuterWidthFor(bool compact) {
    return _cardFaceWidthFor(compact) + 8;
  }

  double _cardOuterHeightFor(bool compact) {
    return _cardFaceHeightFor(compact) + 8;
  }

  double _cardSlotWidthFor(bool compact) {
    return compact ? 70 : 60;
  }

  double _pyramidAreaWidthFor(bool compact) {
    return _cardSlotWidthFor(compact) * 4;
  }

  bool get _isCompactViewport {
    if (!mounted) {
      return false;
    }
    return MediaQuery.sizeOf(context).width < 520;
  }

  double get _compactStageWidth =>
      _rowLabelWidthFor(true) + _pyramidAreaWidthFor(true);

  bool get _canUseCompactSingleColumnStage {
    if (!mounted) {
      return false;
    }

    final viewportWidth = MediaQuery.sizeOf(context).width;
    return _compactStageWidth <= viewportWidth - 32;
  }

  Widget _buildMultiplierRailItem({
    required int layerIndex,
    required bool isFirst,
    required bool isLast,
    required bool compact,
  }) {
    final multiplier = gameLogic.settings.multiplierForLayer(layerIndex);
    final railWidth = _rowLabelWidthFor(compact);
    final markerLeft = compact ? 2.0 : 8.0;
    final lineLeft = compact ? 7.0 : 14.0;
    final connectorLeft = compact ? 12.0 : 20.0;
    final connectorRight = compact ? 3.0 : 10.0;
    final markerSize = compact ? 10.0 : 14.0;
    final pillVertical = compact ? 3.0 : 5.0;
    final pillHorizontal = compact ? 6.0 : 10.0;

    return SizedBox(
      width: railWidth,
      height: _cardOuterHeightFor(compact),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned(
            left: lineLeft,
            top: isFirst ? _cardOuterHeightFor(compact) / 2 : 0,
            bottom: isLast ? _cardOuterHeightFor(compact) / 2 : 0,
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
                  fontSize: compact ? 10 : null,
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
              if (!compact)
                _buildMultiplierRailItem(
                  layerIndex: layerIndex,
                  isFirst: isFirst,
                  isLast: isLast,
                  compact: compact,
                ),
              SizedBox(
                width: _pyramidAreaWidthFor(compact),
                child: SizedBox(
                  key: _pyramidLayerRowKeys[layerIndex],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: layer.asMap().entries.map((cardEntry) {
                      final int cardIndex = cardEntry.key;
                      final PlayingCard card = cardEntry.value;

                      return SizedBox(
                        width: _cardSlotWidthFor(compact),
                        key: _pyramidCardKeys[layerIndex][cardIndex],
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onLongPress: () => _showPileInfoSheet(
                            layerIndex: layerIndex,
                            cardIndex: cardIndex,
                          ),
                          child: Center(
                            child: PyramidCardWidget(
                              card: card,
                              cardWidth: _cardFaceWidthFor(compact),
                              cardHeight: _cardFaceHeightFor(compact),
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
                _actionConsolePrompt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _gameText.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
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

  Widget _buildCompactSelectedSection() {
    return _buildGuessButtons(compact: true);
  }

  Widget _buildCompactDeckPile() {
    final compactDeckWidget = DeckPileWidget(
      deck: gameLogic.pyramid.deck,
      currentDeckCard: _visibleDeckPileCard,
      currentDeckCardAnchorKey: _deckCardGlobalKey,
      pileAnchorKey: _deckPileAnchorKey,
      cardFaceWidth: _cardFaceWidthFor(true),
      cardFaceHeight: _cardFaceHeightFor(true),
      stackOffset: 0.42,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: _showDeckPileInfoSheet,
        child: compactDeckWidget,
      ),
    );
  }

  Widget _buildCompactSettingsNote() {
    final settings = gameLogic.settings;
    final textTheme = Theme.of(context).textTheme;
    final panelHeight = _cardOuterHeightFor(true);
    final summaryEntries = <String>[
      _isZhLocale
          ? '初始單位 ${_formatNumber(settings.initialUnit)}杯'
          : 'Unit ${_formatNumber(settings.initialUnit)}',
      _isZhLocale
          ? '撞柱 x${_formatNumber(settings.tiePenalty)}'
          : 'Tie x${_formatNumber(settings.tiePenalty)}',
    ];
    final layerEntries = <String>[
      '${_isZhLocale ? '1層' : 'L1'} x${settings.layer1Multiplier.toInt()}',
      '${_isZhLocale ? '2層' : 'L2'} x${settings.layer2Multiplier.toInt()}',
      '${_isZhLocale ? '3層' : 'L3'} x${settings.layer3Multiplier.toInt()}',
      '${_isZhLocale ? '4層' : 'L4'} x${settings.layer4Multiplier.toInt()}',
    ];
    final stakesTextStyle = textTheme.labelSmall?.copyWith(
      color: _gameGold,
      fontWeight: FontWeight.w800,
      fontSize: 10.2,
      letterSpacing: 0.2,
      height: 1,
    );

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: panelHeight,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _gamePanelTop.withValues(alpha: 0.96),
                      _gamePanelBottom.withValues(alpha: 0.98),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(color: _gameGold.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -14,
              top: -10,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _gameGold.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 9,
              child: Container(
                width: 58,
                height: 1.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _gameGold.withValues(alpha: 0.82),
                      _gameGold.withValues(alpha: 0.14),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _gameGold.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _gameGold.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: 15,
                      color: _gameGold.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: summaryEntries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: _buildCompactSettingsChip(
                                      entry,
                                      textStyle: stakesTextStyle,
                                      textColor: _gameGold,
                                      backgroundColor: _gameGold.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderColor: _gameGold.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 7),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: layerEntries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: _buildCompactSettingsChip(
                                      entry,
                                      textStyle: stakesTextStyle,
                                      textColor: _gameGold,
                                      backgroundColor: _gameGold.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderColor: _gameGold.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSettingsChip(
    String text, {
    TextStyle? textStyle,
    required Color textColor,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style:
            textStyle?.copyWith(color: textColor, fontSize: 9.4) ??
            Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 9.4,
              height: 1,
              letterSpacing: 0.2,
            ),
      ),
    );
  }

  Widget _buildGameBackgroundDecor() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: -42,
            top: -18,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: _gameGold.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -54,
            top: 220,
            child: Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: _gameGold.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
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
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildCompactSelectedSection(),
              ),
            ),
        ],
      ),
    );

    if (_canUseCompactSingleColumnStage) {
      return Center(child: stage);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: stage,
      ),
    );
  }

  Widget _buildDeckArea({required bool compact}) {
    final deckWidget = DeckPileWidget(
      deck: gameLogic.pyramid.deck,
      currentDeckCard: _visibleDeckPileCard,
      currentDeckCardAnchorKey: _deckCardGlobalKey,
      pileAnchorKey: _deckPileAnchorKey,
      cardFaceWidth: _cardFaceWidthFor(compact),
      cardFaceHeight: _cardFaceHeightFor(compact),
      stackOffset: compact ? 0.48 : 0.62,
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
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: _showDeckPileInfoSheet,
              child: deckWidget,
            ),
          ),
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
        horizontal: compact ? 8 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: compact ? 0.045 : 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _gameGold.withValues(alpha: compact ? 0.1 : 0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 11 : 14,
            color: _gameGold.withValues(alpha: compact ? 0.84 : 1),
          ),
          SizedBox(width: compact ? 5 : 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: compact ? _gameText.withValues(alpha: 0.9) : _gameText,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 10 : null,
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
        compact ? 8 : 14,
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
        title: Text(
          PyramidPokerStrings.get('gameTitle'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _gameGold,
            fontWeight: FontWeight.w800,
          ),
        ),
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
                _buildGameBackgroundDecor(),
                Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isCompact ? 10 : 12,
                      isCompact ? 6 : 18,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildCompactSettingsNote()),
                                const SizedBox(width: 10),
                                _buildCompactDeckPile(),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildTablePanel(
                              compact: true,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [_buildCompactGameStage()],
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
