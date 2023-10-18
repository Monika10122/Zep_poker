
// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zep_poker0/logic/bot_logic.dart';
import '../logic/game_logic.dart';

class ZepPokerGame extends StatefulWidget {
  int? targetCardIndex;

  ZepPokerGame({Key? key, this.targetCardIndex}) : super(key: key);

  @override
  _ZepPokerGameState createState() => _ZepPokerGameState();
}

class _ZepPokerGameState extends State<ZepPokerGame> {
  GameLogic gameLogic = GameLogic();
  BotLogic botLogic = BotLogic();
  int? draggedCenterCardIndex;
  int highlightedColumn = 0;
  CardSlot? jokerCard;
  int centerCardIndex = 0;
  CardSlot? draggedCard;
  int? targetCardIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeAndStartGame();
  }

  bool areAllPlayerCardsInPlayerDeck(List<CardSlot> playerCards) {
  for (int i = 1; i <= 24; i++) {
    if (!playerCards.any((card) => card.value == i)) {
      return false;
    }
  }
  return true;
}

bool areAllBotCardsInBotDeck(List<CardSlot> botCards) {
  for (int i = 25; i <= 48; i++) {
    if (!botCards.any((card) => card.value == i)) {
      return false;
    }
  }
  return true;
}


  void initializeAndStartGame() {
    setState(() {
      gameLogic.initializeGame();
      gameLogic.shuffleCards();
      draggedCenterCardIndex = null;
      centerCardIndex = 0;
      jokerCard = null;
    });
    print("Game initialized and started.1");
  }

  int determineHighlightedColumn(int centerCardValue) {
    if (centerCardValue >= 45 && centerCardValue <= 48) {
      return 1; 
    } else if (centerCardValue >= 41 && centerCardValue <= 44) {
      return 2; 
    } else if (centerCardValue >= 37 && centerCardValue <= 40) {
      return 3; 
    } else if (centerCardValue >= 33 && centerCardValue <= 36) {
      return 4; 
    } else if (centerCardValue >= 29 && centerCardValue <= 32) {
      return 5; 
    } else if (centerCardValue >= 25 && centerCardValue <= 28) {
      return 6; 
    } else if (centerCardValue >= 21 && centerCardValue <= 24) {
      return 1; 
    } else if (centerCardValue >= 17 && centerCardValue <= 20) {
      return 2; 
    } else if (centerCardValue >= 13 && centerCardValue <= 16) {
      return 3; 
    } else if (centerCardValue >= 9 && centerCardValue <= 12) {
      return 4; 
    } else if (centerCardValue >= 5 && centerCardValue <= 8) {
      return 5; 
    } else if (centerCardValue >= 1 && centerCardValue <= 4) {
      return 6; 
    } else if (centerCardValue == 0) {
      return 0; 
    } else {
      return -1; 
    }
  }

  int cardIndexForValue(int cardValue) {
    return cardValue - 1;
  }

  @override
  Widget build(BuildContext context) {
    final cardImagePath = jokerCard != null
        ? gameLogic.getCardImagePath(jokerCard!.value, true)
        : gameLogic.getCardImagePath(gameLogic.centerCard.value, true);

    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              height: 320,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: gameLogic.botCards.length,
                itemBuilder: (context, index) {
                  CardSlot cardSlot = gameLogic.botCards.elementAt(index);
                  String cardImagePath =
                      gameLogic.getCardImagePath(cardSlot.value, true);

                  return buildCardWidget(
                    cardImagePath,
                    index,
                    cardSlot,
                    1,
                  );
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 170),
                  GestureDetector(
                    child: Draggable<CardSlot>(
                      data: jokerCard ?? gameLogic.centerCard,
                      feedback: IgnorePointer(
                        ignoring: true,
                        child: SvgPicture.asset(
                          cardImagePath,
                          width: 50,
                          height: 70,
                        ),
                      ),
                      onDragStarted: () {
                        final columnIndex = determineHighlightedColumn(
                            gameLogic.centerCard.value);
                        print('selectedColumn : $columnIndex');
                        if (gameLogic.centerCard.value >= 25 &&
                            gameLogic.centerCard.value <= 48) {
                          print('current player : bot');
                        }
                        if (gameLogic.centerCard.value >= 1 &&
                            gameLogic.centerCard.value <= 24) {
                          print('current player : player');
                        }
                      },
                      onDraggableCanceled: (velocity, offset) {
                        final columnIndex = determineHighlightedColumn(
                            gameLogic.centerCard.value);
                        int currentCenterCardValue = gameLogic.centerCard.value;

                        setState(() {
                          draggedCard = jokerCard ?? gameLogic.centerCard;

                          if (gameLogic.centerCard.value >= 25 &&
                              gameLogic.centerCard.value <= 48) {
                            botLogic.isBotTurn = true;
                            gameLogic.currentPlayer = 1;
                            botLogic.botSelectColumn(columnIndex);
                            draggedCard!.column = columnIndex;

                            gameLogic.centerCard.value =
                                widget.targetCardIndex!;

                            for (CardSlot card in gameLogic.botCards) {
                              if (card.value == widget.targetCardIndex) {
                                card.value = currentCenterCardValue;
                                break;
                              }
                              if (gameLogic.centerCard.value >= 1 &&
                                  gameLogic.centerCard.value <= 24) {
                                print('Error');
                                
                              }
                            }

                            print('CardIndex0 ${widget.targetCardIndex}');
                          }

                          if (gameLogic.centerCard.value >= 1 &&
                              gameLogic.centerCard.value <= 24) {
                            botLogic.isBotTurn = false;
                            gameLogic.currentPlayer = 2;
                            draggedCard!.column = columnIndex;

                            gameLogic.centerCard.value =
                                widget.targetCardIndex!;

                            for (CardSlot card in gameLogic.playerCards) {
                              if (card.value == widget.targetCardIndex) {
                                card.value = currentCenterCardValue;
                                break;
                              }
                            }

                            print('CardIndex0 ${widget.targetCardIndex}');
                          }

                          if (gameLogic.centerCard.value == 0) {
                            gameLogic.currentPlayer = gameLogic.currentPlayer;
                            gameLogic.centerCard.value =
                                widget.targetCardIndex!;
                                for (CardSlot card in gameLogic.playerCards ) {
                              if (card.value == widget.targetCardIndex) {
                                card.value = currentCenterCardValue;
                                break;
                              }
                            }
                            for (CardSlot card in gameLogic.botCards) {
                            if (card.value == widget.targetCardIndex) {
                                card.value = currentCenterCardValue;
                                break;
                              }
}

                          } else {
                            ErrorWidget.withDetails(
                              message:
                                  'Значення центральної карти не входять в допустимі',
                            );
                          }
                        });
                      },
                      onDragEnd: (details) {
                        if (areAllPlayerCardsInPlayerDeck(gameLogic.playerCards)) {

  print('Bot win');
} else if (areAllBotCardsInBotDeck(gameLogic.botCards)) {
  print('Player win');
} else {
  print('Continue game');
}

                      },
                      child: SvgPicture.asset(
                        cardImagePath,
                        width: 50,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        initializeAndStartGame();
                      });
                    },
                    child: const Text("Start"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 320,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemCount: gameLogic.playerCards.length,
              itemBuilder: (context, index) {
                CardSlot cardSlot = gameLogic.playerCards.elementAt(index);
                String cardImagePath =
                    gameLogic.getCardImagePath(cardSlot.value, true);
                return GestureDetector(
                  child: buildCardWidget(cardImagePath, index, cardSlot, 2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int determineCardIndex(int cardValue) {
    if (cardValue >= 0 && cardValue <= 48) {
      return cardValue;
    } else {
      return -1; 
    }
  }

  Widget buildCardWidget(
    String cardImagePath,
    int index,
    CardSlot cardSlot,
    int player,
  ) {
    final column = determineHighlightedColumn(centerCardIndex);
    final isCardInHighlightedColumn = cardSlot.column == column;
    var cardIndex = determineCardIndex(cardSlot.value);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.targetCardIndex = cardIndex;
          cardSlot.isFlipped = !cardSlot.isFlipped;
        });
        print('Index ${widget.targetCardIndex}');
      },
      child: Opacity(
        opacity: isCardInHighlightedColumn ? 1.0 : 0.6,
        child: SvgPicture.asset(
          cardSlot.isFlipped
          ? cardImagePath 
          : backImages['card']!,

          width: 50,
          height: 70,
        ),
      ),
    );
  }
}
