// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:snake_game/widgets/blank_pixels.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalNumberSquares = 100;
  int rowSize = 10;
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
            child: GridView.builder(
              itemCount: totalNumberSquares,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowSize,
              ),
              itemBuilder: (context, index) {
                return BlankPixels();
              },
            ),
          ),

          //* Play Button
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
