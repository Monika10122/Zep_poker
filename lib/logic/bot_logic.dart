
import 'game_logic.dart';

class BotLogic {
  List<CardSlot> botCards = [];
  CardSlot centerCard = CardSlot(value: 0, column: 0);
  bool isBotTurn = false;

int botSelectColumn(int columnIndex) {
  return columnIndex;
}


int determineHighlightedColumn(int cardValue) {
  if (cardValue >= 45 && cardValue <= 48) {
    return 0; // Перший рядок бота
  } else if (cardValue >= 41 && cardValue <= 44) {
    return 1; // Другий рядок бота
  } else if (cardValue >= 37 && cardValue <= 40) {
    return 2; // Третій рядок бота
  } else if (cardValue >= 33 && cardValue <= 36) {
    return 3; // Четвертий рядок бота
  } else if (cardValue >= 29 && cardValue <= 32) {
    return 4; // П'ятий рядок бота
  } else if (cardValue >= 25 && cardValue <= 28) {
    return 5; // Шостий рядок бота
  } else {
    return -1; // Якщо значення карти не відповідає жодному рядку
  }
}


  void moveBotCardToColumn(int columnIndex) {
    int botCardIndex = botCards.indexWhere(
        (card) => card.column == 0 && card.value >= 25 && card.value <= 48);

    if (botCardIndex != -1) {
      CardSlot botCard = botCards[botCardIndex];
      centerCard.value = botCard.value;
      botCard.column = columnIndex;
    }
  }

  
}