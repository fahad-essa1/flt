import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(RockPaperScissorsApp());
}

class RockPaperScissorsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String playerChoice = '';
  String computerChoice = '';
  String result = '';

  void _getPlayerChoice(String choice) {
    setState(() {
      playerChoice = choice;
      _getComputerChoice();
      _calculateResult();
    });
  }

  void _getComputerChoice() {
    List<String> choices = ['rock', 'paper', 'scissors'];
    final random = Random();
    computerChoice = choices[random.nextInt(choices.length)];
  }

  void _calculateResult() {
    if (playerChoice == computerChoice) {
      result = 'It\'s a tie!';
    } else if ((playerChoice == 'rock' && computerChoice == 'scissors') ||
        (playerChoice == 'paper' && computerChoice == 'rock') ||
        (playerChoice == 'scissors' && computerChoice == 'paper')) {
      result = 'You win!';
    } else {
      result = 'You lose!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissors'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your move:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _getPlayerChoice('rock'),
                  child: Text('Rock'),
                ),
                ElevatedButton(
                  onPressed: () => _getPlayerChoice('paper'),
                  child: Text('Paper'),
                ),
                ElevatedButton(
                  onPressed: () => _getPlayerChoice('scissors'),
                  child: Text('Scissors'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Computer chose: $computerChoice',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
