import 'package:flutter/material.dart';

import 'controllers/quiz_controller.dart';
import 'widgets/QuizScreen/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = QuizController();

    return MaterialApp(
      title: 'Geo Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
    );
  }
}