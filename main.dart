import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MemoryGame());
}

class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoryGameScreen(),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> symbols = ['🌼', '🍎', '🍕', '🚀', '🎈', '🐱', '🐳', '🎸'];
  List<String> pairs = [];
  List<bool> revealed = [];
  int attempts = 0;
  int pairsFound = 0;
  int selectedCardIndex = -1;
  int level = 0; // 0: Easy, 1: Medium, 2: Hard
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _restartGame();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    stopwatch.stop();
    timer?.cancel();
  }

  void _restartGame() {
    setState(() {
      attempts = 0;
      pairsFound = 0;
      selectedCardIndex = -1;
      stopwatch.reset();
      stopwatch.start();
      int cardsCount = _getNumberOfCards();
      pairs = List<String>.generate(cardsCount ~/ 2, (index) => symbols[index % symbols.length])
        ..addAll(List<String>.generate(cardsCount ~/ 2, (index) => symbols[index % symbols.length]));
      pairs.shuffle();
      revealed = List.filled(cardsCount, false);
    });
  }

  int _getNumberOfCards() {
    switch (level) {
      case 0:
        return 4 * 2; // Easy
      case 1:
        return 6 * 2; // Medium
      case 2:
        return 8 * 2; // Hard
      default:
        return 4 * 2;
    }
  }

  void _onCardTap(int index) {
    setState(() {
      if (selectedCardIndex == -1) {
        selectedCardIndex = index;
        revealed[index] = true;
      } else {
        if (pairs[selectedCardIndex] == pairs[index] && selectedCardIndex != index) {
          revealed[index] = true;
          pairsFound++;
          if (pairsFound == _getNumberOfCards() ~/ 2) {
            _showWinDialog();
          }
        } else {
          revealed[selectedCardIndex] = false;
          revealed[index] = false;
        }
        selectedCardIndex = -1;
        attempts++;
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _showWinDialog() {
    stopwatch.stop();
    timer?.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You found all pairs in $attempts attempts in ${stopwatch.elapsed.inSeconds} seconds.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Game - Level: ${['Easy', 'Medium', 'Hard'][level]}',
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text('Attempts: $attempts'),
                SizedBox(width: 16),
                Text('Time: ${stopwatch.elapsed.inSeconds} seconds'),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bac5.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double cardSize = min(constraints.maxWidth, constraints.maxHeight) * 0.15;
              return GridView.builder(
                padding: EdgeInsets.all(cardSize * 0.1),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: cardSize * 0.1,
                  mainAxisSpacing: cardSize * 0.1,
                ),
                itemCount: _getNumberOfCards(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _onCardTap(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: cardSize,
                      height: cardSize,
                      decoration: BoxDecoration(
                        color: revealed[index] ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(cardSize * 0.1),
                        boxShadow: revealed[index]
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: cardSize * 0.2,
                            offset: Offset(0, cardSize * 0.4),
                          ),
                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          revealed[index] ? pairs[index] : '',
                          style: TextStyle(fontSize: cardSize * 0.6, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: level,
        onTap: (int index) {
          setState(() {
            level = index;
            _restartGame();
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'Easy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Medium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessible_forward),
            label: 'Hard',
          ),
        ],
      ),
    );
  }
}
