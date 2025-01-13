// ignore_for_file: prefer_const_constructors

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HighScoreTile extends StatelessWidget {
  final String documentId;
  HighScoreTile({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference highScore =
        FirebaseFirestore.instance.collection('highscores');
    return FutureBuilder(
      future: highScore.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            children: [
              Text(
                data["name"],
                style: TextStyle(color: Colors.white),
              ),
              Gap(5),
              Text(
                data["score"].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          );
        } else {
          return Text(
            "Loading...",
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }
}
