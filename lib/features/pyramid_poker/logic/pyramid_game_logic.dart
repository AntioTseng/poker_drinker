import '../../../core/card_game/models/playing_card.dart';
import '../models/pyramid.dart';
import '../models/pyramid_settings.dart';

class PyramidGameLogic {
  Pyramid pyramid;
  PyramidSettings settings;
  late List<List<int>> pileCardCounts;

  String result = '';
  int penalty = 0;
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

    final int targetRank = pyramid.layers[selectedLayer!][selectedIndex!].rank;
    final bool isTie = currentDeckCard!.rank == targetRank;
    final bool guessResult = isBiggerGuess
        ? currentDeckCard!.rank > targetRank
        : currentDeckCard!.rank < targetRank;

    final int layerMultiplier = settings.multiplierForLayer(selectedLayer!);
    final int unit = settings.initialUnit.toInt();
    final int tieMultiplier = settings.tiePenalty.toInt();
    final int cardCount = selectedPileCardCount;

    if (isTie) {
      result = '撞柱！你翻到的是 ${currentDeckCard!.rankLabel}，與 $targetRank 相同！';
      penalty = layerMultiplier * cardCount * unit * tieMultiplier;
      penaltyExplain =
          '懲罰 $penalty 杯: $layerMultiplier (第${selectedLayer! + 1}層倍數) x $cardCount (張牌) x $unit (初始單位) x $tieMultiplier (撞柱)';
    } else if (guessResult) {
      result = isBiggerGuess
          ? '成功！你翻到的是 ${currentDeckCard!.rankLabel}，比 $targetRank 大！'
          : '成功！你翻到的是 ${currentDeckCard!.rankLabel}，比 $targetRank 小！';
      penalty = 0;
      penaltyExplain = '';
    } else {
      result = isBiggerGuess
          ? '失敗！你翻到的是 ${currentDeckCard!.rankLabel}，比 $targetRank 小！'
          : '失敗！你翻到的是 ${currentDeckCard!.rankLabel}，比 $targetRank 大！';
      penalty = layerMultiplier * cardCount * unit;
      penaltyExplain =
          '懲罰 $penalty 杯: $layerMultiplier (第${selectedLayer! + 1}層倍數) x $cardCount (張牌) x $unit (初始單位)';
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
