import 'dart:async';
import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  int score = 0;
  int bestScore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      if (birdYaxis > 1 || checkCollision()) {
        timer.cancel();
        gameHasStarted = false;
        _showGameOverDialog();
        if (score > bestScore) {
          bestScore = score;
        }
      }
    });
  }

  bool checkCollision() {
    // Verifica colisão do pássaro com as barreiras
    if ((barrierXone > -0.2 && barrierXone < 0.2) ||
        (barrierXtwo > -0.2 && barrierXtwo < 0.2)) {
      if (birdYaxis < -0.4 || birdYaxis > 0.4) {
        return true;
      }
    }
    return false;
  }

// Mostra a tela de Game Over e o placar final
  void _showGameOverDialog() {
    var textColor = const TextStyle(color: Colors.white);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text('Game Over', style: textColor),
          content: Text('Your Score: $score', style: textColor),
          actions: [
            TextButton(
              child: Text('OK', style: textColor),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

// Reinicia o jogo
  void resetGame() {
    setState(() {
      birdYaxis = 0;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      time = 0;
      height = 0;
      initialHeight = birdYaxis;
      gameHasStarted = false;
    });
  }

//logica do Flappy Bird (corpo do jogo)
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: const MyBird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameHasStarted
                        ? const Text("")
                        : const Text(
                            "T A P  T O  P L A Y",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),

                  // Barriers - obstaculos
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 250.0,
                    ),
                  ),
                ],
              ),
            ),

            // Graminha do chão
            Container(
              height: 15,
              color: Colors.green,
            ),

            // Score - Score gamer e Score melhor pontuado no jogo.
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("$score",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$bestScore",
                          style: const TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

