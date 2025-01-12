// ignore_for_file: prefer_const_constructors

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/screens/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFirestore.instance.collection('highScores');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
