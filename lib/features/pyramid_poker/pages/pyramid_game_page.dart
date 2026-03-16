import 'package:flutter/material.dart';
import '../../../core/card_game/models/playing_card.dart';
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

class _PyramidGamePageState extends State<PyramidGamePage> {
  late PyramidGameLogic gameLogic;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    gameLogic = PyramidGameLogic.initial();
    gameLogic.settings = widget.settings;
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
            if (!mounted) {
              return;
            }

            setState(() {
              gameLogic.coverSelectedCardWithDeckCard();
            });

            Navigator.of(dialogContext).pop();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: layer.asMap().entries.map((cardEntry) {
                  final int cardIndex = cardEntry.key;
                  final PlayingCard card = cardEntry.value;

                  return PyramidCardWidget(
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
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGuessButtons() {
    final selectedCard = gameLogic.selectedCard;

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
          gameLogic.canGuess &&
              gameLogic.pyramid.deck.isNotEmpty &&
              gameLogic.selectedLayer != null &&
              gameLogic.selectedIndex != null
          ? () => _handleGuess(isBiggerGuess: true)
          : null,
      onGuessSmaller:
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
                gameLogic.resetGame();
                gameLogic.settings = widget.settings;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPyramid(),
                  const SizedBox(height: 20),
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
                currentDeckCard: gameLogic.currentDeckCard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
