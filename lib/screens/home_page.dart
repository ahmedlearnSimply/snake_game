// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snake_game/widgets/blank_pixels.dart';
import 'package:snake_game/widgets/custom_text_form_field.dart';
import 'package:snake_game/widgets/food_snake.dart';
import 'package:snake_game/widgets/snake_pixels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//* enum direction of movement
enum snake_direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //* food position
  int foodPosition = 55;
  bool hasStarted = false;

  //* snake position
  List<int> snakePosition = [
    0,
    1,
    2,
  ];

  //* high score list

  //* some of vars
  int totalNumberSquares = 100;
  int rowSize = 10;
  int currentScore = 0;
  TextEditingController nameController = new TextEditingController();
  List<String> highScoreList = [];
  late final Future? letsGetDocsIds;

  @override
  void initState() {
    letsGetDocsIds = getDocId();

    super.initState();
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(5)
        .get()
        .then((value) => value.docs.forEach((element) {
              highScoreList.add(element.reference.id);
            }));
  }

  //* snake direction is initially to the right
  var currentDirection = snake_direction.RIGHT;

  //* start game method
  void startGame() {
    hasStarted = true;
    Timer.periodic(
      Duration(milliseconds: 200),
      (timer) {
        setState(() {
          //* generate new food position

          //* generate new snake position

          //* Keep the Snake Moving
          moveSnake();

          //* check if the game is over
          // gameOver();
          if (gameOver()) {
            hasStarted = false;
            timer.cancel();
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 10,
                    title: Text(
                      'Game Over',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Text(
                            'Your Score: ${currentScore}',
                          ),
                          Gap(30),
                          CustomTextFormField(
                            controller: nameController,
                            prefixIcon: Icon(Icons.person),
                            labelText: "Enter your name ",
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            submitScore();
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     restartGame();
                      //     Navigator.pop(context);
                      //   },
                      //   child: Text('Restart'),
                      // ),
                    ],
                  );
                });
          }
        });
      },
    );
  }

//* restart the game
  void restartGame() {
    snakePosition = [
      0,
      1,
      2,
    ];
    foodPosition = Random().nextInt(totalNumberSquares);
    currentDirection = snake_direction.RIGHT;
    currentScore = 0;
    hasStarted = false;
    startGame();
  }

  //* Game Over
  bool gameOver() {
    //* this is the list of bodySnake
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);

    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }
    return false;
  }

  //* generate new food position method
  void eatFood() {
    currentScore++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalNumberSquares);
    }
  }

  //* move snake position method
  void moveSnake() {
    int newHeadPosition;

    switch (currentDirection) {
      case snake_direction.UP:
        {
          if (snakePosition.last < rowSize) {
            newHeadPosition = snakePosition.last - rowSize + totalNumberSquares;
          } else {
            newHeadPosition = snakePosition.last - rowSize;
          }
        }
        break;
      case snake_direction.DOWN:
        {
          if (snakePosition.last + rowSize > totalNumberSquares) {
            newHeadPosition = snakePosition.last + rowSize - totalNumberSquares;
          } else {
            newHeadPosition = snakePosition.last + rowSize;
          }
        }
        break;
      case snake_direction.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            newHeadPosition = snakePosition.last - 1 + rowSize;
          } else {
            newHeadPosition = snakePosition.last - 1;
          }
        }
        break;
      case snake_direction.RIGHT:
        {
          if (snakePosition.last % rowSize == 9) {
            newHeadPosition = snakePosition.last + 1 - rowSize;
          } else {
            newHeadPosition = snakePosition.last + 1;
          }
        }
        break;
    }

    if (snakePosition.last == foodPosition) {
      eatFood();
    } else {
      snakePosition.removeAt(0);
    }
    // Add new head and remove tail
    snakePosition.add(newHeadPosition);
  }

  //* submit score to the firebase
  void submitScore() {
    var dataBase = FirebaseFirestore.instance;
    dataBase.collection('highscores').add({
      'name': nameController.text,
      'score': currentScore,
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: screenWidth > 420 ? 400 : screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //* high scores
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Current Score : $currentScore",
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
                // Divider(
                //   color: Colors.white,
                //   thickness: 2,
                // ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Top Score ",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                    Gap(10),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                      future: letsGetDocsIds,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: highScoreList.length,
                          itemBuilder: (context, index) {
                            return Text(
                              highScoreList[index],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            )),

            //* Game Grid
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0 &&
                      currentDirection != snake_direction.DOWN) {
                    //*move up
                    print('move up');
                    currentDirection = snake_direction.UP;
                  } else if (details.delta.dy > 0 &&
                      currentDirection != snake_direction.UP) {
                    //* move down
                    currentDirection = snake_direction.DOWN;
                    print('move down');
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < 0 &&
                      currentDirection != snake_direction.RIGHT) {
                    //*move left
                    currentDirection = snake_direction.LEFT;
                    print('move left');
                  } else if (details.delta.dx > 0 &&
                      currentDirection != snake_direction.LEFT) {
                    //* move right
                    currentDirection = snake_direction.RIGHT;
                    print('move right');
                  }
                },
                child: GridView.builder(
                  itemCount: totalNumberSquares,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemBuilder: (context, index) {
                    if (snakePosition.contains(index)) {
                      return SnakePixels();
                    } else if (foodPosition == index) {
                      return FoodSnake();
                    } else {
                      return BlankPixels();
                    }
                  },
                ),
              ),
            ),

            //* Play Button
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Center(
                    child: MaterialButton(
                      minWidth: 100,
                      height: 50,
                      color: hasStarted ? Colors.grey : Colors.pink,
                      onPressed: hasStarted ? () {} : startGame,
                      child: Text(
                        "Play",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                //!todo  do this
                Container(
                  child: Center(
                    child: MaterialButton(
                      minWidth: 100,
                      height: 50,
                      color: hasStarted ? Colors.grey : Colors.pink,
                      onPressed: hasStarted ? () {} : startGame,
                      child: Text(
                        "Stop",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
