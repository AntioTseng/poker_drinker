enum Suit { spades, hearts, diamonds, clubs }

class PlayingCard {
  final Suit suit;
  final int rank;
  bool isFaceUp;

  PlayingCard({required this.suit, required this.rank, this.isFaceUp = false});

  String get rankLabel {
    switch (rank) {
      case 1:
        return 'A';
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return rank.toString();
    }
  }
}
