// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game/widgets/blank_pixels.dart';
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

  //* snake position
  List<int> snakePosition = [
    0,
    1,
    2,
  ];

  //* some of vars
  int totalNumberSquares = 100;
  int rowSize = 10;

  //* snake direction is initially to the right
  var currentDirection = snake_direction.RIGHT;

  //* start game method
  void startGame() {
    Timer.periodic(
      Duration(milliseconds: 200),
      (timer) {
        setState(() {
          //* generate new food position

          //* generate new snake position

          //* Keep the Snake Moving
          moveSnake();
        });
      },
    );
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

    // Add new head and remove tail
    snakePosition.add(newHeadPosition);
    snakePosition.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //* high scores
          Expanded(child: Container()),

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
              child: Container(
            child: Center(
              child: MaterialButton(
                minWidth: 100,
                height: 50,
                color: Colors.pink,
                onPressed: startGame,
                child: Text(
                  "Play",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
