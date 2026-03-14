import '../../../core/card_game/models/playing_card.dart';
import '../../../core/card_game/services/deck_service.dart';

class Pyramid {
  final List<List<PlayingCard>> layers;
  final List<PlayingCard> deck;

  Pyramid(this.layers, this.deck);

  static Pyramid generate() {
    final List<PlayingCard> deck = DeckService.createDeck();
    DeckService.shuffle(deck);

    final List<List<PlayingCard>> layers = [];
    layers.add(deck.sublist(0, 1));
    layers.add(deck.sublist(1, 3));
    layers.add(deck.sublist(3, 6));
    layers.add(deck.sublist(6, 10));

    for (final layer in layers) {
      for (final card in layer) {
        card.isFaceUp = false;
      }
    }

    final List<PlayingCard> deckPile = deck.sublist(10);
    return Pyramid(layers, deckPile);
  }
}
