import '../../../core/card_game/models/playing_card.dart';
import '../models/pyramid.dart';
import '../models/pyramid_settings.dart';
import '../resources/strings.dart';

class PyramidGameLogic {
  Pyramid pyramid;
  PyramidSettings settings;
  late List<List<int>> pileCardCounts;

  String result = '';
  double penalty = 0;
  String penaltyExplain = '';
  int? selectedLayer;
  int? selectedIndex;
  bool canFlipNextCard = true;
  bool canGuess = true;
  PlayingCard? currentDeckCard;

  PyramidGameLogic({required this.pyramid, required this.settings}) {
    pileCardCounts = _createPileCardCounts();
  }

  factory PyramidGameLogic.initial() {
    return PyramidGameLogic(
      pyramid: Pyramid.generate(),
      settings: const PyramidSettings(),
    );
  }

  void resetGame() {
    pyramid = Pyramid.generate();
    pileCardCounts = _createPileCardCounts();
    result = '';
    penalty = 0;
    penaltyExplain = '';
    selectedLayer = null;
    selectedIndex = null;
    canFlipNextCard = true;
    currentDeckCard = null;
    canGuess = true;
  }

  static String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  List<List<int>> _createPileCardCounts() {
    return pyramid.layers
        .map((layer) => List<int>.filled(layer.length, 1))
        .toList();
  }

  int pileCardCountFor(int layerIndex, int cardIndex) {
    return pileCardCounts[layerIndex][cardIndex];
  }

  int get selectedPileCardCount {
    if (selectedLayer == null || selectedIndex == null) {
      return 0;
    }

    return pileCardCountFor(selectedLayer!, selectedIndex!);
  }

  bool canFlipCard(int layer, int index) {
    if (canFlipNextCard) {
      return true;
    }

    if (layer == 0) {
      return true;
    }

    final int previousLayer = layer - 1;

    bool leftCardFlipped = true;
    if (index >= 0 && index < pyramid.layers[previousLayer].length) {
      leftCardFlipped = pyramid.layers[previousLayer][index].isFaceUp;
    }

    bool rightCardFlipped = true;
    if (index + 1 < pyramid.layers[previousLayer].length) {
      rightCardFlipped = pyramid.layers[previousLayer][index + 1].isFaceUp;
    }

    return leftCardFlipped && rightCardFlipped;
  }

  bool selectCard(int layerIndex, int cardIndex) {
    if (!canFlipNextCard) return false;
    if (!canFlipCard(layerIndex, cardIndex)) return false;

    final card = pyramid.layers[layerIndex][cardIndex];
    card.isFaceUp = true;
    selectedLayer = layerIndex;
    selectedIndex = cardIndex;
    canFlipNextCard = false;
    return true;
  }

  PlayingCard? get selectedCard {
    if (selectedLayer == null || selectedIndex == null) return null;
    return pyramid.layers[selectedLayer!][selectedIndex!];
  }

  void guessBigger() {
    _guess(isBiggerGuess: true);
  }

  void guessSmaller() {
    _guess(isBiggerGuess: false);
  }

  void _guess({required bool isBiggerGuess}) {
    if (!canGuess) {
      return;
    }

    if (pyramid.deck.isEmpty) {
      return;
    }

    if (selectedLayer == null || selectedIndex == null) {
      return;
    }

    currentDeckCard = pyramid.deck.removeLast();
    currentDeckCard!.isFaceUp = true;

    final int targetRank = pyramid.layers[selectedLayer!][selectedIndex!].rank;
    final bool isTie = currentDeckCard!.rank == targetRank;
    final bool guessResult = isBiggerGuess
        ? currentDeckCard!.rank > targetRank
        : currentDeckCard!.rank < targetRank;

    final int layerMultiplier = settings.multiplierForLayer(selectedLayer!);
    final double unit = settings.initialUnit;
    final double tieMultiplier = settings.tiePenalty;
    final int cardCount = selectedPileCardCount;
    final String cupUnit = PyramidPokerStrings.get('cupUnit');
    final int layerNumber = selectedLayer! + 1;
    final String drawRank = currentDeckCard!.rankLabel;

    final double basePenalty = layerMultiplier * cardCount * unit;

    if (isTie) {
      result = PyramidPokerStrings.format('tieResult', {
        'draw': drawRank,
        'target': targetRank,
      });
      penalty = basePenalty * tieMultiplier;
      penaltyExplain = PyramidPokerStrings.format('penaltyExplainTie', {
        'penalty': _formatNumber(penalty),
        'cup': cupUnit,
        'layerMultiplier': layerMultiplier,
        'layer': layerNumber,
        'cardCount': cardCount,
        'unit': _formatNumber(unit),
        'tieMultiplier': _formatNumber(tieMultiplier),
      });
    } else if (guessResult) {
      result = isBiggerGuess
          ? PyramidPokerStrings.format('successHigherResult', {
              'draw': drawRank,
              'target': targetRank,
            })
          : PyramidPokerStrings.format('successLowerResult', {
              'draw': drawRank,
              'target': targetRank,
            });
      penalty = 0;
      penaltyExplain = '';
    } else {
      result = isBiggerGuess
          ? PyramidPokerStrings.format('failHigherResult', {
              'draw': drawRank,
              'target': targetRank,
            })
          : PyramidPokerStrings.format('failLowerResult', {
              'draw': drawRank,
              'target': targetRank,
            });
      penalty = basePenalty;
      penaltyExplain = PyramidPokerStrings.format('penaltyExplainNormal', {
        'penalty': _formatNumber(penalty),
        'cup': cupUnit,
        'layerMultiplier': layerMultiplier,
        'layer': layerNumber,
        'cardCount': cardCount,
        'unit': _formatNumber(unit),
      });
    }

    canGuess = false;
  }

  void coverSelectedCardWithDeckCard() {
    if (currentDeckCard == null) {
      return;
    }

    if (selectedLayer == null || selectedIndex == null) {
      return;
    }

    pyramid.layers[selectedLayer!][selectedIndex!] = PlayingCard(
      suit: currentDeckCard!.suit,
      rank: currentDeckCard!.rank,
      isFaceUp: true,
    );

    currentDeckCard = null;
    canGuess = true;
    canFlipNextCard = true;
    result = '';
    penalty = 0;
    penaltyExplain = '';

    pileCardCounts[selectedLayer!][selectedIndex!] += 1;
  }
}
