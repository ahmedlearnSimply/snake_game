// ignore_for_file: prefer_const_constructors

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/screens/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCzV7jrtLo46_zBcxB-7jrzt83v8vunvvg",
        authDomain: "snakegame-9c444.firebaseapp.com",
        projectId: "snakegame-9c444",
        storageBucket: "snakegame-9c444.firebasestorage.app",
        messagingSenderId: "503762102792",
        appId: "1:503762102792:web:7c6351c3ec661896157fbd",
        measurementId: "G-07JZNJRZCL"),
  );

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
