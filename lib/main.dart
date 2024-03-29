import 'package:flutter/material.dart';
import 'package:sqflite_learning/add_note.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(
        title: 'Notes',
      ),
      routes: {
        "add_notes": (context) => const AddNote(),
      },
    );
  }
}
