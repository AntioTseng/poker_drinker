import 'package:flutter/material.dart';

// 撲克牌花色
enum Suit { spades, hearts, diamonds, clubs }

// 撲克牌物件
class CardModel {
  final Suit suit;
  final int rank; // 1~13
  bool isFaceUp;

  CardModel({required this.suit, required this.rank, this.isFaceUp = false});
}

// 金字塔牌型
class Pyramid {
  final List<List<CardModel>> layers; // 4層，每層牌數不同
  final List<CardModel> deck; // 母牌堆

  Pyramid(this.layers, this.deck);

  // 建立金字塔與母牌堆
  static Pyramid generate() {
    List<CardModel> deck = _generateDeck();
    deck.shuffle();
    List<List<CardModel>> layers = [];

    // 第一層1張
    layers.add(deck.sublist(0, 1));
    // 第二層2張
    layers.add(deck.sublist(1, 3));
    // 第三層3張
    layers.add(deck.sublist(3, 6));
    // 第四層4張
    layers.add(deck.sublist(6, 10));

    // 所有卡片初始狀態為蓋著
    for (int i = 0; i < layers.length; i++) {
      for (int j = 0; j < layers[i].length; j++) {
        layers[i][j].isFaceUp = false;
        print('Initialized card at Layer $i, Index $j as face down.');
      }
    }

    // 剩下的牌作為母牌堆
    List<CardModel> deckPile = deck.sublist(10);
    print('Deck pile initialized with ${deckPile.length} cards.');
    return Pyramid(layers, deckPile);
  }

  static List<CardModel> _generateDeck() {
    List<CardModel> deck = [];
    for (var suit in Suit.values) {
      for (int rank = 1; rank <= 13; rank++) {
        deck.add(CardModel(suit: suit, rank: rank));
      }
    }
    return deck;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '金字塔撲克牌',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: '金字塔撲克牌'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Pyramid pyramid;
  String result = '';
  int penalty = 0;
  String penaltyExplain = '';
  int? selectedLayer;
  int? selectedIndex;
  bool canFlipNextCard = true; // 控制是否允許翻牌
  CardModel? currentDeckCard; // 當前翻開的母牌堆卡片
  bool canGuess = true; // 控制是否可以按猜大或猜小

  @override
  void initState() {
    super.initState();
    pyramid = Pyramid.generate();
  }

  bool canFlipCard(int layer, int index) {
    // 如果玩家已完成一次猜測，允許翻開任何卡片
    if (canFlipNextCard) {
      print('Layer $layer, Index $index: Can flip any card after guess.');
      return true;
    }

    if (layer == 0) {
      // 最頂層的卡片可以直接翻開
      print('Layer $layer, Index $index: Top layer card can be flipped.');
      return true;
    }

    // 檢查該卡片上方的兩張卡片是否已經翻開
    int previousLayer = layer - 1;

    // 檢查左上方的卡片是否存在且已翻開
    bool leftCardFlipped = true;
    if (index >= 0 && index < pyramid.layers[previousLayer].length) {
      leftCardFlipped = pyramid.layers[previousLayer][index].isFaceUp;
      print('Layer $layer, Index $index: Left card flipped: $leftCardFlipped');
    } else {
      print(
        'Layer $layer, Index $index: No left card above. Assuming flipped.',
      );
    }

    // 檢查右上方的卡片是否存在且已翻開
    bool rightCardFlipped = true;
    if (index + 1 < pyramid.layers[previousLayer].length) {
      rightCardFlipped = pyramid.layers[previousLayer][index + 1].isFaceUp;
      print(
        'Layer $layer, Index $index: Right card flipped: $rightCardFlipped',
      );
    } else {
      print(
        'Layer $layer, Index $index: No right card above. Assuming flipped.',
      );
    }

    // 只有當左上方和右上方的卡片都翻開時，才能翻開當前卡片
    bool canFlip = leftCardFlipped && rightCardFlipped;
    print('Layer $layer, Index $index: Can flip: $canFlip');
    return canFlip;
  }

  Widget buildPyramid() {
    return Column(
      children: pyramid.layers.asMap().entries.map((entry) {
        int layerIndex = entry.key;
        List<CardModel> layer = entry.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 確保文字與牌在垂直方向置中
          children: [
            Expanded(
              flex: 1, // 給文字一個固定的空間，並增加左側距離
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0), // 增加文字與左側的間距
                child: Align(
                  alignment: Alignment.centerRight, // 文字置中對齊每堆牌
                  child: Text(
                    '${layerIndex + 1}層: ${4 - layerIndex}倍',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4, // 給牌更多的空間，保持牌在中間對齊
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: layer.map((card) {
                  return GestureDetector(
                    onTap: () {
                      if (!canFlipNextCard) {
                        debugPrint('必須先完成猜大或猜小才能翻牌');
                        return;
                      }
                      int cardIndex = layer.indexOf(card);
                      if (canFlipCard(layerIndex, cardIndex)) {
                        setState(() {
                          card.isFaceUp = true;
                          selectedLayer = layerIndex;
                          selectedIndex = cardIndex;
                          canFlipNextCard = false; // 禁止翻下一張牌，直到完成猜測
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      width: 50,
                      height: 70,
                      color: card.isFaceUp ? Colors.white : Colors.grey,
                      child: card.isFaceUp
                          ? Center(
                              child: Text(
                                '${card.rank}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildDeckPile() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 顯示母牌堆的背面
        for (int i = 0; i < pyramid.deck.length; i++)
          Positioned(
            top: i * 2.0,
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
        // 顯示翻開的母牌
        if (currentDeckCard != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: pyramid.deck.length * 2.0,
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  '${currentDeckCard!.rank}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void showAnimatedResult(bool guessResult, int targetRank) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: AlertDialog(
            title: const Text('結果'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  guessResult
                      ? '成功！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank ${guessResult ? "大" : "小"}！'
                      : '失敗！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank ${guessResult ? "大" : "小"}！',
                  style: const TextStyle(fontSize: 20),
                ),
                if (!guessResult)
                  Column(
                    children: [
                      Text(
                        '懲罰：$penalty 杯',
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      Text(
                        penaltyExplain,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildResultDialog() {
    return AlertDialog(
      title: const Text('結果'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(result, style: const TextStyle(fontSize: 20)),
          if (penalty > 0)
            Column(
              children: [
                Text(
                  '懲罰：$penalty 杯',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                Text(
                  penaltyExplain,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed:
              currentDeckCard != null &&
                  selectedLayer != null &&
                  selectedIndex != null
              ? () {
                  setState(() {
                    // 將母牌覆蓋到子牌上
                    pyramid.layers[selectedLayer!][selectedIndex!] = CardModel(
                      suit: currentDeckCard!.suit,
                      rank: currentDeckCard!.rank,
                      isFaceUp: true,
                    );
                    currentDeckCard = null; // 隱藏翻開的母牌
                    canGuess = true; // 恢復猜大或猜小的功能
                    canFlipNextCard = true; // 允許翻新的牌
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    print('Closing dialog with Navigator.pop'); // Debug log
                    Navigator.pop(context); // 確保對話框正確關閉
                  });
                }
              : () {
                  print(
                    'Button disabled. Conditions: currentDeckCard: $currentDeckCard, selectedLayer: $selectedLayer, selectedIndex: $selectedIndex',
                  );
                },
          child: const Text('覆蓋到當前子牌'),
        ),
      ],
    );
  }

  Widget buildGuessButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed:
              canGuess &&
                  pyramid.deck.isNotEmpty &&
                  selectedLayer != null &&
                  selectedIndex != null
              ? () {
                  setState(() {
                    currentDeckCard = pyramid.deck.removeLast(); // 翻開母牌堆的第一張牌
                    int targetRank =
                        pyramid.layers[selectedLayer!][selectedIndex!].rank;
                    bool guessResult =
                        currentDeckCard!.rank > targetRank; // 比較邏輯
                    bool isTie = currentDeckCard!.rank == targetRank; // 撞柱條件

                    if (isTie) {
                      result =
                          '撞柱！你翻到的是 ${currentDeckCard!.rank}，與 $targetRank 相同！';
                      penalty = (4 - selectedLayer!) * 1 * 2; // 懲罰基礎上 x2
                      penaltyExplain =
                          '懲罰 $penalty 杯: ${4 - selectedLayer!} (第${selectedLayer! + 1}層) x 1 (張牌) x 1 (初始單位) x 2 (撞柱)';
                    } else if (guessResult) {
                      result =
                          '成功！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank 大！';
                      penalty = 0;
                      penaltyExplain = '';
                    } else {
                      result =
                          '失敗！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank 小！';
                      penalty = (4 - selectedLayer!) * 1 * 1; // 懲罰邏輯
                      penaltyExplain =
                          '懲罰 $penalty 杯: ${4 - selectedLayer!} (第${selectedLayer! + 1}層) x 1 (張牌) x 1 (初始單位)';
                    }

                    canGuess = false; // 禁止連續按猜大或猜小
                  });
                }
              : null,
          child: Text(
            selectedLayer != null && selectedIndex != null
                ? '比${pyramid.layers[selectedLayer!][selectedIndex!].rank}大'
                : '比大',
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed:
              canGuess &&
                  pyramid.deck.isNotEmpty &&
                  selectedLayer != null &&
                  selectedIndex != null
              ? () {
                  setState(() {
                    currentDeckCard = pyramid.deck.removeLast(); // 翻開母牌堆的第一張牌
                    int targetRank =
                        pyramid.layers[selectedLayer!][selectedIndex!].rank;
                    bool guessResult =
                        currentDeckCard!.rank < targetRank; // 比較邏輯
                    bool isTie = currentDeckCard!.rank == targetRank; // 撞柱條件

                    if (isTie) {
                      result =
                          '撞柱！你翻到的是 ${currentDeckCard!.rank}，與 $targetRank 相同！';
                      penalty = (4 - selectedLayer!) * 1 * 2; // 懲罰基礎上 x2
                      penaltyExplain =
                          '懲罰 $penalty 杯: ${4 - selectedLayer!} (第${selectedLayer! + 1}層) x 1 (張牌) x 1 (初始單位) x 2 (撞柱)';
                    } else if (guessResult) {
                      result =
                          '成功！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank 小！';
                      penalty = 0;
                      penaltyExplain = '';
                    } else {
                      result =
                          '失敗！你翻到的是 ${currentDeckCard!.rank}，比 $targetRank 大！';
                      penalty = (4 - selectedLayer!) * 1 * 1; // 懲罰邏輯
                      penaltyExplain =
                          '懲罰 $penalty 杯: ${4 - selectedLayer!} (第${selectedLayer! + 1}層) x 1 (張牌) x 1 (初始單位)';
                    }

                    canGuess = false; // 禁止連續按猜大或猜小
                  });
                }
              : null,
          child: Text(
            selectedLayer != null && selectedIndex != null
                ? '比${pyramid.layers[selectedLayer!][selectedIndex!].rank}小'
                : '比小',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (result.isNotEmpty) {
        if (currentDeckCard == null) {
          print('Result dialog not shown because currentDeckCard is null.');
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildResultDialog();
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                pyramid = Pyramid.generate();
                result = '';
                penalty = 0;
                penaltyExplain = '';
                selectedLayer = null;
                selectedIndex = null;
                canFlipNextCard = true;
                currentDeckCard = null; // 重置母牌堆翻開的牌
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 金字塔牌型
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPyramid(),
                  const SizedBox(height: 20),
                  if (selectedLayer != null &&
                      selectedIndex != null &&
                      pyramid.layers[selectedLayer!][selectedIndex!].isFaceUp)
                    buildGuessButtons(),
                ],
              ),
            ),
            // 母牌堆
            Expanded(flex: 1, child: buildDeckPile()),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
