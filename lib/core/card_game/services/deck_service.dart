import '../models/playing_card.dart';

class DeckService {
  static List<PlayingCard> createDeck() {
    List<PlayingCard> deck = [];

    for (var suit in Suit.values) {
      for (int rank = 1; rank <= 13; rank++) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }

    return deck;
  }

  static void shuffle(List<PlayingCard> deck) {
    deck.shuffle();
  }

  static PlayingCard draw(List<PlayingCard> deck) {
    return deck.removeLast();
  }
}
