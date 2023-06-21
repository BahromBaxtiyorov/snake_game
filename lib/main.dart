import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SnakePage(),
    );
  }
}

class SnakePage extends StatefulWidget {
  @override
  _SnakePageState createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  final int squaresPerRow = 20;
  final int squaresPerCol = 40;
  final fontStyle = const TextStyle(fontSize: 20, color: Colors.white);
  final randomGen = Random();

  List<int> snakePosition = [45, 65, 85, 105, 125];
  int food = 300;
  String direction = 'down';
  late Timer timer;

  void startGame() {
    const duration = Duration(milliseconds: 300);

    snakePosition = [45, 65, 85, 105, 125];
    direction = 'down';
    timer = Timer.periodic(duration, (Timer timer) {
      updateSnake();
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 780) {
            timer.cancel();
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            timer.cancel();
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            timer.cancel();
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            timer.cancel();
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  void generateNewFood() {
    food = randomGen.nextInt(700);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: squaresPerRow / (squaresPerCol + 5),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: squaresPerRow * squaresPerCol,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: squaresPerRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePosition.contains(index)) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(color: Colors.white),
                        ),
                      );
                    } else if (index == food) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(color: Colors.green),
                        ),
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(color: Colors.grey[900]),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: startGame,
                  child: Text('Start', style: fontStyle),
                ),
                Text('Score: ${snakePosition.length}', style: fontStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


