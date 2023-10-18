import 'dart:math';
import 'bot_logic.dart';

class CardSlot {
  int value;
  int column;
  bool isFlipped = false;

 CardSlot({required this.value, required this.column});
}

class GameLogic {
  BotLogic botLogic = BotLogic();
  CardSlot? jokerCard;
  List<CardSlot> playerCards = [];
  List<CardSlot> botCards = [];
  List<CardSlot> centerCards = [];
  int currentPlayer = 1;
  bool isFirstCardFlipped = false;
  bool isCardFlippable = true;
  int centerCardIndex = 0;
  static const botPlayer = 1;
  bool hasJoker = false;
  late CardSlot centerCard;
  static const int totalCards = 49;


void initializeGame() {
    List<int> cardKeys = List<int>.generate(totalCards, (index) => index);
    cardKeys.shuffle(Random.secure());

    int selectedCenterCardValue = cardKeys[0];
    centerCard = CardSlot(value: selectedCenterCardValue, column: 0);

    botCards = cardKeys
        .take(totalCards ~/ 2)
        .map((value) => CardSlot(value: value, column: 0))
        .toList();
    playerCards = cardKeys
        .skip(totalCards ~/ 2)
        .map((value) => CardSlot(value: value, column: 0))
        .toList();

    isFirstCardFlipped = false;
    isCardFlippable = true;
    centerCardIndex = 0;

    currentPlayer = (centerCard.value >= 25 && centerCard.value <= 48) ? 1 : 2;
}

void shuffleCards() {
    List<int> cardKeys = List<int>.generate(totalCards, (index) => index);
    cardKeys.shuffle(Random.secure());

    int randomIndex = Random.secure().nextInt(cardKeys.length);
    int newCenterCardValue = cardKeys[randomIndex];

    cardKeys.removeAt(randomIndex);

    centerCardIndex = newCenterCardValue;
    centerCard = CardSlot(value: newCenterCardValue, column: 0);

    botCards = cardKeys
        .take(totalCards ~/ 2)
        .map((value) => CardSlot(value: value, column: 0))
        .toList();
    playerCards = cardKeys
        .skip(totalCards ~/ 2)
        .map((value) => CardSlot(value: value, column: 0))
        .toList();

    isFirstCardFlipped = false;
    isCardFlippable = true;

    currentPlayer =
        (newCenterCardValue >= 25 && newCenterCardValue <= 48) ? 1 : 2;
}

 String getCardImagePath(int cardValue, bool isFrontSide) {
   // print("Card Value: $cardValue, Is Front Side: $isFrontSide");
    if (isFrontSide && isCardFlippable) {
      String? cardName = cardImages[cardValue];
      return cardName ?? '';
    } else {
      return backImages['card']!;

    }
  }


  void playCard(int player, CardSlot cardSlot) {
    if (isFirstCardFlipped) {
      if (cardSlot.value == 0) {
        CardSlot tempCard = centerCard;
        centerCard = cardSlot;
        cardSlot.value = tempCard.value;
        centerCardIndex = centerCard.value;
      } else {
        centerCard = cardSlot;
      }
    } else {
      isFirstCardFlipped = true;
      centerCard = cardSlot;
    }
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
    centerCardIndex = centerCard.value;
  }
}

Map<String, String> backImages = {
  'card': 'assets/card.svg',
};

Map<int, String> cardImages = {
  0: 'assets/joker.svg',
  1: 'assets/king-of-clubs.svg',
  2: 'assets/king-of-spades.svg',
  3: 'assets/king-of-diamonds.svg',
  4: 'assets/king-of-hearts.svg',
  5: 'assets/queen-of-clubs.svg',
  6: 'assets/queen-of-spades.svg',
  7: 'assets/queen-of-diamonds.svg',
  8: 'assets/queen-of-hearts.svg',
  9: 'assets/jack-of-clubs.svg',
  10: 'assets/jack-of-spades.svg',
  11: 'assets/jack-of-diamonds.svg',
  12: 'assets/jack-of-hearts.svg',
  13: 'assets/10-of-clubs.svg',
  14: 'assets/10-of-spades.svg',
  15: 'assets/10-of-diamonds.svg',
  16: 'assets/10-of-hearts.svg',
  17: 'assets/9-of-clubs.svg',
  18: 'assets/9-of-spades.svg',
  19: 'assets/9-of-diamonds.svg',
  20: 'assets/9-of-hearts.svg',
  21: 'assets/8-of-clubs.svg',
  22: 'assets/8-of-spades.svg',
  23: 'assets/8-of-diamonds.svg',
  24: 'assets/8-of-hearts.svg',
  25: 'assets/7-of-clubs.svg',
  26: 'assets/7-of-spades.svg',
  27: 'assets/7-of-diamonds.svg',
  28: 'assets/7-of-hearts.svg',
  29: 'assets/6-of-clubs.svg',
  30: 'assets/6-of-spades.svg',
  31: 'assets/6-of-diamonds.svg',
  32: 'assets/6-of-hearts.svg',
  33: 'assets/5-of-clubs.svg',
  34: 'assets/5-of-spades.svg',
  35: 'assets/5-of-diamonds.svg',
  36: 'assets/5-of-hearts.svg',
  37: 'assets/4-of-clubs.svg',
  38: 'assets/4-of-spades.svg',
  39: 'assets/4-of-diamonds.svg',
  40: 'assets/4-of-hearts.svg',
  41: 'assets/3-of-clubs.svg',
  42: 'assets/3-of-spades.svg',
  43: 'assets/3-of-diamonds.svg',
  44: 'assets/3-of-hearts.svg',
  45: 'assets/2-of-clubs.svg',
  46: 'assets/2-of-spades.svg',
  47: 'assets/2-of-diamonds.svg',
  48: 'assets/2-of-hearts.svg',
};

